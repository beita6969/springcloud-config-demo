#!/bin/bash

PROJECT_ROOT="/Users/zhangmingda/Desktop/实验5/springcloud-config-demo"
LOGS_DIR="$PROJECT_ROOT/logs"

# 创建日志目录
mkdir -p "$LOGS_DIR"

echo "=== 启动Spring Cloud微服务项目 ==="

# 设置Java环境
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# 验证环境
echo "Java版本:"
java -version

echo "Maven版本:"
mvn -version

# 清理并编译项目
echo "编译项目..."
cd "$PROJECT_ROOT"
mvn clean compile -q

# 启动Config Server实例1
echo "启动Config Server实例1 (端口5001)..."
cd "$PROJECT_ROOT/config-server"
nohup mvn spring-boot:run > "$LOGS_DIR/config-server-1.log" 2>&1 &
CONFIG1_PID=$!
echo "Config Server 1 PID: $CONFIG1_PID"

# 等待服务启动
sleep 20

# 启动Config Server实例2
echo "启动Config Server实例2 (端口5002)..."
nohup mvn spring-boot:run -Dspring.profiles.active=instance2 > "$LOGS_DIR/config-server-2.log" 2>&1 &
CONFIG2_PID=$!
echo "Config Server 2 PID: $CONFIG2_PID"

# 等待服务启动
sleep 15

# 启动Service Provider
echo "启动Service Provider (端口5003)..."
cd "$PROJECT_ROOT/service-provider"
nohup mvn spring-boot:run > "$LOGS_DIR/service-provider.log" 2>&1 &
PROVIDER_PID=$!
echo "Service Provider PID: $PROVIDER_PID"

# 等待服务启动
sleep 15

# 启动Service Consumer
echo "启动Service Consumer (端口5004)..."
cd "$PROJECT_ROOT/service-consumer"
nohup mvn spring-boot:run > "$LOGS_DIR/service-consumer.log" 2>&1 &
CONSUMER_PID=$!
echo "Service Consumer PID: $CONSUMER_PID"

echo ""
echo "=== 所有服务启动完成 ==="
echo "服务访问地址:"
echo "- Config Server 1: http://localhost:5001"
echo "- Config Server 2: http://localhost:5002"
echo "- Service Provider: http://localhost:5003/provider/info"
echo "- Service Consumer: http://localhost:5004/consumer/info"
echo ""
echo "进程PID:"
echo "- Config Server 1: $CONFIG1_PID"
echo "- Config Server 2: $CONFIG2_PID"
echo "- Service Provider: $PROVIDER_PID"
echo "- Service Consumer: $CONSUMER_PID"
echo ""
echo "日志文件位置: $LOGS_DIR"
echo ""
echo "测试命令:"
echo "curl http://localhost:5003/provider/info"
echo "curl http://localhost:5004/consumer/call-provider"
echo ""
echo "停止所有服务: ./stop-project.sh"