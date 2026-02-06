#!/bin/bash

# 1. 在宿主机提问
read -p "Enter SOCKS5 port [1080]: " S5_PORT
read -p "Enter username [fiverr]: " S5_USER
read -p "Enter password: " S5_PASS
read -p "Enter Remark (备注) [Fiverr]: " S5_REMARK

# 2. 设置默认值
export S5_PORT=${S5_PORT:-1080}
export S5_USER=${S5_USER:-fiverr}
export S5_PASS=${S5_PASS:-pass$(date +%s)}
REMARK=${S5_REMARK:-Fiverr}

# 获取服务器 IP
IP=$(curl -s ipv4.icanhazip.com)

# 3. 写入环境文件，让 Docker 能读取到
cat > .env <<EOF
S5_PORT=$S5_PORT
S5_USER=$S5_USER
S5_PASS=$S5_PASS
EOF

# 4. 启动容器
docker compose down --remove-orphans
docker compose up -d

# 5. 格式化输出 (适配指纹浏览器)
echo ""
echo "=========================================="
echo "SOCKS5 节点已在后台启动！"
echo "------------------------------------------"
echo "指纹浏览器【直接导入】格式："
echo ""
echo "socks5://${S5_USER}:${S5_PASS}@${IP}:${S5_PORT}{${REMARK}}"
echo ""
echo "------------------------------------------"
echo "单项信息备份："
echo "IP: ${IP}"
echo "Port: ${S5_PORT}"
echo "User: ${S5_USER}"
echo "Pass: ${S5_PASS}"
echo "=========================================="
