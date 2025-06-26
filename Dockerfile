FROM openjdk:17-jdk-slim

# 安装Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 编译项目
RUN mvn clean package -DskipTests

# 暴露端口
EXPOSE 5001 5002 5003 5004

# 启动脚本
COPY docker-start.sh /app/
RUN chmod +x /app/docker-start.sh

CMD ["./docker-start.sh"]