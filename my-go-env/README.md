# Go 开发环境 Docker 镜像

这是一个专门为 Go 语言开发设计的 Docker 环境，支持通过 SSH 连接进行远程开发，特别适合与 Cursor、VS Code 等编辑器配合使用。

## 功能特性

- 📦 基于 Ubuntu 22.04
- 🐹 Go 1.25.0 开发环境
- 🔧 预装常用开发工具
- 🔐 SSH 服务支持远程连接
- 📝 支持 Cursor/VS Code 远程开发
- 🛠️ 预装 Go 开发工具（gopls、dlv、goimports 等）
- 🎯 配置好的开发用户环境
- 🐚 Zsh + Oh My Zsh 现代化终端体验
- 🔍 FZF 模糊搜索工具
- 🐍 Python 3 开发环境

## 包含的工具

### 系统工具
- git, vim, nano, htop, tree
- curl, wget, unzip
- build-essential

### 终端工具
- Zsh (现代化 shell)
- Oh My Zsh (Zsh 框架)
- FZF (模糊搜索工具)

### 编程语言
- Go 1.25.0
- Python 3 (with pip)

### Go 开发工具
- gopls (Language Server) - *待安装*
- dlv (调试器) - *待安装*
- goimports (导入整理) - *待安装*
- golangci-lint (代码检查) - *待安装*

## 快速开始

### 1. 构建并启动容器

```bash
# 进入项目目录
cd my-go-env

# 使用 docker-compose 启动
docker-compose up -d

# 或者手动构建和运行
docker build -t go-dev-env .
docker run -d -p 2222:22 -p 8080:8080 -v $(pwd):/workspace --name go-dev go-dev-env
```

### 2. SSH 连接信息

- **主机**: localhost
- **端口**: 2222
- **用户名**: developer
- **密码**: developer

```bash
# 命令行连接
ssh developer@localhost -p 2222

# 或者使用 root 用户
ssh root@localhost -p 2222  # 密码: root123
```

## Cursor 远程开发配置

### 1. 安装 Remote-SSH 扩展

1. 打开 Cursor
2. 安装 "Remote - SSH" 扩展

### 2. 配置 SSH 连接

1. 按 `Ctrl+Shift+P` (或 `Cmd+Shift+P`)
2. 输入 "Remote-SSH: Connect to Host"
3. 选择 "Configure SSH Hosts"
4. 在配置文件中添加：

```
Host go-dev
    HostName localhost
    Port 2222
    User developer
    PasswordAuthentication yes
```

### 3. 连接到容器

1. 按 `Ctrl+Shift+P`
2. 输入 "Remote-SSH: Connect to Host"
3. 选择 "go-dev"
4. 输入密码 `developer`
5. 打开文件夹 `/workspace`

## 使用说明

### 开发工作流

1. 在容器的 `/workspace` 目录下开发（对应宿主机的当前目录）
2. 使用 Cursor 通过 SSH 连接到容器
3. 享受完整的 Go 开发体验

### 端口说明

- `2222`: SSH 连接端口
- `8080`: 主要应用端口
- `8081`: 调试端口
- `9000`: 其他服务端口

### 常用命令

```bash
# 查看容器状态
docker-compose ps

# 查看日志
docker-compose logs

# 停止容器
docker-compose down

# 重新构建
docker-compose up --build -d

# 进入容器
docker exec -it go-dev-env bash
```

### Go 环境变量

容器中已配置以下环境变量：

- `GOROOT=/usr/local/go`
- `GOPATH=/go`
- `GO111MODULE=on`
- `GOPROXY=https://goproxy.cn,direct`

### 数据持久化

- Go 模块缓存：`go-mod-cache` volume
- Go 构建缓存：`go-build-cache` volume
- 工作目录：挂载到宿主机当前目录

## 故障排除

### SSH 连接问题

1. 确保容器正在运行：`docker-compose ps`
2. 检查端口是否正确映射：`docker port go-dev-env`
3. 查看容器日志：`docker-compose logs`

### 权限问题

如果遇到文件权限问题，可以在容器内调整：

```bash
# 进入容器
docker exec -it go-dev-env bash

# 修改文件所有者
sudo chown -R developer:developer /workspace
```

### 重置环境

```bash
# 完全重置（会删除数据卷）
docker-compose down -v
docker rmi go-dev-env_go-dev
docker-compose up --build -d
```

## 自定义配置

### 修改用户密码

编辑 `Dockerfile` 中的密码设置：

```dockerfile
RUN echo 'developer:your_password' | chpasswd
RUN echo 'root:your_root_password' | chpasswd
```

### 安装额外工具

在 `Dockerfile` 中添加：

```dockerfile
RUN apt-get update && apt-get install -y \
    your-package-name \
    && rm -rf /var/lib/apt/lists/*
```

### 添加 Go 工具

```dockerfile
RUN go install your-go-tool@latest
```

## 安全注意事项

⚠️ **警告**: 此环境仅用于开发目的，请勿在生产环境中使用。

- 默认密码应该在生产使用前更改
- 考虑使用 SSH 密钥而非密码认证
- 限制容器的网络访问

## 许可证

MIT License
