# Agent Framework 运维指南

> 部署、监控、安全、故障排查 - 完整运维手册
> 版本: 2026-02-21 v3.0

---

## 目录

1. [部署配置](#1-部署配置)
2. [监控告警](#2-监控告警)
3. [安全配置](#3-安全配置)
4. [故障排查](#4-故障排查)
5. [运维命令](#5-运维命令)

---

## 1. 部署配置

### Docker Compose (一键启动)

```yaml
# docker-compose.yaml
version: '3.8'

services:
  agent-api:
    image: agent-system:latest
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/agent
      - REDIS_URL=redis://cache:6379
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
    depends_on:
      - db
      - cache
    restart: unless-stopped

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: agent
    volumes:
      - pgdata:/var/lib/postgresql/data

  cache:
    image: redis:7
    command: redis-server --requirepass ${REDIS_PASSWORD}

volumes:
  pgdata:
```

### Kubernetes 部署

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: agent-system
spec:
  replicas: 3
  selector:
    matchLabels:
      app: agent-system
  template:
    metadata:
      labels:
        app: agent-system
    spec:
      containers:
      - name: api
        image: agent-system:latest
        ports:
        - containerPort: 8080
        env:
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: agent-secrets
              key: openai-api-key
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: agent-system
spec:
  selector:
    app: agent-system
  ports:
  - port: 80
    targetPort: 8080
  type: LoadBalancer
```

### 环境变量

```bash
# .env
# 必需
OPENAI_API_KEY=sk-xxx
ANTHROPIC_API_KEY=sk-ant-xxx

# 可选
DATABASE_URL=postgresql://user:pass@localhost:5432/agent
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-secret-key

# 日志
LOG_LEVEL=info
```

---

## 2. 监控告警

### Prometheus 指标

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'agent-system'
    static_configs:
      - targets: ['agent-api:8080']
```

### 关键指标

| 指标名 | 类型 | 说明 | 告警阈值 |
|--------|------|------|---------|
| agent_tasks_total | Counter | 任务总数 | - |
| agent_tasks_active | Gauge | 活跃任务 | >100 |
| agent_task_duration | Histogram | 任务耗时 | P99>60s |
| llm_api_calls_total | Counter | LLM调用次数 | - |
| llm_api_errors_total | Counter | LLM错误 | >5% |
| system_cpu_usage | Gauge | CPU使用率 | >80% |
| system_memory_usage | Gauge | 内存使用率 | >85% |

### 告警规则

```yaml
# alerts.yml
groups:
  - name: agent
    rules:
      - alert: TaskFailed
        expr: rate(agent_tasks_failed[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
          
      - alert: HighLatency
        expr: histogram_quantile(0.99, rate(agent_task_duration_bucket[5m])) > 60
        for: 5m
        labels:
          severity: warning
          
      - alert: LLMErrorRate
        expr: rate(llm_api_errors_total[5m]) > 0.05
        for: 3m
        labels:
          severity: warning
```

### Grafana 面板 JSON

```json
{
  "dashboard": {
    "title": "Agent System",
    "panels": [
      {
        "title": "Task Success Rate",
        "targets": [
          {
            "expr": "sum(rate(agent_tasks_completed[5m])) / sum(rate(agent_tasks_total[5m]))"
          }
        ]
      },
      {
        "title": "LLM Latency",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(llm_api_duration_seconds_bucket[5m]))"
          }
        ]
      }
    ]
  }
}
```

---

## 3. 安全配置

### 认证配置

```yaml
# auth.yaml
auth:
  jwt:
    secret: "${JWT_SECRET}"
    expiry: 86400
    
  providers:
    - type: token
    - type: oauth
    
  password_policy:
    min_length: 12
    require_special: true
```

### 权限配置

```yaml
# permissions.yaml
roles:
  admin:
    - "*"
    
  user:
    - task:create
    - task:read
    - task:read_own
    
  agent:
    - task:execute
    - file:read
    - file:write
```

### API 限流

```yaml
# rate_limit.yaml
rate_limit:
  enabled: true
  
  rules:
    - path: "/api/*"
      requests_per_minute: 60
      
    - path: "/api/tasks"
      requests_per_minute: 120
      
    - path: "/api/llm/*"
      requests_per_minute: 30
```

### 数据加密

```yaml
# encryption.yaml
encryption:
  in_transit:
    tls_version: "1.2"
    
  at_rest:
    algorithm: "AES-256-GCM"
    
  sensitive_fields:
    - api_key
    - password
    - token
```

---

## 4. 故障排查

### 快速诊断

```bash
#!/bin/bash
# diagnose.sh

echo "=== Agent System Diagnostics ==="

echo -n "API: "
curl -sf http://localhost:8080/health && echo " OK" || echo " FAIL"

echo -n "Database: "
curl -sf http://localhost:8080/health/db && echo " OK" || echo " FAIL"

echo -n "Redis: "
curl -sf http://localhost:8080/health/redis && echo " OK" || echo " FAIL"

echo -n "Agents: "
curl -sf http://localhost:8080/api/agents/status | grep -q "running" && echo " OK" || echo " FAIL"

echo "=== Recent Errors ==="
tail -20 /var/log/agent/app.log | grep ERROR

echo "=== Resource Usage ==="
free -h
df -h /
```

### 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| 任务不执行 | Agent未启动 | 重启: systemctl restart agent |
| API 429 | 限流 | 等待或换Provider |
| API 401 | Key失效 | 更新环境变量 |
| 任务失败 | 代码错误 | 查看日志 |
| 响应慢 | 负载高 | 扩容 |

### 日志查看

```bash
# 查看所有日志
tail -f /var/log/agent/app.log

# 查看错误
grep ERROR /var/log/agent/app.log

# 查看特定任务
grep "task-123" /var/log/agent/app.log

# 查看特定Agent
grep "coder" /var/log/agent/app.log
```

### 重启服务

```bash
# 重启单个Agent
curl -X POST http://localhost:8080/api/agents/coder/restart

# 重启全部
systemctl restart agent-system

# 重启并清理缓存
curl -X POST http://localhost:8080/api/system/clear-cache
```

---

## 5. 运维命令

### 日常运维

```bash
# 启动
docker-compose up -d

# 停止
docker-compose down

# 重启
docker-compose restart

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f api

# 扩缩容
docker-compose up -d --scale api=5
```

### 任务管理

```bash
# 列出任务
curl http://localhost:8080/api/tasks?status=pending

# 查看任务详情
curl http://localhost:8080/api/tasks/{task_id}

# 取消任务
curl -X DELETE http://localhost:8080/api/tasks/{task_id}

# 重新执行失败任务
curl -X POST http://localhost:8080/api/tasks/{task_id}/retry
```

### Agent 管理

```bash
# 查看Agent状态
curl http://localhost:8080/api/agents/status

# 禁用Agent
curl -X POST http://localhost:8080/api/agents/{agent_id}/disable

# 启用Agent
curl -X POST http://localhost:8080/api/agents/{agent_id}/enable
```

### Provider 管理

```bash
# 测试Provider
curl -X POST http://localhost:8080/api/providers/openai/test

# 切换Provider
curl -X POST http://localhost:8080/api/providers/default?provider=anthropic
```

### 备份与恢复

```bash
# 备份
docker exec agent-db pg_dump -U user agent > backup_$(date +%Y%m%d).sql

# 恢复
docker exec -i agent-db psql -U user agent < backup_20260221.sql

# 清理旧数据
curl -X POST http://localhost:8080/api/maintenance/cleanup?days=30
```

---

## 健康检查清单

```bash
#!/bin/bash
# health_check.sh

PASS=0
FAIL=0

check() {
    if curl -sf "$1" > /dev/null 2>&1; then
        echo "✅ $2"
        ((PASS++))
    else
        echo "❌ $2"
        ((FAIL++))
    fi
}

check http://localhost:8080/health "API服务"
check http://localhost:8080/health/db "数据库"
check http://localhost:8080/health/redis "Redis"

echo "=== 结果: $PASS 成功, $FAIL 失败 ==="
```

---

*文档版本: 2026-02-21 v3.0*
