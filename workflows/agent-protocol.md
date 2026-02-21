# Agent 通信协议

> Helix 生态圈中 Agent 之间的通信规范

---

## 消息格式

### 标准消息结构

```json
{
  "id": "msg-001",
  "from": "Helix",
  "to": "Codex",
  "type": "task",
  "content": {
    "task_id": "TASK-001",
    "action": "execute",
    "payload": {...}
  },
  "timestamp": "2026-02-21T19:00:00Z",
  "priority": "high",
  "requires_ack": true
}
```

### 消息类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `task` | 任务派发 | Helix → Codex |
| `result` | 任务结果 | Codex → Helix |
| `query` | 询问 | Agent → Agent |
| `response` | 响应 | Agent → Agent |
| `alert` | 告警 | Guardian → Helix |
| `sync` | 状态同步 | Scheduler → All |

---

## Agent → Helix

### 任务完成

```json
{
  "type": "result",
  "from": "Codex",
  "to": "Helix",
  "content": {
    "task_id": "TASK-001",
    "status": "done",
    "output": {...},
    "duration_minutes": 15
  }
}
```

### 阻塞报告

```json
{
  "type": "alert",
  "from": "Codex",
  "to": "Helix",
  "content": {
    "alert_type": "blocked",
    "reason": "需要 API key",
    "task_id": "TASK-002"
  }
}
```

### 状态更新

```json
{
  "type": "sync",
  "from": "Scheduler",
  "to": "Helix",
  "content": {
    "status": "idle",
    "load": "40%",
    "active_tasks": 1
  }
}
```

---

## Helix → Agent

### 任务派发

```json
{
  "type": "task",
  "from": "Helix",
  "to": "Codex",
  "content": {
    "task_id": "TASK-001",
    "requirement": "实现用户登录",
    "spec": ["JWT", "bcrypt"],
    "priority": "P0",
    "deadline": "2026-02-21T20:00:00Z"
  }
}
```

### 任务取消

```json
{
  "type": "task",
  "from": "Helix",
  "to": "Codex",
  "content": {
    "task_id": "TASK-002",
    "action": "cancel",
    "reason": "优先级调整"
  }
}
```

---

## Agent ↔ Agent

### Codex → Reviewer

```json
{
  "type": "query",
  "from": "Codex",
  "to": "Reviewer",
  "content": {
    "query": "这段代码有安全风险吗?",
    "code": "...",
    "context": "用户登录"
  }
}
```

### Reviewer → Codex

```json
{
  "type": "response",
  "from": "Reviewer",
  "to": "Codex",
  "content": {
    "query_id": "msg-xxx",
    "answer": "有 SQL 注入风险",
    "severity": "high",
    "suggestion": "使用参数化查询"
  }
}
```

---

## 队列管理

### 任务队列

```json
{
  "queue_name": "codex_tasks",
  "pending": [
    {"task_id": "TASK-001", "priority": "P0"},
    {"task_id": "TASK-002", "priority": "P1"}
  ],
  "processing": {"task_id": "TASK-003"},
  "completed": ["TASK-001", "TASK-002"]
}
```

### 负载状态

```json
{
  "agent": "Codex",
  "status": "busy",
  "current_task": "TASK-003",
  "queue_length": 2,
  "estimated_free": "2026-02-21T19:30:00Z"
}
```

---

## 错误处理

### 超时

```json
{
  "type": "alert",
  "from": "System",
  "to": "Helix",
  "content": {
    "alert_type": "timeout",
    "agent": "Codex",
    "task_id": "TASK-001",
    "duration_minutes": 35
  }
}
```

### 失败

```json
{
  "type": "result",
  "from": "Codex",
  "to": "Helix",
  "content": {
    "task_id": "TASK-001",
    "status": "failed",
    "error": "API rate limit exceeded",
    "retryable": true
  }
}
```

---

## 实现

### 消息队列

```bash
# 使用 Redis 或内部消息
# 格式: helix:queue:{agent_name}
```

### 状态存储

```json
// helix:agent:status
{
  "Codex": {
    "status": "busy",
    "current_task": "TASK-001",
    "load": "60%"
  }
}
```

---

## 通信渠道

| 场景 | 渠道 |
|------|------|
| 任务派发 | OpenClaw subagent |
| 实时状态 | 共享 JSON |
| 告警 | 消息推送 |
| 同步 | GitHub |

---

**核心**: 清晰的消息格式 + 明确的职责边界
