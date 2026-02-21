# Helix 永动机 - 20 任务池

> 从今天对话提取，每 15 分钟自检一次

---

## 时间线

**当前**: 2026-02-21 17:45
**下次**: 18:00 → 每 15 分钟一次

---

## 20 个任务清单

### T1-T5: 核心框架 (5个)

| ID | 任务 | 状态 | 下次 |
|----|------|------|------|
| T1 | 完善 Codex 角色文档 | 待优化 | - |
| T2 | 完善 Researcher 角色文档 | 待优化 | - |
| T3 | 完善 Reviewer 角色文档 | 待优化 | - |
| T4 | 完善 Learning 进化机制 | 待优化 | - |
| T5 | 增加 Guardian 详细规则 | 待增加 | - |

### T6-T10: Docker 部署 (5个)

| ID | 任务 | 状态 | 下次 |
|----|------|------|------|
| T6 | 测试 docker-compose 能否启动 | 待测试 | - |
| T7 | 创建剩余 7 个 Agent Dockerfile | 待创建 | - |
| T8 | 优化 Dockerfile 减少镜像大小 | 待优化 | - |
| T9 | 添加 healthcheck 配置 | 待添加 | - |
| T10 | 添加 volume 持久化配置 | 待添加 | - |

### T11-T15: Skill 验证 (5个)

| ID | 任务 | 状态 | 下次 |
|----|------|------|------|
| T11 | 从官方 repo 随机选 5 个 skills | 待执行 | - |
| T12 | 安装并测试每个 skill | 待执行 | - |
| T13 | 记录验证结果到 JSON | 待执行 | - |
| T14 | 更新 skills-verified 索引 | 待执行 | - |
| T15 | 更新 skills-scenarios 使用场景 | 待执行 | - |

### T16-T20: 工具 & 文档 (5个)

| ID | 任务 | 状态 | 下次 |
|----|------|------|------|
| T16 | 完善 Cron 任务详细设计 | 待完善 | - |
| T17 | 添加 Agent 间通信协议 | 待设计 | - |
| T18 | 增加任务模板到 10 个 | 待增加 | - |
| T19 | 完善自检机制设计 | 待完善 | - |
| T20 | 生成完整的 README 索引 | 待生成 | - |

---

## 执行节奏

```
18:00 - T1-T4
18:15 - T5-T8
18:30 - T9-T12
18:45 - T13-T16
19:00 - T17-T20
19:15 - 重新循环 T1-T4
...
```

---

## 详细任务说明

### T1: 完善 Codex 角色文档

**现状**: 有基础版本 v2.0
**需要**:
- 增加更详细的输入输出示例
- 增加错误处理规范
- 增加代码模板
- 增加自提升 Checklist

### T2: 完善 Researcher 角色文档

**现状**: 有基础版本 v2.0
**需要**:
- 增加调研方法论详解
- 增加信息源验证规则
- 增加报告模板
- 增加自提升 Checklist

### T3: 完善 Reviewer 角色文档

**现状**: 基础版本
**需要**:
- 增加审查检查清单
- 增加安全问题列表
- 增加代码规范参考
- 增加自动化审查规则

### T4: 完善 Learning 进化机制

**现状**: 基础设计
**需要**:
- 设计具体的数据收集格式
- 设计模式识别算法
- 设计知识库更新流程
- 设计进化报告模板

### T5: 增加 Guardian 详细规则

**现状**: 基础版本
**需要**:
- 设计安全检查清单
- 增加漏洞检测规则
- 增加告警阈值
- 设计响应流程

---

### T6: 测试 docker-compose

```bash
cd docker
docker-compose config  # 验证配置
docker-compose up -d   # 启动测试
docker-compose logs   # 查看日志
```

### T7: 创建剩余 Dockerfile

需要创建:
- reviewer.Dockerfile
- tester.Dockerfile
- documenter.Dockerfile
- scheduler.Dockerfile
- evaluator.Dockerfile
- learning.Dockerfile
- guardian.Dockerfile

### T8: 优化 Dockerfile

- 使用 multi-stage build
- 减少层数
- 合并 RUN 指令

### T9: 添加 healthcheck

```yaml
services:
  helix:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### T10: 添加 volume

```yaml
volumes:
  - ./data:/app/data
  - ./logs:/app/logs
```

---

### T11-T15: Skill 验证流程

```bash
# T11: 获取随机 5 个
gh api repos/openclaw/skills/contents/skills \
  --jq '.[].name' | shuf | head -5

# T12: 安装测试
openclaw skill install <skill-name>

# T13: 记录 JSON
# 格式见 skill-verification.md

# T14: 更新索引
# knowledge/skills-verified/index.md

# T15: 更新场景
# knowledge/skills-scenarios.md
```

---

### T16: 完善 Cron

- 每 15 分钟自检
- 每天 3 次 GitHub sync
- 每周 Knowledge 巡检

### T17: Agent 通信协议

设计:
- 消息格式
- 队列管理
- 错误处理

### T18: 增加模板

- 架构设计模板
- 发布模板
- 复盘模板

### T19: 自检机制

- 检查 OpenClaw 状态
- 检查 Agent 活跃度
- 检查 GitHub sync 状态
- 检查 pending tasks

### T20: README 索引

生成完整索引，方便快速导航

---

## 执行记录

### 18:00 (第一轮)

- [ ] T1: 完善 Codex 文档
- [ ] T2: 完善 Researcher 文档
- [ ] T3: 完善 Reviewer 文档
- [ ] T4: 完善 Learning 机制

### 18:15 (第二轮)

- [ ] T5: Guardian 详细规则
- [ ] T6: 测试 docker-compose
- [ ] T7: 创建剩余 Dockerfile
- [ ] T8: 优化 Dockerfile

### 18:30 (第三轮)

- [ ] T9: healthcheck 配置
- [ ] T10: volume 配置
- [ ] T11: 随机选 5 skills
- [ ] T12: 安装测试 skills

### 18:45 (第四轮)

- [ ] T13: 记录验证结果
- [ ] T14: 更新索引
- [ ] T15: 更新场景
- [ ] T16: 完善 Cron

### 19:00 (第五轮)

- [ ] T17: 通信协议
- [ ] T18: 增加模板
- [ ] T19: 自检机制
- [ ] T20: README 索引

---

## 循环机制

完成后重新开始，永动执行

**开始时间**: 2026-02-21 18:00
**间隔**: 15 分钟
