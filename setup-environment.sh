#!/bin/bash

echo "=== Spring Cloud项目环境设置脚本 ==="
echo ""

# 显示选项菜单
echo "请选择环境设置方式:"
echo "1) 本地环境安装 (Java + Maven)"
echo "2) Docker环境设置"
echo "3) 检查当前环境"
echo "4) 退出"
echo ""

read -p "请输入选择 (1-4): " choice

case $choice in
    1)
        echo ""
        echo "=== 开始本地环境安装 ==="
        
        # 检测操作系统
        OS=$(uname -s)
        ARCH=$(uname -m)
        echo "系统信息: $OS $ARCH"
        
        if [[ "$OS" == "Darwin" ]]; then
            # macOS系统
            echo "检测到macOS系统，使用Homebrew安装..."
            
            # 检查Homebrew
            if ! command -v brew &> /dev/null; then
                echo "安装Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            else
                echo "Homebrew已安装"
            fi
            
            # 安装Java 17
            if ! brew list openjdk@17 &> /dev/null; then
                echo "安装OpenJDK 17..."
                brew install openjdk@17
            else
                echo "OpenJDK 17已安装"
            fi
            
            # 设置Java环境变量
            echo "设置Java环境变量..."
            if ! grep -q "openjdk@17" ~/.zshrc; then
                echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
                echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@17"' >> ~/.zshrc
            fi
            
            # 创建符号链接
            if [ ! -L "/Library/Java/JavaVirtualMachines/openjdk-17.jdk" ]; then
                sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
            fi
            
            # 安装Maven
            if ! brew list maven &> /dev/null; then
                echo "安装Maven..."
                brew install maven
            else
                echo "Maven已安装"
            fi
            
        elif [[ "$OS" == "Linux" ]]; then
            # Linux系统
            echo "检测到Linux系统..."
            
            # 检测Linux发行版
            if command -v apt-get &> /dev/null; then
                # Debian/Ubuntu
                echo "使用apt-get安装..."
                sudo apt-get update
                
                # 安装Java 17
                echo "安装OpenJDK 17..."
                sudo apt-get install -y openjdk-17-jdk
                
                # 安装Maven
                echo "安装Maven..."
                sudo apt-get install -y maven
                
            elif command -v yum &> /dev/null; then
                # CentOS/RHEL
                echo "使用yum安装..."
                
                # 安装Java 17
                echo "安装OpenJDK 17..."
                sudo yum install -y java-17-openjdk-devel
                
                # 安装Maven
                echo "安装Maven..."
                sudo yum install -y maven
                
            elif command -v dnf &> /dev/null; then
                # Fedora
                echo "使用dnf安装..."
                
                # 安装Java 17
                echo "安装OpenJDK 17..."
                sudo dnf install -y java-17-openjdk-devel
                
                # 安装Maven
                echo "安装Maven..."
                sudo dnf install -y maven
            else
                echo "不支持的Linux发行版，请手动安装Java 17和Maven"
                exit 1
            fi
            
            # 设置Java环境变量
            echo "设置Java环境变量..."
            if ! grep -q "JAVA_HOME" ~/.bashrc; then
                echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"' >> ~/.bashrc
                echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
            fi
        else
            echo "不支持的操作系统: $OS"
            exit 1
        fi
        
        echo ""
        echo "=== 验证安装 ==="
        java -version
        mvn -version
        
        echo ""
        echo "=== 本地环境设置完成 ==="
        echo "请重新启动终端或运行: source ~/.bashrc (Linux) 或 source ~/.zshrc (macOS)"
        echo "然后使用以下命令启动项目:"
        echo "cd $(pwd)"
        echo "./start-project.sh"
        ;;
        
    2)
        echo ""
        echo "=== 开始Docker环境设置 ==="
        
        # 检查Docker
        if ! command -v docker &> /dev/null; then
            echo "Docker未安装，请先安装Docker："
            echo "macOS: https://docs.docker.com/desktop/mac/install/"
            echo "Linux: https://docs.docker.com/engine/install/"
            echo "Windows: https://docs.docker.com/desktop/windows/install/"
            exit 1
        fi
        
        # 检查Docker Compose
        if ! command -v docker-compose &> /dev/null; then
            echo "Docker Compose未安装，请先安装Docker Compose"
            exit 1
        fi
        
        echo "Docker环境检查通过！"
        echo ""
        echo "使用Docker启动项目："
        echo "cd $(pwd)"
        echo "docker-compose up -d"
        echo ""
        echo "停止项目："
        echo "docker-compose down"
        ;;
        
    3)
        echo ""
        echo "=== 环境检查 ==="
        
        # 检查Java
        if command -v java &> /dev/null; then
            echo "✓ Java已安装:"
            java -version
        else
            echo "✗ Java未安装"
        fi
        
        echo ""
        
        # 检查Maven
        if command -v mvn &> /dev/null; then
            echo "✓ Maven已安装:"
            mvn -version
        else
            echo "✗ Maven未安装"
        fi
        
        echo ""
        
        # 检查Docker
        if command -v docker &> /dev/null; then
            echo "✓ Docker已安装:"
            docker --version
        else
            echo "✗ Docker未安装"
        fi
        
        echo ""
        
        # 检查Docker Compose
        if command -v docker-compose &> /dev/null; then
            echo "✓ Docker Compose已安装:"
            docker-compose --version
        else
            echo "✗ Docker Compose未安装"
        fi
        ;;
        
    4)
        echo "退出设置脚本"
        exit 0
        ;;
        
    *)
        echo "无效选择，请重新运行脚本"
        exit 1
        ;;
esac