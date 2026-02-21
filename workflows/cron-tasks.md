# Cron 任务详细设计

> 每 15 分钟自检一次 + 每天 3 次 GitHub 同步

---

## 时间线

### 15 分钟循环 (永动)

| 时间 | 任务 |
|------|------|
| 00 | 自检 |
| 15 | 自检 |
| 30 | 自检 |
| 45 | 自检 |

### 每日固定 (3次)

| 时间 | 任务 |
|------|------|
| 08:00 | GitHub Pull |
| 16:00 | GitHub Pull |
| 22:00 | GitHub Push |

### 每周固定

| 时间 | 任务 |
|------|------|
| 周日 10:00 | Knowledge 巡检 |
| 周日 11:00 | 框架文档更新 |
| 周日 12:00 | Agent 状态检查 |

---

## 自检任务 (每 15 分钟)

### 检查清单

```yaml
self_check:
  - name: check_openclaw_status
    action: openclaw gateway status
    alert_if: error

  - name: check_github_sync
    action: git fetch origin && git status
    alert_if: behind

  - name: check_pending_tasks
    action: read SUBAGENT_TASKS.json
    alert_if: blocked > 3

  - name: check_memory_usage
    action: check context tokens
    alert_if: > 3500

  - name: check_eternal_engine
    action: read eternal-engine.md
    alert_if: task_overdue > 0
```

---

## GitHub 同步

### 08:00 - 早晨同步

```bash
#!/bin/bash
# morning-sync.sh

cd ~/helix-framework

# 1. 拉取最新
git fetch origin
git pull origin master

# 2. 检查更新
UPDATED=$(git diff --name-only HEAD origin/master)

if [ -n "$UPDATED" ]; then
  echo "Updated files:"
  echo "$UPDATED"
  
  # 3. 如果有重要更新，重新加载
  for file in $UPDATED; do
    case $file in
      roles/*.md) echo "Reloading roles..." ;;
      workflows/*.md) echo "Reloading workflows..." ;;
      knowledge/*.md) echo "Reloading knowledge..." ;;
    esac
  done
fi

echo "Morning sync complete: $(date)"
```

### 16:00 - 下午同步

```bash
#!/bin/bash
# afternoon-sync.sh

cd ~/helix-framework

# 1. 拉取最新
git fetch origin
git pull origin master

# 2. 验证配置完整性
echo "Checking configs..."

# 3. 记录状态
echo "Afternoon sync complete: $(date)"
```

### 22:00 - 晚间同步 + 推送

```bash
#!/bin/bash
# night-sync.sh

cd ~/helix-framework

# 1. 检查本地变更
git status

# 2. 如果有变更，添加并提交
if [ -n "$(git status --porcelain)" ]; then
  git add .
  git commit -m "update: $(date +%Y-%m-%d)"
  git push origin master
  echo "Pushed local changes"
else
  echo "No local changes to push"
fi

# 3. 拉取远程最新
git pull origin master

echo "Night sync complete: $(date)"
```

---

## 每周任务

### Sunday 10:00 - Knowledge 巡检

```bash
#!/bin/bash
# knowledge-check.sh

cd ~/helix-framework/knowledge

# 1. 检查过期文档
find . -name "*.md" -mtime +90

# 2. 检查链接有效性
# ...

# 3. 清理归档
echo "Knowledge check complete"
```

### Sunday 11:00 - 框架文档更新

```bash
# 更新 README 索引
# 检查缺失的文档
# 更新版本号
```

### Sunday 12:00 - Agent 状态检查

```bash
# 检查所有 Agent 配置
# 验证角色文档完整性
# 测试通信协议
```

---

## OpenClaw Cron 配置

```yaml
# ~/.openclaw/config.yaml

cron:
  enabled: true
  timezone: Asia/Kuala_Lumpur

  jobs:
    # 自检 - 每 15 分钟
    - name: self-check
      schedule: "*/15 * * * *"
      action: |
        echo "Self check..."
      log: /app/logs/self-check.log
    
    # GitHub Pull - 早晨
    - name: github-morning
      schedule: "0 8 * * *"
      action: bash scripts/morning-sync.sh
      notification: on_failure
    
    # GitHub Pull - 下午
    - name: github-afternoon
      schedule: "0 16 * * *"
      action: bash scripts/afternoon-sync.sh
      notification: on_failure
    
    # GitHub Push - 晚间
    - name: github-night
      schedule: "0 22 * * *"
      action: bash scripts/night-sync.sh
      notification: on_failure
    
    # 每周 Knowledge 巡检
    - name: knowledge-weekly
      schedule: "0 10 * * 0"
      action: bash scripts/knowledge-check.sh
    
    # 每周 Agent 状态
    - name: agent-status-weekly
      schedule: "0 12 * * 0"
      action: openclaw status
```

---

## 告警规则

| 事件 | 通知 | 级别 |
|------|------|------|
| 自检失败 | 不通知 | - |
| GitHub sync 失败 | 消息 | Warning |
| 任务阻塞 > 3 | 消息 | Critical |
| 连续 3 次自检失败 | 消息 + 邮件 | Critical |

---

## 状态追踪

```json
{
  "self_check": {
    "last_run": "2026-02-21T18:30:00Z",
    "status": "healthy",
    "checks": {
      "openclaw": "ok",
      "github": "ok",
      "tasks": "ok",
      "memory": "ok",
      "engine": "ok"
    }
  },
  "github_sync": {
    "last_morning": "2026-02-21T08:00:00Z",
    "last_afternoon": "2026-02-21T16:00:00Z",
    "last_night": "2026-02-21T22:00:00Z"
  },
  "weekly": {
    "last_knowledge": "2026-02-16T10:00:00Z",
    "last_docs": "2026-02-16T11:00:00Z",
    "last_agents": "2026-02-16T12:00:00Z"
  }
}
```

---

## 实现方式

### 方案 1: OpenClaw 内置 Cron

```bash
openclaw cron enable
```

### 方案 2: GitHub Actions

```yaml
# .github/workflows/self-check.yml
name: Self Check
on:
  schedule:
    - cron: '*/15 * * * *'
  workflow_dispatch:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Self check
        run: echo "Self check..."
```

### 方案 3: 系统 crontab

```bash
# 编辑 crontab
crontab -e

# 添加
*/15 * * * * /home/dm/helix-framework/scripts/self-check.sh
```

---

*建议使用 GitHub Actions，零维护*
