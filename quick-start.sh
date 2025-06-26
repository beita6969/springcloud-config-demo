#!/bin/bash

echo "=== Spring Cloud项目快速启动 ==="

# 检查并安装Homebrew
if ! command -v brew &> /dev/null; then
    echo "安装Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 添加Homebrew到PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 更新Homebrew
echo "更新Homebrew..."
brew update

# 安装Java 17
echo "安装OpenJDK 17..."
brew install openjdk@17

# 安装Maven
echo "安装Maven..."
brew install maven

# 设置Java环境变量
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# 验证安装
echo "验证Java安装..."
java -version

echo "验证Maven安装..."
mvn -version

# 启动项目
echo "编译项目..."
cd /Users/zhangmingda/Desktop/实验5/springcloud-config-demo
mvn clean compile -DskipTests

echo "启动Config Server..."
cd config-server
nohup mvn spring-boot:run > ../logs/config-server.log 2>&1 &

sleep 15

echo "启动Service Provider..."
cd ../service-provider  
nohup mvn spring-boot:run > ../logs/provider.log 2>&1 &

sleep 10

echo "启动Service Consumer..."
cd ../service-consumer
nohup mvn spring-boot:run > ../logs/consumer.log 2>&1 &

echo "项目启动完成！"
echo "访问地址:"
echo "- Provider: http://localhost:5003/provider/info"
echo "- Consumer: http://localhost:5004/consumer/info"