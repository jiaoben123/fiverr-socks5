#!/bin/sh
set -e

read -p "Enter SOCKS5 port [1080]: " INPUT_PORT
read -p "Enter username [fiverr]: " INPUT_USER
read -p "Enter password (leave empty to auto-generate): " INPUT_PASS
echo ""

PORT=${INPUT_PORT:-1080}
USER=${INPUT_USER:-fiverr}

# 无 openssl，简单生成密码
if [ -z "$INPUT_PASS" ]; then
  PASS=$(date +%s | sha256sum | cut -c1-12)
else
  PASS="$INPUT_PASS"
fi

# 不用 envsubst，直接生成配置
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

echo ""
echo "================ SOCKS5 NODE INFO ================"
echo "Protocol : SOCKS5"
echo "IP       : <YOUR_VPS_IP>"
echo "Port     : ${PORT}"
echo "Username : ${USER}"
echo "Password : ${PASS}"
echo "================================================="
echo ""

exec 3proxy /etc/3proxy/3proxy.cfg
