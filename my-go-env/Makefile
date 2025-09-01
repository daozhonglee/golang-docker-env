.PHONY: build up down restart logs shell clean help

# 默认目标
help:
	@echo "Go 开发环境 Docker 管理命令："
	@echo ""
	@echo "  make build    - 构建 Docker 镜像"
	@echo "  make up       - 启动容器"
	@echo "  make down     - 停止容器"
	@echo "  make restart  - 重启容器"
	@echo "  make logs     - 查看容器日志"
	@echo "  make shell    - 进入容器 shell"
	@echo "  make clean    - 清理容器和镜像"
	@echo "  make ssh      - SSH 连接到容器"
	@echo ""

# 构建镜像
build:
	@echo "构建 Go 开发环境镜像..."
	docker-compose build

# 启动容器
up:
	@echo "启动 Go 开发环境..."
	docker-compose up -d
	@echo "容器已启动，SSH 连接信息："
	@echo "  ssh developer@localhost -p 2222"
	@echo "  密码: developer"

# 停止容器
down:
	@echo "停止容器..."
	docker-compose down

# 重启容器
restart: down up

# 查看日志
logs:
	docker-compose logs -f

# 进入容器 shell
shell:
	docker exec -it go-dev-env bash

# SSH 连接
ssh:
	ssh developer@localhost -p 2222

# 清理环境
clean:
	@echo "清理 Docker 环境..."
	docker-compose down -v
	docker rmi go-dev-env_go-dev 2>/dev/null || true
	docker system prune -f

# 完整重建
rebuild: clean build up
