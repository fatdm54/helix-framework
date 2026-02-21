# Docker 一键部署

> 快速启动 Helix Agent Framework（无 memory）

---

## 前置要求

- Docker 已安装
- Docker Compose 已安装
- GitHub Token（用于 gh CLI）

---

## 快速启动

```bash
# 1. 克隆项目
git clone https://github.com/fatdm54/helix-framework.git
cd helix-framework

# 2. 配置环境变量
cp .env.example .env
# 编辑 .env 填入你的 API keys

# 3. 启动
docker-compose up -d

# 4. 查看状态
docker-compose ps
```

---

## 配置

### .env 示例

```bash
# OpenAI
OPENAI_API_KEY=sk-...

# Anthropic
ANTHROPIC_API_KEY=sk-ant-...

# GitHub
GH_TOKEN=ghp_...

# 其他
LOG_LEVEL=info
```

---

## 包含服务

| 服务 | 说明 | 端口 |
|------|------|------|
| helix | 调度中枢 | 3000 |
| codex | 代码开发 | 3001 |
| researcher | 调研员 | 3002 |
| reviewer | 审查员 | 3003 |
| tester | 测试员 | 3004 |
| documenter | 文档员 | 3005 |
| scheduler | 协调员 | 3006 |
| evaluator | 评估员 | 3007 |
| learning | 进化工程师 | 3008 |
| guardian | 安全员 | 3009 |

---

## 每个 Agent 的 Dockerfile

```dockerfile
# codex/Dockerfile
FROM node:20

WORKDIR /app

# 安装 OpenClaw
RUN npm install -g openclaw

# 安装 gh CLI
RUN brew install gh  # 或 apt install gh

# 复制配置
COPY config.yaml /app/

# 复制角色文档
COPY roles/ /app/roles/

# 启动
CMD ["openclaw", "start", "--config", "/app/config.yaml"]
```

---

## 验证流程（改进版）

### 旧版（只看文档）

```
读取 SKILL.md → 记录 → 完成
```

### 新版（真正测试）

```
1. 安装 skill
   openclaw skill install <skill-name>

2. 执行测试命令
   <skill-command> --test

3. 验证结果
   - 成功? → Safe
   - 失败? → 分析原因
   - 危险? → 加入黑名单

4. 记录日志
   - 命令输出
   - 耗时
   - 错误信息
```

### 验证检查表

```markdown
## Skill: <name>

### 安装测试
- [ ] 安装成功
- [ ] 依赖完整
- [ ] 配置有效

### 功能测试
- [ ] 基本命令可用
- [ ] 返回正确结果
- [ ] 错误处理正常

### 安全检查
- [ ] 不需要敏感凭证
- [ ] 不执行危险操作
- [ ] 不泄露数据

### 评估
- 易用性: ⭐
- 安全性: ⭐
- 实用性: ⭐
```

---

## 持续优化机制

### 每次验证后

```python
# 伪代码
def after_verification(skill, result):
    # 1. 记录结果
    save_verification(skill, result)
    
    # 2. 更新索引
    update_index(skill, result)
    
    # 3. 如果失败 → 分析原因
    if result.status == "failed":
        analyze_failure(skill, result.error)
    
    # 4. 如果危险 → 立即告警
    if result.status == "unsafe":
        alert_team(skill, result.reason)
    
    # 5. 生成改进建议
    if result.suggestions:
        save_suggestion(skill, result.suggestions)
```

### 每周检查

- 回顾本周验证的 skills
- 更新使用场景
- 识别有价值的新 skills
- 清理过时的验证记录

### 每月优化

- 分析验证成功率
- 改进验证流程
- 更新文档
- 同步到 GitHub

---

## 验证日志格式

```json
{
  "skill_name": "github",
  "verified_at": "2026-02-21T09:00:00Z",
  "source": "github.com/openclaw/skills",
  "install": {
    "success": true,
    "duration_ms": 5000,
    "error": null
  },
  "function": {
    "test_command": "gh auth status",
    "success": true,
    "output": "Logged in as fatdm54",
    "duration_ms": 2000
  },
  "security": {
    "requires_credentials": true,
    "dangerous_operations": false,
    "data_exposure": false
  },
  "status": "safe",
  "scenarios": ["create_repo", "push_code", "pr_management"],
  "notes": "Works well, needs gh auth first"
}
```

---

## 任务分配

### Helix（我）

- 每天早上从官方 repo 随机选 5 个
- 派发给 Researcher 验证
- 验收结果
- 更新知识库
- 同步 GitHub

### Researcher

- 安装 skill
- 执行测试
- 记录日志
- 提出使用场景

### Learning

- 分析验证数据
- 识别模式
- 优化流程

---

## Cron 设置

```yaml
# 每天 09:00 - 选择 skills
# 每天 10:00-17:00 - 验证测试
# 每天 18:00 - 汇总更新
# 每天 22:00 - GitHub 同步
```

---

## 总结

### 改进点

1. **真正测试** - 安装 + 执行 + 验证结果
2. **结构化日志** - JSON 格式便于分析
3. **持续优化** - 每周每月有回顾
4. **一键部署** - Docker 快速启动

### 待实现

- [ ] 创建 docker-compose.yml
- [ ] 为每个 agent 创建 Dockerfile
- [ ] 改进验证脚本
- [ ] 设置 Cron 任务
