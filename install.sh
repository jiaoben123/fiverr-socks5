#!/bin/bash

# 1. 在宿主机提问
read -p "Enter SOCKS5 port [1080]: " S5_PORT
read -p "Enter username [fiverr]: " S5_USER
read -p "Enter password: " S5_PASS

# 2. 设置默认值
export S5_PORT=${S5_PORT:-1080}
export S5_USER=${S5_USER:-fiverr}
export S5_PASS=${S5_PASS:-pass$(date +%s)}

# 3. 写入环境文件，让 Docker 能读取到
cat > .env <<EOF
S5_PORT=$S5_PORT
S5_USER=$S5_USER
S5_PASS=$S5_PASS
EOF

# 4. 启动容器
docker compose down --remove-orphans
docker compose up -d

echo "=========================================="
echo "SOCKS5 节点已在后台启动！"
echo "IP: $(curl -s ipv4.icanhazip.com)"
echo "Port: $S5_PORT"
echo "User: $S5_USER"
echo "Pass: $S5_PASS"
echo "=========================================="
