# Codex Skills

## 必须技能

### git

```bash
# 提交代码
git add .
git commit -m "feat: add xxx"
git push

# 创建分支
git checkout -b feature/xxx

# 合并 PR
git fetch origin
git merge origin/pr/xxx
```

### terminal

```bash
# 运行测试
npm test
pytest test/

# 构建
npm run build
cargo build

# 检查代码
npm run lint
```

---

## 推荐技能

### github (PR)

```bash
# 创建 PR
gh pr create --title "feat: xxx" --body "Description"

# 查看 PR 状态
gh pr view 123

# 合并 PR
gh pr merge 123 --squash
```

### docker (可选)

```bash
# 构建镜像
docker build -t myapp .

# 运行容器
docker run -p 3000:3000 myapp
```

---

## 自提升技能

### 代码审查

```bash
# 使用代码分析工具
npm audit
cargo clippy
golangci-lint run
```

---

## 常用工具链

| 语言 | 工具 |
|------|------|
| JavaScript | npm, ESLint, Jest |
| Python | pip, pytest, Black |
| Go | go test, golint |
| Rust | cargo, clippy |
| TypeScript | tsc, ESLint |

---

**原则**: 会用工具不叫牛 b ，用对工具才叫牛 b
