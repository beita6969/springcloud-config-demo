# 手动启动Spring Cloud微服务项目指南

由于环境限制，请按以下步骤手动启动项目：

## 前置要求
1. 确保已安装 Java 17+
2. 确保已安装 Maven 3.6+
3. 确保 RabbitMQ 正在运行

## 启动步骤

### 1. 安装依赖（在项目根目录执行）
```bash
cd /Users/zhangmingda/Desktop/实验5/springcloud-config-demo
mvn clean install -DskipTests
```

### 2. 启动Config Server第一个实例
```bash
cd config-server
mvn spring-boot:run
```
启动成功后访问: http://localhost:5001

### 3. 启动Config Server第二个实例（新终端窗口）
```bash
cd config-server
mvn spring-boot:run -Dspring.profiles.active=instance2
```
启动成功后访问: http://localhost:5002

### 4. 启动Service Provider（新终端窗口）
```bash
cd service-provider
mvn spring-boot:run
```
启动成功后访问: http://localhost:5003

### 5. 启动Service Consumer（新终端窗口）
```bash
cd service-consumer
mvn spring-boot:run
```
启动成功后访问: http://localhost:5004

## 测试接口

### 基本功能测试
- Provider信息: http://localhost:5003/provider/info
- Provider Hello: http://localhost:5003/provider/hello
- Consumer信息: http://localhost:5004/consumer/info
- Consumer调用Provider: http://localhost:5004/consumer/call-provider

### 配置动态刷新测试

1. 修改配置文件:
```bash
cd config-repo
# 编辑 service-provider-dev.yml 或 service-consumer-dev.yml
# 修改 message 字段的值
git add .
git commit -m "Update configuration"
```

2. 刷新单个服务配置:
```bash
curl -X POST http://localhost:5003/actuator/refresh
```

3. 通过Bus刷新所有服务配置:
```bash
curl -X POST http://localhost:5001/actuator/bus-refresh
```

## 验证结果
- 访问 http://localhost:5003/provider/info 和 http://localhost:5004/consumer/info
- 确认配置已动态更新，无需重启服务

## 注意事项
- 启动顺序很重要：先Config Server，再其他微服务
- 每个服务需要在单独的终端窗口中运行
- 确保端口5001-5004没有被其他进程占用