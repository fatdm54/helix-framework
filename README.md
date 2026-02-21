# Helix Agent Framework

<p align="center">
  <img src="https://img.shields.io/badge/version-v4.1-blue" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/OpenClaw-ready-orange" alt="OpenClaw">
</p>

> 🤖 自主进化的 AI 协作框架 - 让 AI 团队像人类团队一样工作

---

## 快速导航

| 分类 | 内容 | 文件 |
|------|------|------|
| 🚀 快速开始 | 5 分钟启动 | [QUICKSTART.md](./QUICKSTART.md) |
| 🏗️ 架构设计 | 完整闭环 | [workflows/ecosystem.md](./workflows/ecosystem.md) |
| 👥 10 个角色 | 角色定义 | [roles/](./roles/) |
| 🔄 工作流 | 任务流程 | [workflows/](./workflows/) |
| 🐳 Docker | 一键部署 | [docker/](./docker/) |
| 📝 模板 | 10 个模板 | [templates/](./templates/all.md) |
| 🧠 知识库 | 经验积累 | [knowledge/](./knowledge/) |
| ⚙️ 配置 | Agent 配置 | [configs/](./configs/) |
| 📚 指南 | 详细指南 | [guides/](./guides/) |

---

## 目录

### 入门

- [QUICKSTART.md](./QUICKSTART.md) - 5 分钟快速启动
- [README.md](./README.md) - 项目介绍
- [CONTRIBUTING.md](./CONTRIBUTING.md) - 贡献指南

### 角色定义 (roles/)

| Agent | 文件 | 描述 |
|-------|------|------|
| Helix | [helix.md](./roles/helix.md) | 调度 CEO |
| Codex | [codex.md](./roles/codex.md) | 首席开发者 v2.1 |
| Researcher | [researcher.md](./roles/researcher.md) | 首席调研员 v2.1 |
| Reviewer | [reviewer.md](./roles/reviewer.md) | 代码审查员 |
| Tester | [tester.md](./roles/tester.md) | 测试工程师 |
| Documenter | [documenter.md](./roles/documenter.md) | 文档工程师 |
| Scheduler | [scheduler.md](./roles/scheduler.md) | 资源协调员 |
| Evaluator | [evaluator.md](./roles/evaluator.md) | 自检评估员 |
| Learning | [learning.md](./roles/learning.md) | 进化工程师 v2.0 |
| Guardian | [guardian.md](./roles/guardian.md) | 安全守护者 |

### 工作流 (workflows/)

- [ecosystem.md](./workflows/ecosystem.md) - 完整闭环架构
- [task-assignment.md](./workflows/task-assignment.md) - 任务分配
- [self-improvement.md](./workflows/self-improvement.md) - 自提升机制
- [skill-verification.md](./workflows/skill-verification.md) - Skill 验证流程
- [cron-tasks.md](./workflows/cron-tasks.md) - Cron 任务设计
- [agent-protocol.md](./workflows/agent-protocol.md) - Agent 通信协议
- [self-check.md](./workflows/self-check.md) - 自检机制

### 模板 (templates/)

- [all.md](./templates/all.md) - 10 个模板合集
- [task-template.md](./templates/task-template.md) - 任务模板
- [research-template.md](./templates/research-template.md) - 调研模板

### 知识库 (knowledge/)

- [README.md](./knowledge/README.md) - 知识库索引
- [skills/](./knowledge/skills/) - Agent 技能定义
- [skills-verified/](./knowledge/skills-verified/) - 已验证 skills
- [skills-scenarios.md](./knowledge/skills-scenarios.md) - 使用场景

### Docker 部署 (docker/)

- [DEPLOY.md](./docker/DEPLOY.md) - 部署文档
- [docker-compose.yml](./docker/docker-compose.yml) - 完整配置
- [.env.example](./docker/.env.example) - 环境变量模板
- [agents/](./docker/agents/) - 各个 Agent 的 Dockerfile

### 配置 (configs/)

- [full-config.yaml](./configs/full-config.yaml) - 完整 Agent 配置
- [agents.yaml](./configs/agents.yaml) - 基础配置

### 指南 (guides/)

- [github-to-agent.md](./guides/github-to-agent.md) - 从 GitHub 创建 Agent

### 其他

- [eternal-engine.md](./eternal-engine.md) - 永动机任务池
- [LICENSE](./LICENSE) - MIT 协议
- [.gitignore](./.gitignore) - Git 忽略配置

---

## 核心规则

| 规则 | 限制 |
|------|------|
| Context 硬限 | 单任务 ≤ 4000 tokens |
| Codex 并发 | 最多 2 个任务 |
| Researcher 并发 | 最多 3 个任务 |
| 任务超时 | 单任务 ≤ 30 分钟 |
| 自检频率 | 每 15 分钟 |
| GitHub 同步 | 每天 3 次 |

---

## 自闭环机制

```
任务 → 执行 → 复盘 → 经验 → 知识库 → 更强执行
                ↑                        │
                └────────────────────────┘
```

---

## 技术栈

- **OpenClaw** - 本地 AI 助手
- **GitHub** - 代码托管 + Actions
- **Docker** - 容器化部署
- **gh CLI** - GitHub 命令行

---

## 状态

- ✅ 10 个角色定义完成
- ✅ Docker 一键部署
- ✅ 完整工作流
- ✅ 10 个模板
- ✅ Cron 任务设计
- ✅ Agent 通信协议
- ✅ 自检机制
- 🔄 持续优化中

---

## License

MIT - 见 [LICENSE](./LICENSE)

---

## GitHub

https://github.com/fatdm54/helix-framework

---

*让每个团队都拥有自己的 AI 协作团队 🧭*
