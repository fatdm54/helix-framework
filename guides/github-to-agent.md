# 从 GitHub 创建 Agent

> 如何把 GitHub 上的角色配置快速变成可用的 Agent

---

## 方案对比

| 方案 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| A) GitHub API → 本地文件 | 灵活 | 需要写脚本 | ⭐⭐⭐ |
| B) GitHub Template Repository | 官方支持 | 只支持 GitHub 账号登录 | ⭐⭐⭐⭐ |
| C) GitHub Actions + OpenClaw | 自动化 | 需要配置 | ⭐⭐⭐⭐⭐ |
| D) 手动复制粘贴 | 简单 | 繁琐 | ⭐⭐ |

---

## 方案 A: GitHub API (推荐)

### 步骤 1: 获取配置

```bash
# 获取单个角色配置
gh api repos/fatdm54/helix-framework/contents/roles/helix.md > roles/helix.md

# 获取全部配置
gh api repos/fatdm54/helix-framework/contents/roles --jq '.[].name' | \
  while read f; do
    gh api repos/fatdm54/helix-framework/contents/roles/$f > roles/$f
  done
```

### 步骤 2: 创建 Agent

```bash
# 创建 Codex Agent
openclaw agent create --name Codex --config roles/codex.yaml

# 创建 Researcher Agent
openclaw agent create --name Researcher --config roles/researcher.yaml
```

### 脚本: 一键同步

```bash
#!/bin/bash
# sync-agents.sh

REPO="fatdm54/helix-framework"
LOCAL_DIR="~/helix-framework/roles"

# Pull latest
git -C $LOCAL_DIR fetch origin
git -C $LOCAL_DIR pull origin master

# Create/update agents
for file in $LOCAL_DIR/*.md; do
  agent_name=$(basename $file .md)
  echo "Syncing $agent_name..."
  # 转换 MD 为配置并创建 agent
done

echo "Done!"
```

---

## 方案 B: GitHub Template Repository

### 1. 创建 Template Repo

```bash
# 在 GitHub 创建新 repo 时勾选 "Template repository"
# 或者把 helix-framework 设为 template
```

### 2. 用户使用

```bash
# 用户点击 "Use this template"
# 填入自己的 repo 名
# 自动获得完整结构
```

### 3. 配置 Agent

```bash
# Clone 自己的 repo
git clone https://github.com/YOUR_NAME/agent-config.git
cd agent-config

# 创建 Agent
openclaw agent create --config configs/helix.yaml
```

---

## 方案 C: GitHub Actions (自动化)

### 1. 添加 Action

```yaml
# .github/workflows/create-agent.yml
name: Create Agent

on:
  push:
    branches:
      - main
    paths:
      - 'roles/*.md'
      - 'configs/*.yaml'

jobs:
  create-agent:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Create Agent
        run: |
          # 遍历配置文件
          for config in configs/*.yaml; do
            agent_name=$(basename $config .yaml)
            # 调用 OpenClaw API 创建 agent
            curl -X POST $OPENCLAW_URL/api/agents \
              -H "Authorization: Bearer $OPENCLAW_TOKEN" \
              -d @$config
          done
        env:
          OPENCLAW_URL: ${{ secrets.OPENCLAW_URL }}
          OPENCLAW_TOKEN: ${{ secrets.OPENCLAW_TOKEN }}
```

### 2. 配置 Secrets

在 GitHub repo 设置中添加：
- `OPENCLAW_URL`: OpenClaw 服务地址
- `OPENCLAW_TOKEN`: API 密钥

---

## 方案 D: 手动 (最简单)

### 用户操作

1. 访问 https://github.com/fatdm54/helix-framework
2. 点击 "Code" → "Download ZIP"
3. 解压后复制到本地 `~/.openclaw/agents/`
4. 修改配置中的 model
5. 重启 OpenClaw

---

## 推荐工作流

```
用户                GitHub              本地 OpenClaw
  │                    │                      │
  ├─clone repo ───────►│                      │
  │                    │                      │
  ├─edit config ──────►│                      │
  │                    │                      │
  ├─commit ───────────►│                      │
  │                    │                      │
  │              ┌─────▼─────┐                │
  │              │ Actions   │                │
  │              └─────┬─────┘                │
  │                    │                      │
  │                    ├──── pull ────────────►│
  │                    │                      │
  │                    │                      ├─reload agents
  │                    │                      │
```

---

## 快速开始

### 首次设置

```bash
# 1. Clone 配置
git clone https://github.com/fatdm54/helix-framework.git ~/helix-framework

# 2. 进入目录
cd ~/helix-framework

# 3. 创建符号链接（可选）
ln -s ~/helix-framework/configs ~/.openclaw/agents

# 4. 重启 OpenClaw
openclaw gateway restart
```

### 日常使用

```bash
# 1. 每天早上同步
git pull

# 2. 修改配置
vim roles/codex.md

# 3. 提交
git add .
git commit -m "update: xxx"
git push

# 4. OpenClaw 自动重载（需配置）
```

---

## 自动化脚本

```bash
#!/bin/bash
# sync-helix.sh - 一键同步 + 创建 Agent

set -e

echo "🔄 Syncing Helix Framework..."

# 1. Pull latest
cd ~/helix-framework
git fetch origin
git pull origin master

# 2. Reload configs
openclaw gateway restart

# 3. Verify
openclaw status

echo "✅ Sync complete!"
```

---

## 故障排查

| 问题 | 解决 |
|------|------|
| 同步失败 | 检查 gh auth 状态 |
| Agent 不生效 | 重启 OpenClaw |
| 权限不足 | 检查 token scope |
| 冲突 | git rebase 或 merge |

---

*推荐: 新手用方案 D (手动)，熟悉后用方案 A (脚本)*
