# Helix Agent Framework

> 任务调度框架 - 让 AI 自主协作  
> 版本: v3.2 (2026-02-21)

---

## 目标

- 分工合作：Helix 调度，Codex 执行，Researcher 调研
- 独立隔离：每个 agent 职责清晰，context 有限制
- 自我提升：任务 → 反思 → 文档更新 → 更强
- 防幻觉：每步验证，来源必查

---

## 架构

```
User → Helix (调度) → Codex / Researcher → 验收 → 反馈
                          ↑
                    [知识库共享]
```

---

## 目录

### 角色定义 (roles/)

| Agent | 文档 | 职责 |
|-------|------|------|
| Helix | [roles/helix.md](./roles/helix.md) | 任务拆分、派发、验收 |
| Codex | [roles/codex.md](./roles/codex.md) | 代码开发、执行 |
| Researcher | [roles/researcher.md](./roles/researcher.md) | 调研、分析 |

### 工作流 (workflows/)

- [workflows/task-assignment.md](./workflows/task-assignment.md) - 任务分配流程
- [workflows/self-improvement.md](./workflows/self-improvement.md) - 自提升机制

### 模板 (templates/)

- [templates/task-template.md](./templates/task-template.md) - Codex 任务模板
- [templates/research-template.md](./templates/research-template.md) - Researcher 调研模板

### 知识库 (knowledge/)

- `knowledge/codex-best-practices.md` - Codex 经验积累（自动更新）
- `knowledge/research-index.md` - 调研索引（自动更新）

---

## 快速开始

1. **配置 Agent**: 在 OpenClaw 中注册 Codex + Researcher
2. **分配角色**: 每个 agent 读取对应 `roles/*.md`
3. **开始任务**: 用户告诉 Helix 需求，Helix 拆分并派发

---

## 核心规则

| 规则 | 说明 |
|------|------|
| Context 硬限 | 单任务 ≤4000 tokens |
| Codex 并发 | 最多 2 个任务 |
| Researcher 并发 | 最多 3 个任务 |
| 任务超时 | 单任务 ≤30 分钟 |
| 验收标准 | 每个任务必须有明确验收项 |

---

## 验证状态

- ✅ 角色文档完整
- ✅ 任务分配流程
- ✅ 自提升机制
- 🔄 知识库初始化（待填充）

---

## License

MIT

---

*Built for OpenClaw - 适用于任何需要 AI 协作的团队*
