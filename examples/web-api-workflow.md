# 示例：开发一个 Web API

> 完整流程示例，展示多 Agent 协作

---

## 原始需求

```
用户：帮我做一个用户管理的 REST API
```

---

## Step 1: Helix 分析

**Helix 思考**：
- 这是代码开发任务 → Codex
- 需要先调研最佳实践 → Researcher

**拆分任务**：

```markdown
## 任务列表

- [ ] 调研: 用户 API 最佳实践 [assignee=researcher, priority=P1]
- [ ] 设计: API 规格 [assignee=helix, priority=P0]
- [ ] 实现: 用户 CRUD API [assignee=codex, priority=P0]
- [ ] 测试: 编写单元测试 [assignee=tester, priority=P0]
- [ ] 审查: 代码审查 [assignee=reviewer, priority=P1]
- [ ] 文档: API 文档 [assignee=documenter, priority=P2]
```

---

## Step 2: Researcher 调研

**Researcher 产出**：

```markdown
# 调研: 用户 API 最佳实践

## 发现

### RESTful 规范
- 使用标准 HTTP 方法
- 资源命名用复数
- 状态码正确使用

### 认证方案
- JWT 是主流
- 考虑 refresh token
- 密码必须 bcrypt 加密

## 建议

使用 Express + JWT，参考 GitHub REST API 风格

## 来源
- https://restfulapi.net/
- https://jwt.io/
```

---

## Step 3: Codex 实现

**Codex 产出**：

```
files:
  - routes/users.js
  - controllers/userController.js
  - models/User.js
  - middleware/auth.js
  - utils/jwt.js

tests:
  - tests/users.spec.js

commit: "feat: add user CRUD API with JWT auth"
```

---

## Step 4: Tester 测试

**Tester 产出**：

```
tests_written: 15
tests_passed: 14
coverage: 82%

failed:
  - name: "delete_user_not_found"
    reason: "Codex 未实现 404 处理"
    issue: "BUG-001"
```

---

## Step 5: Reviewer 审查

**Reviewer 产出**：

```
issues:
  - severity: major
    line: 45
    issue: "密码明文存储风险"
    suggestion: "使用 bcrypt"
  - severity: minor
    line: 78
    issue: "缺少输入验证"
    suggestion: "使用 Joi/Validator"

approved: true (修复 major 后)
```

---

## Step 6: Documenter 文档

**Documenter 产出**：

```
files:
  - docs/api/users.md
  - docs/guides/auth-flow.md

quality_score: 9.0
```

---

## Step 7: Evaluator 评估

**Evaluator 产出**：

```
task_score: 88

breakdown:
  - functionality: 95
  - code_quality: 85
  - test_coverage: 82
  - documentation: 90

insights:
  - Codex 实现效率高
  - 测试覆盖需提升
  - 建议下个项目加强测试
```

---

## Step 8: Learning 进化

**Learning 产出**：

```
patterns_identified:
  - "API 开发任务拆分后完成率更高"
  - "提前调研可减少返工"

improvements:
  - "建议任务模板增加调研项"
  - "Codex 需要加强测试意识"

knowledge_updated:
  - patterns/api-development.md
  - lessons/testing-importance.md
```

---

## Step 9: Helix 验收

**Helix 反馈**：

```
✅ 完成！

PR: https://github.com/xxx/xxx/pull/123
文档: /docs/api/users.md
测试覆盖率: 82%

用时: 45 分钟
```

---

## 完整流转图

```
用户 → Helix(分析) → Researcher(调研) ─┐
      ↓                                 │
   Codex(实现) ←─────────────────────────┤
      ↓                                 │
   Tester(测试)                         │
      ↓                                 │
   Reviewer(审查) ──────────────────────┤
      ↓                                 │
   Documenter(文档)                     │
      ↓                                 │
   Evaluator(评估)                      │
      ↓                                 │
   Learning(进化) ───────────────────────┤
      ↓                                 │
   Helix(验收) → 用户
```

---

## 时间统计

| 阶段 | 用时 |
|------|------|
| Helix 分析 | 2 min |
| Researcher 调研 | 8 min |
| Codex 实现 | 20 min |
| Tester 测试 | 5 min |
| Reviewer 审查 | 3 min |
| Documenter 文档 | 4 min |
| Evaluator + Learning | 3 min |
| **总计** | **45 min** |

---

*这就是多 Agent 协作的完整示例*
