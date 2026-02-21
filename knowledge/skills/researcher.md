# Researcher Skills

## 核心技能

### web_fetch - 网页抓取

```bash
# 获取页面内容
web_fetch https://example.com

# 提取关键信息
web_fetch --extractMode=markdown --maxChars=5000 https://example.com
```

**用途**: 快速获取网页文字内容，不需要渲染

### browser - 浏览器操作

```bash
# 打开网页
browser action=open targetUrl="https://google.com"

# 截图
browser action=screenshot

# 填表单
browser action=act request='{"kind":"type","ref":"search","text":"AI agents"}'
browser action=act request='{"kind":"click","ref":"search-btn"}'
```

**用途**: 需要 JavaScript 渲染、登录、交互的场景

### search - 全网搜索

> 注意：OpenClaw 当前无内置搜索，需用 browser 去搜索引擎

```bash
# 用 browser 打开搜索
browser action=open targetUrl="https://www.google.com/search?q=Claude+API+price"
```

---

## 调研方法论

### 标准流程

```
1. 明确问题 → 2. 搜索引擎查询 → 3. 官方文档确认 → 4. 社区讨论验证 → 5. 总结
```

### 信息源优先级

| 优先级 | 来源 | 信任度 |
|--------|------|--------|
| P0 | 官方文档 (openai.com, anthropic.com) | 100% |
| P1 | 权威评测 (HuggingFace, PapersWithCode) | 90% |
| P2 | GitHub Issues / Discussions | 70% |
| P3 | 博客/个人文章 | 50% |

---

## 常用搜索组合

### 对比调研

```bash
# 打开对比页面
browser open "https://www.google.com/search?q=ChatGPT+vs+Claude+comparison+2024"
browser open "https://www.youtube.com/results?search_query=Claude+vs+GPT+4+code+generation"
```

### 定价调研

```bash
browser open "https://openai.com/pricing"
browser open "https://www.anthropic.com/pricing"
```

### 技术方案

```bash
browser open "https://github.com/topics/ai-agent"
browser open "https://stackoverflow.com/search?q=react+authentication"
```

---

## 防幻觉规则

1. **每个事实必须带来源 URL**
2. **定价类必须截图/提取日期**
3. **不确定的标注「待验证」**
4. **调研报告必须有时效性**

---

## 自提升

- 每周巡检常用信息源是否失效
- 更新 `knowledge/research-sources.md`（常用网址）
- 记录调研技巧到 `knowledge/research-tips.md`

---

**原则**: 用证据说话，让结论经得起检验
