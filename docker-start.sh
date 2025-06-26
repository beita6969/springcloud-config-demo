#!/bin/bash

# 启动Config Server实例1
echo "Starting Config Server 1..."
cd /app/config-server
nohup mvn spring-boot:run > /app/logs/config-server-1.log 2>&1 &

sleep 10

# 启动Config Server实例2
echo "Starting Config Server 2..."
nohup mvn spring-boot:run -Dspring.profiles.active=instance2 > /app/logs/config-server-2.log 2>&1 &

sleep 10

# 启动Service Provider
echo "Starting Service Provider..."
cd /app/service-provider
nohup mvn spring-boot:run > /app/logs/service-provider.log 2>&1 &

sleep 10

# 启动Service Consumer
echo "Starting Service Consumer..."
cd /app/service-consumer
nohup mvn spring-boot:run > /app/logs/service-consumer.log 2>&1 &

echo "All services started. Logs are in /app/logs/"
echo "Config Server 1: http://localhost:5001"
echo "Config Server 2: http://localhost:5002"
echo "Service Provider: http://localhost:5003"
echo "Service Consumer: http://localhost:5004"

# 保持容器运行
tail -f /app/logs/*.log