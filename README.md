# Helix Agent Framework

<p align="center">
  <img src="https://img.shields.io/badge/version-v4.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/OpenClaw-ready-orange" alt="OpenClaw">
</p>

> 🤖 自主进化的 AI 协作框架 - 让 AI 团队像人类团队一样工作

<p align="center">
  <strong>English</strong> · <a href="README_CN.md">中文</a>
</p>

---

## 🎯 目标

打造一个**自闭环、可持续进化**的 Agent 生态圈：

- ✅ **分工合作**: 10 个角色，各司其职
- ✅ **独立隔离**: Context 限制，职责分明
- ✅ **防幻觉**: 多重验证，证据驱动
- ✅ **自我进化**: 任务 → 复盘 → 知识 → 优化
- ✅ **开箱即用**: 5 分钟启动

---

## 🏢 架构

```
                           ┌──────────────────────────────────────┐
                           │         Helix (CEO)                 │
                           │    战略决策 + 任务分发 + 验收         │
                           └──────────────────┬───────────────────┘
                                              │
          ┌───────────────┬───────────────────┼───────────────────┐
          │               │                   │                   │
          ▼               ▼                   ▼                   ▼
   ┌────────────┐  ┌────────────┐      ┌────────────┐      ┌────────────┐
   │   Codex    │  │ Researcher│      │ Scheduler  │      │  Guardian  │
   │ 首席开发者  │  │ 首席调研员  │      │ 资源协调员   │      │ 安全守护者  │
   └─────┬──────┘  └─────┬──────┘      └─────────────┘      └─────────────┘
         │               │
         └───────────────┼───────────────────────┐
                         │                       │
                         ▼                       ▼
               ┌────────────────┐      ┌────────────────┐
               │  Reviewer      │      │    Tester      │
               │  代码审查员    │      │   测试工程师   │
               └────────┬───────┘      └────────┬───────┘
                        │                       │
                        └───────────┬───────────┘
                                    │
                        ┌───────────▼───────────┐
                        │    Evaluator          │
                        │    自检评估员          │
                        └───────────┬───────────┘
                                    │
                        ┌───────────▼───────────┐
                        │    Learning           │
                        │    进化工程师         │
                        └───────────┬───────────┘
                                    │
                        ┌───────────▼───────────┐
                        │    Documenter         │
                        │    文档工程师         │
                        └───────────────────────┘
```

---

## 📦 10 个角色

| # | Agent | 角色 | 核心职责 |
|---|-------|------|----------|
| 1 | **Helix** | CEO | 战略决策、任务分发、验收 |
| 2 | **Codex** | 首席开发者 | 代码实现、自测、复盘 |
| 3 | **Researcher** | 首席调研员 | 调研分析、知识归档 |
| 4 | **Reviewer** | 代码审查员 | 代码审查、风险识别 |
| 5 | **Tester** | 测试工程师 | 测试编写、缺陷报告 |
| 6 | **Documenter** | 文档工程师 | 文档编写、知识整理 |
| 7 | **Scheduler** | 资源协调员 | 负载监控、任务队列 |
| 8 | **Evaluator** | 自检评估员 | 任务评估、Agent 考核 |
| 9 | **Learning** | 进化工程师 | 经验收集、模式识别 |
| 10 | **Guardian** | 安全守护者 | 安全扫描、健康监控 |

---

## 🚀 快速开始

### 5 分钟启动

```bash
# 1. 克隆
git clone https://github.com/fatdm54/helix-framework.git
cd helix-framework

# 2. 配置 Agent
# 见 QUICKSTART.md

# 3. 启动
openclaw gateway start
```

**详见**: [QUICKSTART.md](./QUICKSTART.md)

---

## 📁 目录

```
helix-framework/
├── README.md              ← 你在这里
├── QUICKSTART.md          ← 5 分钟启动
├── CONTRIBUTING.md        ← 贡献指南
├── LICENSE                ← MIT 协议
│
├── roles/                 ← 角色定义 (10 个)
│   ├── helix.md
│   ├── codex.md
│   ├── researcher.md
│   ├── reviewer.md
│   ├── tester.md
│   ├── documenter.md
│   ├── guardian.md
│   ├── evaluator.md
│   ├── learning.md
│   └── scheduler.md
│
├── workflows/             ← 工作流
│   ├── ecosystem.md       ← 完整闭环
│   ├── task-assignment.md
│   └── self-improvement.md
│
├── templates/             ← 模板
│   ├── task-template.md
│   └── research-template.md
│
├── configs/               ← 配置示例
│   └── agents.yaml
│
├── examples/              ← 完整示例
│   └── web-api-workflow.md
│
└── knowledge/            ← 知识库（自动更新）
```

---

## ⚙️ 核心规则

| 规则 | 限制 |
|------|------|
| Context 硬限 | 单任务 ≤ 4000 tokens |
| Codex 并发 | 最多 2 个任务 |
| Researcher 并发 | 最多 3 个任务 |
| 任务超时 | 单任务 ≤ 30 分钟 |
| 验收标准 | 每个任务必须有明确验收项 |

---

## 🔄 自闭环机制

```
任务 → 执行 → 复盘 → 经验 → 知识库 → 更强执行
                ↑                        │
                └────────────────────────┘
```

---

## 🤝 贡献

欢迎贡献！见 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 📝 许可证

MIT License - 见 [LICENSE](./LICENSE)

---

## 🧭 Maintainer

**Helix** - 框架主导者  
**Team**: Codex, Researcher, Reviewer, Tester, Documenter, Guardian, Evaluator, Learning, Scheduler

---

*让每个团队都拥有自己的 AI 协作团队 🧭*
