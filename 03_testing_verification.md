# Agent Framework 测试验证指南

> 单元测试、集成测试、E2E测试、验证用例库
> 版本: 2026-02-21 v3.0

---

## 目录

1. [测试框架](#1-测试框架)
2. [单元测试](#2-单元测试)
3. [集成测试](#3-集成测试)
4. [E2E测试](#4-e2e测试)
5. [测试用例库](#5-测试用例库)
6. [CI/CD集成](#6-cicd集成)

---

## 1. 测试框架

### Python 测试模板

```python
# test_agent.py
import pytest
import requests
from unittest.mock import Mock, patch

BASE_URL = "http://localhost:8080/api"

class TestAgentSystem:
    """Agent系统测试基类"""
    
    @pytest.fixture
    def auth_token(self):
        """获取认证Token"""
        response = requests.post(f"{BASE_URL}/auth/login", json={
            "username": "test",
            "password": "test"
        })
        return response.json()["data"]["token"]
    
    @pytest.fixture
    def auth_headers(self, auth_token):
        """认证头"""
        return {"Authorization": f"Bearer {auth_token}"}


class TestCoordinator(TestAgentSystem):
    """Coordinator测试"""
    
    def test_task_creation(self, auth_headers):
        """测试任务创建"""
        response = requests.post(
            f"{BASE_URL}/tasks",
            headers=auth_headers,
            json={
                "type": "code",
                "requirements": "写一个测试函数"
            }
        )
        assert response.status_code == 201
        assert response.json()["success"] is True
    
    def test_task_assignment(self, auth_headers):
        """测试任务分配"""
        # 创建任务
        task = requests.post(f"{BASE_URL}/tasks", headers=auth_headers, json={
            "type": "code",
            "requirements": "test"
        }).json()["data"]
        
        # 验证分配
        assert task["status"] in ["pending", "running"]


class TestCoder(TestAgentSystem):
    """Coder测试"""
    
    def test_code_generation(self):
        """测试代码生成"""
        # Mock LLM调用
        with patch('app.llm.call') as mock:
            mock.return_value = "def test(): pass"
            
            # 执行测试
            result = generate_code("python", "test function")
            
            assert "def" in result
```

### JavaScript 测试模板

```javascript
// test_agent.js
const { AgentClient } = require('@agent/sdk');

describe('Agent System', () => {
  const client = new AgentClient({
    baseUrl: 'http://localhost:8080',
    apiKey: 'test-token'
  });

  describe('Tasks', () => {
    test('create task', async () => {
      const task = await client.tasks.create({
        type: 'code',
        requirements: 'test function'
      });
      
      expect(task.id).toBeDefined();
      expect(task.status).toBe('pending');
    });

    test('get task', async () => {
      const task = await client.tasks.get('task-123');
      expect(task).toBeDefined();
    });
  });
});
```

---

## 2. 单元测试

### Agent 单元测试

```python
# test_unit.py
import pytest
from unittest.mock import Mock, MagicMock

class TestCoderAgent:
    """Coder Agent 单元测试"""
    
    def test_parse_requirement(self):
        """测试需求解析"""
        from agents.coder import CoderAgent
        
        agent = CoderAgent()
        req = agent.parse_requirement("用Python写一个阶乘函数")
        
        assert req.language == "python"
        assert "阶乘" in req.description
    
    def test_generate_code(self):
        """测试代码生成"""
        from agents.coder import CoderAgent
        
        agent = CoderAgent()
        with patch.object(agent, 'call_llm') as mock:
            mock.return_value = "def factorial(n):\n    return 1"
            
            code = agent.generate_code("python", "阶乘函数")
            
            assert "def factorial" in code
    
    def test_validate_syntax(self):
        """测试语法验证"""
        from agents.coder import CoderAgent
        
        agent = CoderAgent()
        
        # 有效代码
        assert agent.validate_syntax("def f(): pass", "python") is True
        
        # 无效代码
        assert agent.validate_syntax("def f(", "python") is False


class TestResearcherAgent:
    """Researcher Agent 单元测试"""
    
    def test_search(self):
        """测试搜索"""
        from agents.researcher import ResearcherAgent
        
        agent = ResearcherAgent()
        with patch.object(agent, 'web_search') as mock:
            mock.return_value = [{"title": "Result", "url": "http://..."}]
            
            results = agent.search("AI Agent")
            
            assert len(results) > 0
    
    def test_parse_result(self):
        """测试结果解析"""
        from agents.researcher import ResearcherAgent
        
        agent = ResearcherAgent()
        parsed = agent.parse_result([{
            "title": "Test",
            "content": "Content"
        }])
        
        assert parsed[0]["title"] == "Test"
```

### Provider 单元测试

```python
# test_provider.py
import pytest
from unittest.mock import Mock, patch

class TestOpenAIProvider:
    """OpenAI Provider 测试"""
    
    def test_api_call(self):
        """测试API调用"""
        from providers.openai import OpenAIProvider
        
        provider = OpenAIProvider(api_key="test-key")
        
        with patch('requests.post') as mock:
            mock.return_value.json.return_value = {
                "choices": [{"message": {"content": "test response"}}]
            }
            
            result = provider.chat("Hello")
            
            assert result == "test response"
    
    def test_error_handling(self):
        """测试错误处理"""
        from providers.openai import OpenAIProvider
        
        provider = OpenAIProvider(api_key="invalid")
        
        with pytest.raises(AuthenticationError):
            provider.chat("test")


class TestAnthropicProvider:
    """Anthropic Provider 测试"""
    
    def test_api_call(self):
        """测试API调用"""
        from providers.anthropic import AnthropicProvider
        
        provider = AnthropicProvider(api_key="test-key")
        
        with patch('requests.post') as mock:
            mock.return_value.json.return_value = {
                "content": [{"text": "test response"}]
            }
            
            result = provider.chat("Hello")
            
            assert result == "test response"
```

---

## 3. 集成测试

### 任务流程集成测试

```python
# test_integration.py
import pytest
import time

class TestTaskFlow:
    """任务流程集成测试"""
    
    def test_simple_task_flow(self, auth_headers):
        """测试简单任务流程"""
        # 1. 创建任务
        task = requests.post(f"{BASE_URL}/tasks", headers=auth_headers, json={
            "type": "code",
            "requirements": "写一个打印hello的函数",
            "assignee": "coder"
        }).json()["data"]
        
        task_id = task["id"]
        
        # 2. 等待执行
        max_wait = 60
        start = time.time()
        while time.time() - start < max_wait:
            status = requests.get(
                f"{BASE_URL}/tasks/{task_id}",
                headers=auth_headers
            ).json()["data"]["status"]
            
            if status in ["completed", "failed"]:
                break
            time.sleep(2)
        
        # 3. 验证结果
        result = requests.get(
            f"{BASE_URL}/tasks/{task_id}",
            headers=auth_headers
        ).json()["data"]
        
        assert result["status"] == "completed"
        assert result["output"] is not None
    
    def test_parallel_tasks(self, auth_headers):
        """测试并行任务"""
        # 创建多个任务
        task_ids = []
        for i in range(3):
            task = requests.post(f"{BASE_URL}/tasks", headers=auth_headers, json={
                "type": "code",
                "requirements": f"任务{i}"
            }).json()["data"]
            task_ids.append(task["id"])
        
        # 验证都完成
        for task_id in task_ids:
            status = requests.get(
                f"{BASE_URL}/tasks/{task_id}",
                headers=auth_headers
            ).json()["data"]["status"]
            
            assert status in ["completed", "failed"]
```

### Agent 协作集成测试

```python
class TestAgentCollaboration:
    """Agent协作集成测试"""
    
    def test_researcher_to_writer_flow(self, auth_headers):
        """测试调研->写作流程"""
        # 1. 创建调研任务
        task1 = requests.post(f"{BASE_URL}/tasks", headers=auth_headers, json={
            "type": "research",
            "requirements": "调研AI Agent趋势",
            "assignee": "researcher"
        }).json()["data"]
        
        # 等待调研完成
        self._wait_for_completion(task1["id"], auth_headers)
        
        # 2. 基于调研结果创建写作任务
        task2 = requests.post(f"{BASE_URL}/tasks", headers=auth_headers, json={
            "type": "write",
            "requirements": "基于调研写报告",
            "context": {"research_task": task1["id"]},
            "assignee": "writer"
        }).json()["data"]
        
        # 3. 验证写作完成
        result = self._wait_for_completion(task2["id"], auth_headers)
        
        assert result["status"] == "completed"
        assert "output" in result
    
    def _wait_for_completion(self, task_id, headers, timeout=120):
        """等待任务完成"""
        start = time.time()
        while time.time() - start < timeout:
            result = requests.get(
                f"{BASE_URL}/tasks/{task_id}",
                headers=headers
            ).json()["data"]
            
            if result["status"] in ["completed", "failed"]:
                return result
            time.sleep(2)
        
        raise TimeoutError(f"Task {task_id} timeout")
```

---

## 4. E2E 测试

### 完整用户流程测试

```python
# test_e2e.py
class TestEndToEnd:
    """E2E 测试"""
    
    def test_complete_user_flow(self):
        """测试完整用户流程"""
        
        # 1. 用户登录
        user = auth.login("user", "pass")
        token = user["token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        # 2. 用户提交任务
        task = requests.post(f"{BASE_URL}/tasks", headers=headers, json={
            "type": "complex",
            "requirements": "做一个天气预报小程序",
            "priority": "P0"
        }).json()["data"]
        
        # 3. 等待处理
        result = self._wait_for_task_completion(task["id"], headers, timeout=300)
        
        # 4. 验证结果
        assert result["status"] == "completed"
        assert result["output"]["files"] is not None
        
        # 5. 验证质量
        assert "success_rate" in result.get("metrics", {})
        
        # 6. 用户确认
        requests.post(f"{BASE_URL}/tasks/{task['id']}/confirm", headers=headers)
    
    def test_error_recovery(self):
        """测试错误恢复"""
        
        # 1. 模拟失败
        with patch('app.agents.coder.execute', side_effect=Exception("Mock error")):
            task = requests.post(f"{BASE_URL}/tasks", headers=auth_headers, json={
                "type": "code",
                "requirements": "test"
            }).json()["data"]
        
        # 2. 验证重试
        status = self._wait_for_completion(task["id"], auth_headers, timeout=180)
        
        # 3. 验证恢复
        assert status["status"] in ["completed", "failed"]
        assert "error" in status or "output" in status
```

### 性能测试

```python
# test_performance.py
import time
import concurrent.futures

class TestPerformance:
    """性能测试"""
    
    def test_concurrent_tasks(self):
        """测试并发任务"""
        
        def create_task(i):
            return requests.post(f"{BASE_URL}/tasks", headers=auth_headers, json={
                "type": "code",
                "requirements": f"任务{i}"
            })
        
        # 并发创建10个任务
        start = time.time()
        
        with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
            futures = [executor.submit(create_task, i) for i in range(10)]
            results = [f.result() for f in futures]
        
        duration = time.time() - start
        
        # 验证
        assert all(r.status_code == 201 for r in results)
        assert duration < 10  # 10秒内完成
    
    def test_response_time(self):
        """测试响应时间"""
        
        times = []
        for _ in range(10):
            start = time.time()
            requests.get(f"{BASE_URL}/health")
            times.append(time.time() - start)
        
        avg_time = sum(times) / len(times)
        p95_time = sorted(times)[int(len(times) * 0.95)]
        
        assert avg_time < 0.5  # 平均 < 500ms
        assert p95_time < 1.0  # P95 < 1s
```

---

## 5. 测试用例库

### 测试用例表

| ID | 用例 | 类型 | 预期结果 | 优先级 |
|----|------|------|---------|--------|
| TC001 | 创建代码任务 | 单元 | 任务创建成功 | P0 |
| TC002 | 执行代码任务 | 集成 | 代码生成正确 | P0 |
| TC003 | 任务超时处理 | 集成 | 超时正确处理 | P1 |
| TC004 | Provider失败切换 | 集成 | 自动切换 | P1 |
| TC005 | 并行任务 | 集成 | 无阻塞 | P1 |
| TC006 | 串行任务 | 集成 | 顺序正确 | P1 |
| TC007 | 任务取消 | E2E | 正确取消 | P2 |
| TC008 | 用户权限 | 安全 | 权限正确 | P0 |
| TC009 | API限流 | 性能 | 限流正确 | P1 |
| TC010 | 高并发 | 性能 | 系统稳定 | P2 |

### 测试数据

```python
# test_data.py
TEST_CASES = {
    "code": {
        "simple": "写一个打印hello的函数",
        "medium": "写一个Python类，实现栈的基本操作",
        "complex": "实现一个完整的用户认证系统"
    },
    "research": {
        "simple": "什么是AI Agent",
        "medium": "AI Agent 2025年发展趋势",
        "complex": "对比分析 OpenAI vs Anthropic vs Google"
    },
    "write": {
        "simple": "写一封邮件",
        "medium": "写一份产品介绍文档",
        "complex": "写一份完整的技术方案"
    }
}
```

---

## 6. CI/CD 集成

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Test

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
    
    - name: Install dependencies
      run: |
        pip install -r requirements.txt
        pip install pytest pytest-cov
    
    - name: Run unit tests
      run: pytest tests/unit/ -v --cov
    
    - name: Run integration tests
      run: pytest tests/integration/ -v
    
    - name: Run E2E tests
      run: pytest tests/e2e/ -v
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
    - name: Deploy
      run: |
        echo "Deploying..."
```

### 本地测试运行

```bash
# 运行所有测试
pytest

# 运行单元测试
pytest tests/unit/ -v

# 运行集成测试
pytest tests/integration/ -v

# 运行E2E测试
pytest tests/e2e/ -v

# 运行特定文件
pytest tests/test_coder.py -v

# 生成覆盖率报告
pytest --cov=app --cov-report=html

# 并行运行
pytest -n auto
```

---

*文档版本: 2026-02-21 v3.0*

---

## 本地验证指南

### 快速验证步骤

```bash
# 1. 启动本地环境
cd /home/dm/.openclaw
docker-compose up -d

# 2. 检查服务状态
curl http://localhost:8080/health

# 3. 运行单元测试
pytest tests/unit/ -v

# 4. 运行集成测试
pytest tests/integration/ -v

# 5. 运行 E2E 测试
pytest tests/e2e/ -v
```

### 验证清单

| # | 验证项 | 预期结果 | 实际结果 | 状态 |
|---|--------|---------|---------|------|
| 1 | API 健康检查 | 返回 200 | ⬜ | 待验证 |
| 2 | 创建任务 | 任务创建成功 | ⬜ | 待验证 |
| 3 | 任务分配 | 分配给正确 Agent | ⬜ | 待验证 |
| 4 | 任务执行 | 执行完成 | ⬜ | 待验证 |
| 5 | 并行任务 | 无阻塞 | ⬜ | 待验证 |
| 6 | 串行任务 | 顺序正确 | ⬜ | 待验证 |
| 7 | Provider 切换 | 切换成功 | ⬜ | 待验证 |
| 8 | 错误处理 | 错误被捕获 | ⬜ | 待验证 |

### 验证记录模板

```markdown
## 验证记录

### 验证日期: 2026-02-21

| 功能 | 预期 | 实际 | 通过 |
|------|------|------|------|
| API 健康 | 200 OK | ? | ⬜ |
| 创建任务 | 201 Created | ? | ⬜ |
| ... | ... | ... | ... |

### 问题记录

- 问题1: xxx
- 问题2: xxx

### 修复记录

- 修复1: xxx
```
