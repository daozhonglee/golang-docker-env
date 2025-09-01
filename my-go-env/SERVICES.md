# Go 开发环境 - 多服务架构

这是一个完整的云原生 Go 开发环境，包含了现代开发所需的各种中间件和工具。

## 🚀 服务清单

| 服务 | 端口 | 描述 | 访问地址 |
|------|------|------|----------|
| Go 应用 | 8087 | 主要开发服务 | http://localhost:8087 |
| Redis | 16379 | 内存缓存数据库 | localhost:16379 |
| MySQL | 13306 | 关系型数据库 | localhost:13306 |
| Nginx | 80/443 | 反向代理服务器 | http://localhost |
| Kafka | 19092 | 分布式消息队列 | localhost:19092 |
| Zookeeper | 2181 | Kafka 协调服务 | localhost:2181 |
| Elasticsearch | 19200 | 搜索和分析引擎 | http://localhost:19200 |
| Kibana | 15601 | 数据可视化平台 | http://localhost:15601 |
| Grafana | 13000 | 监控仪表板 | http://localhost:13000 |
| Prometheus | 19090 | 监控数据收集 | http://localhost:19090 |
| SSH | 2222 | 远程开发连接 | ssh developer@localhost -p 2222 |

## 🛠️ 快速开始

### 1. 启动所有服务

```bash
# 使用管理脚本（推荐）
./services.sh start

# 或者使用 docker-compose
docker-compose up -d
```

### 2. 查看服务状态

```bash
./services.sh status
```

### 3. 健康检查

```bash
./services.sh health
```

### 4. 访问服务

- **管理控制台**: http://localhost/static/
- **Go 应用**: http://localhost:8087
- **Grafana 监控**: http://localhost:3000 (admin/admin123)
- **Kibana 日志**: http://localhost:5601
- **Prometheus 指标**: http://localhost:9090

## 🔧 服务管理

### 管理脚本

```bash
./services.sh [命令]

命令:
  start         启动所有服务
  stop          停止所有服务
  restart       重启所有服务
  status        查看服务状态
  logs          查看服务日志
  pull          拉取最新镜像
  clean         清理环境
  health        健康检查
  services      显示服务访问地址
  help          显示帮助信息
```

### 查看日志

```bash
# 查看所有服务日志
./services.sh logs

# 查看特定服务日志
./services.sh logs mysql
./services.sh logs redis
./services.sh logs kafka
```

## 🗄️ 数据库连接信息

### MySQL

- **主机**: localhost
- **端口**: 13306
- **数据库**: go_dev
- **用户名**: developer
- **密码**: developer
- **Root 密码**: root123

### Redis

- **主机**: localhost
- **端口**: 16379
- **密码**: 无 (开发环境)

## 📊 监控和可观测性

### Prometheus + Grafana

1. **Prometheus**: 收集各服务的监控指标
2. **Grafana**: 提供可视化仪表板
3. **预配置数据源**: Prometheus 已自动配置为 Grafana 数据源

### ELK Stack

1. **Elasticsearch**: 存储和索引日志数据
2. **Kibana**: 日志搜索和分析界面

## 🚀 开发工作流

### 1. SSH 远程开发

```bash
ssh developer@localhost -p 2222
# 密码: developer
```

### 2. 在容器内开发

```bash
# 进入 Go 开发容器
docker exec -it go-dev-env bash

# 切换到工作目录
cd /workspace

# 运行 Go 应用
go run main.go
```

### 3. 使用各种服务

```go
// 连接 MySQL
db, err := sql.Open("mysql", "developer:developer@tcp(mysql:3306)/go_dev")

// 连接 Redis
client := redis.NewClient(&redis.Options{
    Addr: "redis:6379",
})

// 连接 Elasticsearch
es, err := elasticsearch.NewDefaultClient()
```

## 📁 目录结构

```
my-go-env/
├── docker-compose.yml          # 主要服务编排文件
├── services.sh                 # 服务管理脚本
├── config/                     # 配置文件目录
│   ├── redis.conf             # Redis 配置
│   ├── mysql/my.cnf           # MySQL 配置
│   ├── nginx/default.conf     # Nginx 配置
│   ├── grafana/               # Grafana 配置
│   └── prometheus/            # Prometheus 配置
├── init/                      # 初始化脚本
│   └── mysql/01-init.sql      # MySQL 初始化
└── static/                    # 静态文件
    └── index.html             # 管理控制台
```

## 🔧 自定义配置

### 修改服务配置

1. **编辑配置文件**: 在 `config/` 目录下修改对应服务的配置
2. **重启服务**: `./services.sh restart`

### 添加新服务

1. 在 `docker-compose.yml` 中添加新服务定义
2. 创建相应的配置文件
3. 更新 `services.sh` 脚本

### 持久化数据

所有服务的数据都存储在 Docker 数据卷中：

- `mysql-data`: MySQL 数据
- `redis-data`: Redis 数据
- `elasticsearch-data`: Elasticsearch 数据
- `grafana-data`: Grafana 配置和仪表板
- `prometheus-data`: Prometheus 监控数据

## 🐛 故障排除

### 服务启动失败

```bash
# 查看服务状态
./services.sh status

# 查看错误日志
./services.sh logs [service-name]

# 重启服务
./services.sh restart
```

### 端口冲突

如果遇到端口冲突，可以修改 `docker-compose.yml` 中的端口映射：

```yaml
ports:
  - "新端口:容器端口"
```

### 内存不足

一些服务（如 Elasticsearch）需要较多内存，可以调整 Docker Desktop 的内存限制或修改服务配置。

## 📚 扩展阅读

- [Go 官方文档](https://golang.org/doc/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [Prometheus 监控指南](https://prometheus.io/docs/)
- [Grafana 仪表板设计](https://grafana.com/docs/)
- [ELK Stack 使用指南](https://www.elastic.co/guide/)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个开发环境！
