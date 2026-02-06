#!/bin/sh
set -e

# 1. 交互输入
read -p "Enter SOCKS5 port [1080]: " INPUT_PORT
read -p "Enter username [fiverr]: " INPUT_USER
read -p "Enter password (leave empty to auto-generate): " INPUT_PASS
echo ""

PORT=${INPUT_PORT:-1080}
USER=${INPUT_USER:-fiverr}

# 2. 密码生成 (不依赖 openssl)
if [ -z "$INPUT_PASS" ]; then
  PASS=$(date +%s | md5sum | cut -c1-12)
else
  PASS="$INPUT_PASS"
fi

# 3. 获取 IP (不依赖外部 curl)
IP="Your_Server_IP"

# 4. 直接生成配置文件 (不依赖 envsubst)
cat > /etc/3proxy/3proxy.cfg <<EOF
daemon
maxconn 100
nserver 1.1.1.1
nserver 8.8.8.8
users ${USER}:CL:${PASS}
auth strong
allow ${USER}
socks -p${PORT}
EOF

# 5. 打印信息
echo ""
echo "================ SOCKS5 NODE INFO ================"
echo "Protocol : SOCKS5"
echo "IP       : ${IP}"
echo "Port     : ${PORT}"
echo "Username : ${USER}"
echo "Password : ${PASS}"
echo "================================================="
echo ""

# 6. 运行程序
exec 3proxy /etc/3proxy/3proxy.cfg
