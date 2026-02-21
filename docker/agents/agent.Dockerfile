# Agent 通用 Dockerfile
# 用于: Reviewer, Tester, Documenter, Scheduler, Evaluator, Learning, Guardian

ARG AGENT_NAME
ARG AGENT_TYPE

FROM node:20-alpine

WORKDIR /app

# 安装基础工具
RUN apk add --no-cache bash git curl

# 安装 OpenClaw
RUN npm install -g openclaw

# 安装 gh CLI (部分 agent 需要)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install -y gh

# 复制配置
COPY docker/agents/${AGENT_NAME,,}-config.yaml /app/config.yaml

# 复制角色文档
COPY roles/${AGENT_NAME,,}.md /app/roles/

ENV AGENT_NAME=${AGENT_NAME}
ENV AGENT_TYPE=${AGENT_TYPE}

EXPOSE 3000

CMD ["openclaw", "agent", "start", "--config", "/app/config.yaml"]
