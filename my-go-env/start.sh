#!/bin/bash

# 启动 SSH 服务
echo "启动 SSH 服务..."
service ssh start

# 显示连接信息
echo "=========================================="
echo "Go 开发环境已启动"
echo "SSH 连接信息："
echo "  主机: localhost"
echo "  端口: 2222 (如果使用 docker-compose)"
echo "  用户: developer"
echo "  密码: developer"
echo "=========================================="
echo "Go 版本: $(go version)"
echo "GOPATH: $GOPATH"
echo "GOROOT: $GOROOT"
echo "工作目录: /workspace"
echo "=========================================="

# 保持容器运行
tail -f /dev/null
