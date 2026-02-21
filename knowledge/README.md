# Knowledge 知识库

> 所有 Agent 的共享知识

---

## 目录

```
knowledge/
├── skills/              ← Agent 技能定义
│   ├── index.md        ← 技能索引
│   ├── codex.md        ← Codex 技能
│   └── researcher.md   ← Researcher 技能
│
├── patterns/            ← 成功模式
│   ├── task-splitting.md
│   └── code-review-flow.md
│
├── lessons/            ← 踩坑记录
│   ├── context-overflow.md
│   └── hallucination-prevention.md
│
├── best-practices/     ← 最佳实践
│   ├── codex-patterns.md
│   └── researcher-methods.md
│
├── sources/            ← 信息源
│   └── research-sources.md
│
└── archived/          ← 过时内容
    └── (标记日期的旧文件)
```

---

## 自动更新

### Learning Agent 职责

- 每次任务后读取日志
- 提取成功/失败模式
- 更新对应文件

### 更新频率

| 类型 | 频率 |
|------|------|
| 技能索引 | 每次 skill 变化 |
| 成功模式 | 每周 |
| 踩坑记录 | 每次问题后 |
| 最佳实践 | 每月 |
| 信息源 | 每周巡检 |

---

## 内容规范

### 成功模式

```markdown
# 模式: {模式名称}

## 场景
{在什么情况下使用}

## 方法
{具体步骤}

## 效果
{带来的改进}

## 例子
{示例}
```

### 踩坑记录

```markdown
# 坑: {坑的名称}

## 问题
{描述}

## 原因
{为什么会踩坑}

## 解决方案
{如何避免}

## 预防
{下次怎么预防}
```

### 最佳实践

```markdown
# 实践: {实践名称}

## 适用场景
{什么时候用}

## 步骤
1. ...
2. ...

## 注意事项
- ...

## 参考
{链接}
```

---

## 维护规则

1. **每周** - Learning Agent 检查完整性
2. **每月** - 清理过期内容
3. **每次** - 任务后更新相关文件
4. **定期** - 验证链接有效性

---

*知识库是生态圈的大脑，让每个 Agent 都能站在巨人的肩膀上*
