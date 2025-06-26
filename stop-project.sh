#!/bin/bash

echo "=== 停止Spring Cloud微服务项目 ==="

# 查找并停止所有相关的Maven进程
echo "查找运行中的服务..."

# 停止Spring Boot应用
pkill -f "spring-boot:run"

# 停止Maven进程
pkill -f "mvn.*spring-boot"

# 检查特定端口的进程并停止
for port in 5001 5002 5003 5004; do
    PID=$(lsof -ti:$port 2>/dev/null)
    if [ ! -z "$PID" ]; then
        echo "停止端口 $port 上的进程 (PID: $PID)..."
        kill -9 $PID 2>/dev/null
    fi
done

echo "所有服务已停止"

# 清理日志文件（可选）
read -p "是否清理日志文件? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf logs/*.log
    echo "日志文件已清理"
fi