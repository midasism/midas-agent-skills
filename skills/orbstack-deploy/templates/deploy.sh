#!/usr/bin/env bash

# ==============================================================================
# OrbStack / Docker 本地容器化通用运维脚本
# ==============================================================================

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"

PROJECT_NAME="$(basename "$DIR")"

check_orbstack() {
  if command -v orbctl >/dev/null 2>&1; then
    local status
    status=$(orbctl status 2>/dev/null || echo "Stopped")
    if [ "$status" != "Running" ]; then
      echo "🚀 正在启动 OrbStack 引擎..."
      orbctl start
      sleep 2
    fi
  fi
}

check_env() {
  if [ ! -f ".env.local" ] && [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
      echo "⚠️  未检测到环境配置文件，正在从 .env.example 复制模板..."
      cp .env.example .env.local 2>/dev/null || cp .env.example .env
      echo "✅ 已生成环境配置文件，请填入真实密钥后运行。"
    fi
  fi
}

case "$1" in
  start|up)
    check_orbstack
    check_env
    echo "🚀 正在启动 $PROJECT_NAME 容器..."
    docker compose up -d
    echo ""
    echo "=========================================================="
    echo "🎉 服务已在后台成功启动！"
    echo "📊 OrbStack: 可在 Mac 原生 App 中查看日志与资源占用"
    echo "📜 查看实时日志: ./scripts/deploy.sh logs"
    echo "=========================================================="
    ;;

  stop|down)
    echo "🛑 正在停止 $PROJECT_NAME 容器..."
    docker compose down
    echo "✅ 服务已停止。"
    ;;

  restart)
    check_orbstack
    echo "🔄 正在重启服务..."
    docker compose restart
    echo "✅ 重启成功！"
    ;;

  logs)
    docker compose logs -f --tail=100
    ;;

  rebuild)
    check_orbstack
    check_env
    echo "🔨 重新编译镜像并启动..."
    docker compose build --no-cache
    docker compose up -d
    echo "✅ 镜像重新编译并启动完成！"
    ;;

  status)
    docker compose ps
    ;;

  *)
    echo "使用方法: $0 {start|stop|restart|logs|rebuild|status}"
    echo ""
    echo "  start   - 启动服务（后台常驻）"
    echo "  stop    - 停止服务"
    echo "  restart - 重启服务"
    echo "  logs    - 实时查看容器日志"
    echo "  rebuild - 重新构建镜像并启动"
    echo "  status  - 查看容器运行状态"
    exit 1
    ;;
esac
