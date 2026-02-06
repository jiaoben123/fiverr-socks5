#!/bin/bash

set -e

read -p "Enter SOCKS5 port [1080]: " INPUT_PORT
read -p "Enter username [fiverr]: " INPUT_USER
read -s -p "Enter password (leave empty to auto-generate): " INPUT_PASS
echo ""

PORT=${INPUT_PORT:-1080}
USER=${INPUT_USER:-fiverr}

if [ -z "$INPUT_PASS" ]; then
  PASS=$(openssl rand -hex 6)
else
  PASS="$INPUT_PASS"
fi

IP=$(curl -s ipv4.icanhazip.com)

export S5_PORT="$PORT"
export S5_USER="$USER"
export S5_PASS="$PASS"

envsubst < /etc/3proxy/3proxy.tpl.cfg > /etc/3proxy/3proxy.cfg

echo ""
echo "================ SOCKS5 NODE INFO ================"
echo "Protocol : SOCKS5"
echo "IP       : ${IP}"
echo "Port     : ${PORT}"
echo "Username : ${USER}"
echo "Password : ${PASS}"
echo "================================================="
echo ""

exec 3proxy /etc/3proxy/3proxy.cfg
