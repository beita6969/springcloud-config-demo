# Spring Cloud Config Demo

这是一个Spring Cloud微服务架构示例，演示了Spring Cloud Config配置中心集群和Spring Cloud Bus动态配置刷新机制。

## 技术栈
- Spring Boot 3.0.5
- Spring Cloud 2022.0.2
- Spring Cloud Config
- Spring Cloud Bus
- RabbitMQ
- Eureka

## 项目结构
```
springcloud-config-demo/
├── config-repo/               # 配置文件仓库
├── eureka-server/            # Eureka服务注册中心
├── config-server/            # Config配置中心
├── service-provider/         # 服务提供者
└── service-consumer/         # 服务消费者
```

## 前置要求

1. Java 17+
2. Maven 3.6+
3. RabbitMQ (需要先安装Erlang)

## 安装RabbitMQ

### macOS:
```bash
brew install rabbitmq
brew services start rabbitmq
```

### 访问RabbitMQ管理界面:
- URL: http://localhost:15672
- 默认用户名: guest
- 默认密码: guest

## 启动服务

### 1. 启动Eureka Server
```bash
cd eureka-server
mvn spring-boot:run
```
访问: http://localhost:8761

### 2. 启动Config Server集群

第一个实例:
```bash
cd config-server
mvn spring-boot:run
```

第二个实例:
```bash
cd config-server
mvn spring-boot:run -Dspring.profiles.active=instance2
```

### 3. 启动Service Provider
```bash
cd service-provider
mvn spring-boot:run
```

### 4. 启动Service Consumer
```bash
cd service-consumer
mvn spring-boot:run
```

## 测试

### 1. 测试服务调用
- Provider信息: http://localhost:8001/provider/info
- Consumer信息: http://localhost:8002/consumer/info
- Consumer调用Provider: http://localhost:8002/consumer/call-provider

### 2. 测试动态配置刷新

1. 修改配置文件 `config-repo/service-provider-dev.yml` 或 `config-repo/service-consumer-dev.yml`

2. 提交更改到Git仓库:
```bash
cd config-repo
git add .
git commit -m "Update configuration"
```

3. 刷新单个服务的配置:
```bash
curl -X POST http://localhost:8001/actuator/refresh
```

4. 通过Bus刷新所有服务的配置:
```bash
curl -X POST http://localhost:8888/actuator/bus-refresh
```

## 配置说明

- 所有微服务通过Eureka发现Config Server
- Config Server以集群方式运行，提高可用性
- 使用RabbitMQ作为消息总线，实现配置的动态刷新
- 所有Controller使用@RefreshScope注解，支持配置热更新