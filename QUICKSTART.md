# Quick Start - 5 分钟启动

> 本指南帮助你快速搭建 Helix Agent Framework

---

## 前置要求

- OpenClaw 已安装
- GitHub 账号 + `gh` CLI 已配置
- 至少 2 个 API Key（推荐）

---

## Step 1: 克隆框架

```bash
git clone https://github.com/fatdm54/helix-framework.git
cd helix-framework
```

---

## Step 2: 配置 Agent

在 OpenClaw 中创建以下 Agent：

### 必需 Agent

| Agent | 模型 | 描述 |
|-------|------|------|
| Helix | gpt-4o / claude | 调度中枢 |
| Codex | codex / gpt-5.3-codex | 代码开发 |
| Researcher | gpt-4o / claude | 调研分析 |

### 可选 Agent

| Agent | 模型 | 描述 |
|-------|------|------|
| Reviewer | claude | 代码审查 |
| Tester | gpt-4o | 测试执行 |
| Documenter | gpt-4o | 文档维护 |
| Scheduler | gpt-4o | 负载调度 |
| Evaluator | claude | 质量评估 |
| Learning | gpt-4o | 学习进化 |
| Guardian | gpt-4o | 安全监控 |

---

## Step 3: 分配角色文档

每个 Agent 读取对应角色文档：

```
roles/helix.md      → Helix
roles/codex.md     → Codex
roles/researcher.md → Researcher
...以此类推
```

---

## Step 4: 启动

```bash
# 启动 OpenClaw
openclaw gateway start

# 验证 Agent
openclaw status
```

---

## Step 5: 首次任务

```
你: "帮我做一个计算器 Web 应用"

Helix 会:
1. 理解需求
2. 拆分成子任务
3. 派发给 Codex
4. 验收结果
5. 反馈给你
```

---

## 验证清单

- [ ] Agent 已创建
- [ ] 角色文档已读取
- [ ] OpenClaw 已启动
- [ ] 首次任务完成

---

## 下一步

- [ ] 添加更多 Agent
- [ ] 配置 GitHub Issues 作为任务池
- [ ] 启用自动知识库更新

---

*有问题？提交 Issue: https://github.com/fatdm54/helix-framework/issues*
