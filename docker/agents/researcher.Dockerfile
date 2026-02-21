# Researcher - 首席调研员
FROM node:20-alpine

WORKDIR /app

# 安装基础工具
RUN apk add --no-cache bash git curl

# 安装 OpenClaw
RUN npm install -g openclaw

# 安装 gh CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install -y gh

# 复制配置
COPY docker/agents/researcher-config.yaml /app/config.yaml

# 复制角色文档
COPY roles/researcher.md /app/roles/

# 复制 skills
COPY knowledge/skills/researcher.md /app/skills/

ENV AGENT_NAME=Researcher
ENV AGENT_TYPE=researcher

EXPOSE 3002

CMD ["openclaw", "agent", "start", "--config", "/app/config.yaml"]
