# Skill 验证任务

> 每天随机选择 5 个未验证的 skills 进行测试

---

## 目标

- 验证 skills 是否可用
- 记录使用场景
- 避免重复验证
- 更新 knowledge

---

## 数据结构

### 验证记录

```json
{
  "verified_skills": [
    {
      "name": "github",
      "url": "https://github.com/openclaw/skills/...",
      "verified_date": "2026-02-21",
      "status": "safe",
      "scenarios": ["create_repo", "push_code"],
      "notes": "Works well for basic operations"
    }
  ],
  "pending_skills": [],
  "last_batch": "2026-02-21"
}
```

---

## 随机选择逻辑

1. 从 awesome-openclaw-skills 获取列表
2. 排除已验证的 skills
3. 随机选择 5 个
4. 优先选择高星/高相关性的

---

## 验证步骤

### Step 1: 读取 Skill 定义

```bash
# 读取 SKILL.md
web_fetch <skill-url>/SKILL.md
```

### Step 2: 安全检查

- 检查是否需要敏感权限（API keys, 密码）
- 检查是否涉及敏感操作（删除、支付）
- 检查是否有恶意代码

### Step 3: 功能测试

```bash
# 安装 skill
openclaw skill install <skill-name>

# 测试基本功能
# ... 执行测试命令
```

### Step 4: 记录结果

```markdown
## Skill: <name>

### 信息
- URL: <url>
- 验证日期: <date>
- 状态: safe/unsafe/need_review

### 功能
<描述 skill 能做什么>

### 使用场景
1. 场景 1: <描述>
2. 场景 2: <描述>

### 注意事项
- <安全提醒>
- <使用限制>

### 验证命令
```bash
<测试命令>
```

### 评估
- 易用性: ⭐⭐⭐⭐⭐
- 安全性: ⭐⭐⭐⭐⭐
- 实用性: ⭐⭐⭐⭐⭐
```

---

## 验证频率

| 时间 | 任务 |
|------|------|
| 09:00 | 选择 5 个 skills |
| 10:00-17:00 | 验证测试 |
| 18:00 | 汇总 + 更新 knowledge |
| 22:00 | 同步到 GitHub |

---

## 避免重复

### 记录已验证

```json
{
  "verified": ["skill-a", "skill-b", ...],
  "unsafe": ["skill-c"],  // 有问题的
  "pending": []           // 等待验证
}
```

### 选择逻辑

```python
# 伪代码
available = all_skills - verified - unsafe
batch = random.sample(available, 5)
```

---

## 任务分配

### Helix (我)

- 每天早上选择 skills
- 分配给 Researcher 验证
- 验收结果
- 更新记录
- 同步 GitHub

### Researcher

- 读取 skill 定义
- 执行验证测试
- 记录结果
- 提出使用场景

### Learning

- 分析验证结果
- 识别有价值 skills
- 更新最佳实践

---

## Cron 设置

```yaml
name: skill-verification
schedule: "0 9 * * *"  # 每天 09:00
action: |
  1. 读取验证记录
  2. 随机选择 5 个 skills
  3. 派发给 Researcher 验证
  4. 收集结果
  5. 更新 knowledge/skills-verified/
  6. 同步到 GitHub
```

---

## 输出目录

```
knowledge/
├── skills-verified/        ← 验证记录
│   ├── 2026-02-21.md     ← 每日记录
│   ├── 2026-02-22.md
│   └── index.md          ← 总索引
│
├── skills-unsafe/         ← 有问题的 skills
│   └── blocklist.md
│
└── skills-scenarios/      ← 使用场景
    └── index.md
```

---

## 安全第一

### 立即标记为 unsafe

- 需要登录凭证
- 涉及金钱交易
- 可以删除数据
- 未知的第三方 API

### 需要人工审查

- 需要 API key（自己提供测试 key）
- 可以执行任意命令
- 涉及隐私数据

### 可直接使用

- 只读操作
- 本地文件操作
- 公开 API

---

## 开始验证

```bash
# 1. 拉取最新 skills 列表
gh api repos/VoltAgent/awesome-openclaw-skills/contents --jq '.[].name'

# 2. 选择 5 个随机 skills
# ...

# 3. 开始验证
```
