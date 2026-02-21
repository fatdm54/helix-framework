# Cron 任务设计

> 自动化任务调度

---

## GitHub 同步策略

### 目标

- 每天同步 GitHub 1-3 次
- 保持本地与 GitHub 一致
- 自动更新知识库

### 同步时间

| # | 时间 | 间隔 | 用途 |
|---|------|------|------|
| 1 | 08:00 | - | 早晨同步，获取最新任务 |
| 2 | 16:00 | 8h | 下午同步，检查更新 |
| 3 | 22:00 | 6h | 晚间同步，最终确认 |

---

## 同步任务设计

### 任务 1: GitHub Pull

```yaml
name: github-sync-morning
schedule: "0 8 * * *"  # 每天 08:00
action: |
  1. git fetch origin
  2. git pull origin master
  3. 检查更新文件
  4. 更新本地 knowledge/

env:
  REPO: fatdm54/helix-framework
  BRANCH: master
```

### 任务 2: GitHub Pull + Knowledge Update

```yaml
name: github-sync-afternoon
schedule: "0 16 * * *"  # 每天 16:00
action: |
  1. git fetch + pull
  2. 读取更新的 roles/*.md
  3. 更新 Agent 知识库
  4. 验证配置完整性
```

### 任务 3: GitHub Push + Daily Report

```yaml
name: github-sync-night
schedule: "0 22 * * *"  # 每天 22:00
action: |
  1. git add .
  2. 检查变更
  3. 如果有新内容 → commit + push
  4. 生成每日报告
  5. 推送到 GitHub
```

---

## 其他 Cron 任务

### 任务 4: 健康检查

```yaml
name: healthcheck-daily
schedule: "0 9 * * *"  # 每天 09:00
action: |
  1. 检查 OpenClaw 状态
  2. 检查 Agent 活跃度
  3. 检查 GitHub sync 状态
  4. 报告异常
```

### 任务 5: Learning 分析

```yaml
name: learning-daily
schedule: "0 23 * * *"  # 每天 23:00
action: |
  1. 读取当日任务日志
  2. 分析成功/失败模式
  3. 更新 knowledge/
  4. 生成进化建议
```

### 任务 6: Knowledge 巡检

```yaml
name: knowledge-weekly
schedule: "0 10 * * 0"  # 每周日 10:00
action: |
  1. 检查过期文档
  2. 验证链接有效性
  3. 整理 knowledge/
  4. 归档过时内容
```

---

## OpenClaw Cron 配置

```yaml
# ~/.openclaw/config.yaml

cron:
  enabled: true
  
  jobs:
    - name: github-sync
      schedule: "0 8,16,22 * * *"
      command: |
        cd ~/helix-framework
        git fetch origin
        git pull origin master
      notification: true
    
    - name: github-push
      schedule: "0 22 * * *"
      command: |
        cd ~/helix-framework
        git add .
        git commit -m "daily update $(date +%Y-%m-%d)"
        git push
      condition: has_changes  # 只在有变更时执行
    
    - name: healthcheck
      schedule: "0 9 * * *"
      command: openclaw gateway status
      notification: critical_only
    
    - name: learning-analyze
      schedule: "0 23 * * *"
      command: echo "Learning analysis..."
      # Learning Agent 自动执行
```

---

## 通知规则

| 事件 | 通知方式 | 级别 |
|------|----------|------|
| GitHub sync 成功 | 不通知 | - |
| GitHub sync 失败 | 消息 | Warning |
| Healthcheck 失败 | 消息 + 邮件 | Critical |
| 发现新 Issue | 消息 | Info |

---

## 状态追踪

```json
{
  "last_sync": "2026-02-21T22:00:00Z",
  "sync_count_today": 3,
  "last_healthcheck": "2026-02-21T09:00:00Z",
  "health": "healthy",
  "learning_analyzed": true
}
```

---

## 实现方式

### 方案 A: OpenClaw 内置 Cron

```bash
# 开启 cron
openclaw cron enable

# 添加任务
openclaw cron add --name github-sync --schedule "0 8,16,22 * *" --command "git -C ~/helix-framework pull"
```

### 方案 B: 系统 crontab

```bash
# 编辑 crontab
crontab -e

# 添加
0 8,16,22 * * * cd ~/helix-framework && git fetch origin && git pull origin master
```

### 方案 C: GitHub Actions (推荐)

```yaml
# .github/workflows/sync.yml
name: Daily Sync
on:
  schedule:
    - cron: '0 8,16,22 * * *'
jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Sync
        run: |
          git fetch origin
          git pull origin master
```

---

*建议使用 GitHub Actions，零维护*
