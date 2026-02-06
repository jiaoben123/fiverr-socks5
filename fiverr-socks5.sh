#!/bin/sh
set -e

# 直接从环境变量读取，不再 read
cat > /etc/3proxy/3proxy.cfg <<EOF
daemon
maxconn 100
nserver 1.1.1.1
nserver 8.8.8.8
users ${S5_USER}:CL:${S5_PASS}
auth strong
allow ${S5_USER}
socks -p${S5_PORT}
EOF

exec 3proxy /etc/3proxy/3proxy.cfg
