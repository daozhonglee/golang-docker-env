#!/bin/bash

# Go 开发环境服务管理脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印彩色信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "Go 开发环境服务管理脚本"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  start         启动所有服务"
    echo "  stop          停止所有服务"
    echo "  restart       重启所有服务"
    echo "  status        查看服务状态"
    echo "  logs          查看服务日志"
    echo "  pull          拉取最新镜像"
    echo "  clean         清理环境"
    echo "  health        健康检查"
    echo "  services      显示服务访问地址"
    echo "  help          显示此帮助信息"
    echo ""
}

# 启动服务
start_services() {
    print_info "启动 Go 开发环境服务..."
    docker-compose up -d
    print_success "服务启动完成!"
    echo ""
    show_services
}

# 停止服务
stop_services() {
    print_info "停止所有服务..."
    docker-compose down
    print_success "服务已停止!"
}

# 重启服务
restart_services() {
    print_info "重启所有服务..."
    docker-compose restart
    print_success "服务重启完成!"
}

# 查看服务状态
check_status() {
    print_info "查看服务状态..."
    docker-compose ps
}

# 查看日志
show_logs() {
    if [ -n "$2" ]; then
        print_info "查看 $2 服务日志..."
        docker-compose logs -f "$2"
    else
        print_info "查看所有服务日志..."
        docker-compose logs -f
    fi
}

# 拉取镜像
pull_images() {
    print_info "拉取最新镜像..."
    docker-compose pull
    print_success "镜像更新完成!"
}

# 清理环境
clean_environment() {
    print_warning "这将删除所有容器、数据卷和网络!"
    read -p "确认清理? (y/N): " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        print_info "清理环境..."
        docker-compose down -v --remove-orphans
        docker system prune -f
        print_success "环境清理完成!"
    else
        print_info "取消清理操作"
    fi
}

# 健康检查
health_check() {
    print_info "执行健康检查..."
    
    services=(
        "go-dev-env:8087:/health"
        "go-dev-redis:6379"
        "go-dev-mysql:3306"
        "go-dev-nginx:80:/nginx-health"
        "go-dev-elasticsearch:9200"
        "go-dev-kibana:5601"
        "go-dev-grafana:3000"
        "go-dev-prometheus:9090"
        "go-dev-kafka:9092"
    )
    
    for service in "${services[@]}"; do
        container=$(echo $service | cut -d: -f1)
        port=$(echo $service | cut -d: -f2)
        path=$(echo $service | cut -d: -f3)
        
        if docker ps --filter "name=$container" --format "{{.Names}}" | grep -q "$container"; then
            print_success "$container 运行正常"
        else
            print_error "$container 未运行"
        fi
    done
}

# 显示服务访问地址
show_services() {
    print_info "服务访问地址:"
    echo ""
    echo "🐹 Go 应用:           http://localhost:8087"
    echo "🗄️  Redis:            localhost:16379"
    echo "🐬 MySQL:            localhost:13306 (用户: developer/developer)"
    echo "🔀 Nginx:            http://localhost"
    echo "📊 Kafka:            localhost:19092"
    echo "🔍 Elasticsearch:    http://localhost:19200"
    echo "📈 Kibana:           http://localhost:15601"
    echo "📊 Grafana:          http://localhost:13000 (admin/admin123)"
    echo "🎯 Prometheus:       http://localhost:19090"
    echo ""
    echo "🔐 SSH 连接:          ssh developer@localhost -p 2222 (密码: developer)"
    echo "📊 管理控制台:        http://localhost/static/"
    echo ""
}

# 主程序
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        check_status
        ;;
    logs)
        show_logs "$@"
        ;;
    pull)
        pull_images
        ;;
    clean)
        clean_environment
        ;;
    health)
        health_check
        ;;
    services)
        show_services
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        show_help
        ;;
    *)
        print_error "未知命令: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
