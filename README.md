# Agent Framework 文档索引 (v3.1)

> 核心架构 + 运维指南 + 测试验证 - 已验证 92 项
> 版本: 2026-02-21 v3.1

---

## 文档列表

| # | 文档 | 描述 | 验证状态 |
|---|------|------|---------|
| 01 | [01_core_architecture.md](./01_core_architecture.md) | 角色定义 + 架构 + 协作流程 | ✅ 已验证 |
| 02 | [02_operations_guide.md](./02_operations_guide.md) | 部署 + 监控 + 安全 + 故障 | ✅ 已验证 |
| 03 | [03_testing_verification.md](./03_testing_verification.md) | 测试 + 验证用例库 | ✅ 已验证 |
| - | [VERIFICATION_LOG.md](./VERIFICATION_LOG.md) | 验证记录 (92 项) | ✅ 完成 |

---

## 验证结果

| 类别 | 通过 | 失败 |
|------|------|------|
| 系统基础 | 10 | 0 |
| 角色对比 | 10 | 0 |
| 系统功能 | 10 | 0 |
| 文档对比 | 10 | 0 |
| Agent Workspace | 10 | 0 |
| Cron 任务 | 5 | 0 |
| 系统进程 | 10 | 0 |
| 文件结构 | 9 | 0 |
| 文档结构 | 9 | 0 |
| 协作流程 | 9 | 0 |
| **总计** | **92** | **0** |

---

## 已知差异 (预期)

1. **Model 配置**: 文档是通用版(gpt-4o/claude)，实际是本地优化版(minimax/gpt-5.3-codex)
2. **角色数量**: 文档定义 9 个，实际 3 个 (最小配置)

---

## 验证方法

验证内容包括:
- Config 文件解析
- Agent 配置对比
- 文件结构检查
- 进程状态
- Cron jobs
- 文档格式
- JSON 可解析性
- Mermaid 图定义

---

*更新: 2026-02-21 v3.1*
