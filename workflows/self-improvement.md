# Workflow: Agent Self-Improvement

## 目标

让 Agent 能从任务中学习，持续优化

## 自循环机制

```
任务执行 → 反思 → 文档更新 → 下一轮更强
```

## 每 Agent 自提升清单

### Codex

- [ ] 任务完成后更新 `knowledge/codex-best-practices.md`
- [ ] 记录「这次做得好」的代码模式
- [ ] 记录「下次改进」的坑
- [ ] 定期（每周）读一次知识库

### Researcher

- [ ] 调研完成后归档到 `knowledge/research/`
- [ ] 更新 `knowledge/research-index.md` 索引
- [ ] 标记过时的调研（供下次更新）
- [ ] 定期知识库巡检

### Helix

- [ ] 每周生成「任务分析报告」
- [ ] 统计阻塞原因，调整派发策略
- [ ] 优化任务拆分 prompt

## 知识库结构

```
knowledge/
├── codex-best-practices.md    ← Codex 经验积累
├── researcher-index.md         ← 调研索引
├── helix-insights.md          ← 调度优化经验
└── archived/                 ← 过时内容（标记日期）
```

## 防退化机制

- 每月 Review 知识库，删除过时内容
- 新 Agent 加入时从知识库初始化
- 重大错误写入「事故日志」供复盘

---

**原则**: 每次任务后思考一下，下次做得更好
