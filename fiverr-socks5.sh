#!/bin/sh
set -e

# 1. 交互输入
read -p "Enter SOCKS5 port [1080]: " INPUT_PORT
read -p "Enter username [fiverr]: " INPUT_USER
read -p "Enter password (leave empty to auto-generate): " INPUT_PASS
echo ""

PORT=${INPUT_PORT:-1080}
USER=${INPUT_USER:-fiverr}

# 2. 密码生成 (使用自带的 date, 不依赖 md5sum)
if [ -z "$INPUT_PASS" ]; then
  PASS="pass$(date +%s)"
else
  PASS="$INPUT_PASS"
fi

# 3. 直接生成配置文件 (去除变量注入依赖)
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

# 4. 打印信息
echo ""
echo "================ SOCKS5 NODE INFO ================"
echo "Protocol : SOCKS5"
echo "Port     : ${PORT}"
echo "Username : ${USER}"
echo "Password : ${PASS}"
echo "================================================="
echo ""

# 5. 运行程序
exec 3proxy /etc/3proxy/3proxy.cfg
