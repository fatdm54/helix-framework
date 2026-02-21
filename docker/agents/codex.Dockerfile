# Codex - 首席开发者
FROM node:20-alpine

WORKDIR /app

# 安装基础工具
RUN apk add --no-cache bash git curl

# 安装 OpenClaw
RUN npm install -g openclaw

# 安装代码工具
RUN apk add --no-cache git

# 复制配置
COPY docker/agents/codex-config.yaml /app/config.yaml

# 复制角色文档
COPY roles/codex.md /app/roles/

# 复制 skills
COPY knowledge/skills/codex.md /app/skills/

ENV AGENT_NAME=Codex
ENV AGENT_TYPE=executor

EXPOSE 3001

CMD ["openclaw", "agent", "start", "--config", "/app/config.yaml"]
