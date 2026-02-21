# 自检机制设计

> 每 15 分钟执行一次的系统自检

---

## 自检流程

```
定时触发 → 检查清单 → 生成报告 → 告警判断 → 记录 → 循环
```

---

## 检查清单

### 1. OpenClaw 状态

```yaml
check:
  name: openclaw_status
  command: openclaw gateway status
  expected: running
  alert_if: error
```

### 2. GitHub 同步

```yaml
check:
  name: github_sync
  command: git fetch origin && git status
  expected: up to date
  alert_if: behind > 3 commits
```

### 3. 任务队列

```yaml
check:
  name: task_queue
  read: SUBAGENT_TASKS.json
  expected: no blocked > 3
  alert_if: blocked > 3
```

### 4. Context 使用

```yaml
check:
  name: context_usage
  check: current tokens
  expected: < 3500
  alert_if: > 3500
```

### 5. 磁盘空间

```yaml
check:
  name: disk_space
  check: df -h
  expected: < 70%
  alert_if: > 90%
```

### 6. 日志错误

```yaml
check:
  name: error_logs
  check: recent errors
  expected: 0 critical
  alert_if: critical > 0
```

---

## 检查脚本

```bash
#!/bin/bash
# self-check.sh

TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
STATUS="healthy"
ALERTS=[]

# 1. OpenClaw 状态
if ! openclaw gateway status > /dev/null 2>&1; then
  ALERTS+=("OpenClaw not running")
  STATUS="unhealthy"
fi

# 2. GitHub 同步
BEHIND=$(git rev-list HEAD..origin/master --count)
if [ "$BEHIND" -gt 3 ]; then
  ALERTS+=("GitHub $BEHIND commits behind")
  STATUS="warning"
fi

# 3. 任务阻塞
BLOCKED=$(jq '[.tasks[] | select(.status == "blocked")] | length' SUBAGENT_TASKS.json)
if [ "$BLOCKED" -gt 3 ]; then
  ALERTS+=("$BLOCKED tasks blocked")
  STATUS="warning"
fi

# 输出结果
echo "{
  \"timestamp\": \"$TIMESTAMP\",
  \"status\": \"$STATUS\",
  \"alerts\": $(echo "${ALERTS[@]}" | jq -R . | jq -s .)
}"
```

---

## 告警规则

| 级别 | 条件 | 通知 |
|------|------|------|
| Critical | OpenClaw 停止 | 立即通知 |
| High | 阻塞 > 3 | 消息 |
| Medium | Git 落后 > 3 | 不通知 |
| Low | 轻微问题 | 记录 |

---

## 报告格式

```json
{
  "timestamp": "2026-02-21T19:00:00Z",
  "checks": {
    "openclaw": {"status": "ok", "latency_ms": 100},
    "github": {"status": "ok", "behind": 0},
    "tasks": {"status": "ok", "blocked": 0},
    "context": {"status": "ok", "tokens": 2500},
    "disk": {"status": "ok", "usage": "45%"}
  },
  "status": "healthy",
  "alerts": []
}
```

---

## Cron 配置

```yaml
# 每 15 分钟
self-check:
  schedule: "*/15 * * * *"
  command: bash scripts/self-check.sh
  log: /app/logs/self-check.log
  notification:
    level: high
    channels: ["message"]
```

---

## 巡检日志

```markdown
## 2026-02-21 19:00

- 19:00: ✅ healthy
- 19:15: ✅ healthy
- 19:30: ⚠️ warning (Git 2 commits behind)
- 19:45: ✅ healthy
```

---

## 实现

```python
# self_check.py
import json
import subprocess
from datetime import datetime

def check_openclaw():
    result = subprocess.run(['openclaw', 'gateway', 'status'], capture_output=True)
    return result.returncode == 0

def check_github():
    result = subprocess.run(['git', 'status', '--porcelain'], capture_output=True)
    return len(result.stdout) == 0

def run_checks():
    checks = {
        'openclaw': check_openclaw(),
        'github': check_github(),
    }
    return all(checks.values())

if __name__ == '__main__':
    result = {
        'timestamp': datetime.utcnow().isoformat() + 'Z',
        'healthy': run_checks()
    }
    print(json.dumps(result))
```
