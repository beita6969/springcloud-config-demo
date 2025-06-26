#!/bin/bash

# 项目根目录
PROJECT_DIR="/Users/zhangmingda/Desktop/实验5/springcloud-config-demo"

echo "启动Spring Cloud微服务..."
echo "=========================================="

echo "1. 启动Config Server (端口5001)..."
cd $PROJECT_DIR/config-server
nohup mvn spring-boot:run > ../logs/config-server.log 2>&1 &
CONFIG_PID=$!
echo "Config Server PID: $CONFIG_PID"

sleep 15

echo "2. 启动Config Server实例2 (端口5002)..."
nohup mvn spring-boot:run -Dspring.profiles.active=instance2 > ../logs/config-server-2.log 2>&1 &
CONFIG2_PID=$!
echo "Config Server 2 PID: $CONFIG2_PID"

sleep 10

echo "3. 启动Service Provider (端口5003)..."
cd $PROJECT_DIR/service-provider
nohup mvn spring-boot:run > ../logs/service-provider.log 2>&1 &
PROVIDER_PID=$!
echo "Service Provider PID: $PROVIDER_PID"

sleep 10

echo "4. 启动Service Consumer (端口5004)..."
cd $PROJECT_DIR/service-consumer
nohup mvn spring-boot:run > ../logs/service-consumer.log 2>&1 &
CONSUMER_PID=$!
echo "Service Consumer PID: $CONSUMER_PID"

echo ""
echo "所有服务启动完成！"
echo "=========================================="
echo "服务访问地址:"
echo "Config Server 1: http://localhost:5001"
echo "Config Server 2: http://localhost:5002"
echo "Service Provider: http://localhost:5003"
echo "Service Consumer: http://localhost:5004"
echo ""
echo "进程PID:"
echo "Config Server 1: $CONFIG_PID"
echo "Config Server 2: $CONFIG2_PID"
echo "Service Provider: $PROVIDER_PID"
echo "Service Consumer: $CONSUMER_PID"
echo ""
echo "日志文件在 logs/ 目录下"