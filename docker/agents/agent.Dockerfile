# Agent 通用 Dockerfile - 优化版
# 用于: Reviewer, Tester, Documenter, Scheduler, Evaluator, Learning, Guardian

ARG AGENT_NAME
ARG AGENT_TYPE
ARG NODE_VERSION=20-alpine

# Stage 1: Base
FROM node:${NODE_VERSION} AS base
RUN apk add --no-cache bash git curl

# Stage 2: Tools
FROM base AS tools
RUN npm install -g openclaw

# Stage 3: Agent
FROM base AS agent

# 安装 gh CLI (部分 agent 需要)
RUN apk add --no-cache gnupg \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /tmp/githubcli-archive-keyring.gpg \
    && chmod go+r /tmp/githubcli-archive-keyring.gpg \
    && mv /tmp/githubcli-archive-keyring.gpg /usr/share/keyrings/ \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=tools /usr/local/bin/openclaw /usr/local/bin/openclaw
COPY docker/agents/${AGENT_NAME,,}-config.yaml /app/config.yaml
COPY roles/${AGENT_NAME,,}.md /app/roles/

ENV AGENT_NAME=${AGENT_NAME}
ENV AGENT_TYPE=${AGENT_TYPE}

EXPOSE 3000

CMD ["openclaw", "agent", "start", "--config", "/app/config.yaml"]

# 最终构建
FROM agent AS final
