# Skills 索引

> 每个 Agent 需要什么技能

---

## 必须 Skills

| Agent | 必须 Skill | 用途 |
|-------|-----------|------|
| Helix | github | 读写 repo |
| Helix | gog | 邮件/日历 |
| Codex | git | 代码提交 |
| Codex | terminal | 执行命令 |
| Researcher | web_fetch | 获取网页内容 |
| Researcher | browser | 浏览器操作 |
| Researcher | search | 全网搜索 |

---

## 可选 Skills

| Agent | 可选 Skill | 用途 |
|-------|-----------|------|
| Reviewer | github | 读 PR |
| Tester | terminal | 运行测试 |
| Documenter | github | 更新 wiki |
| Guardian | healthcheck | 安全扫描 |
| Scheduler | - | 内部调度 |

---

## 安装 Skill

```bash
# 查看可用 skills
openclaw skills list

# 安装 skill
openclaw skill install <skill-name>
```

---

## 自定义 Skill

如果需要新 skill，可以：

1. 写 `skills/custom/*.md`
2. 定义 skill 逻辑
3. Agent 读取后自动获得能力

---

*详见各角色文档*
