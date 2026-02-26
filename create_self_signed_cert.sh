#!/bin/bash

# 创建自签名证书脚本（使用用户钥匙串）
# 无需 Apple Developer 账户，适用于个人使用和小范围分发

CERT_NAME="Self-Signed Certificate for swxTools"
TEAM_ID="SELF001"

echo "=========================================="
echo "创建自签名证书"
echo "=========================================="

# 检查是否已存在同名证书
if security find-certificate -c "$CERT_NAME" ~/Library/Keychains/login.keychain-db &>/dev/null || \
   security find-certificate -c "$CERT_NAME" ~/Library/Keychains/login.keychain &>/dev/null; then
    echo "证书已存在，删除旧证书..."
    security delete-certificate -c "$CERT_NAME" ~/Library/Keychains/login.keychain-db 2>/dev/null || \
    security delete-certificate -c "$CERT_NAME" ~/Library/Keychains/login.keychain 2>/dev/null || true
fi

# 创建自签名证书
echo "创建新的自签名证书..."
cat > /tmp/cert.conf <<EOF
[req]
default_bits = 2048
distinguished_name = req_distinguished_name
x509_extensions = usr_cert
prompt = no

[req_distinguished_name]
CN = $CERT_NAME

[usr_cert]
basicConstraints = critical,CA:TRUE
keyUsage = critical,digitalSignature,keyCertSign
EOF

# 生成私钥和证书
openssl req -x509 -newkey rsa:2048 -keyout /tmp/cert.key -out /tmp/cert.crt -days 3650 -nodes -config /tmp/cert.conf 2>/dev/null

# 导入到用户钥匙串
echo "导入证书到用户钥匙串..."
security import /tmp/cert.key -k ~/Library/Keychains/login.keychain-db -A 2>/dev/null || \
security import /tmp/cert.key -k ~/Library/Keychains/login.keychain -A
security import /tmp/cert.crt -k ~/Library/Keychains/login.keychain-db -A 2>/dev/null || \
security import /tmp/cert.crt -k ~/Library/Keychains/login.keychain -A

# 设置证书信任
echo "设置证书信任..."
security add-trusted-cert -d -r trustAsRoot -k ~/Library/Keychains/login.keychain-db /tmp/cert.crt 2>/dev/null || \
security add-trusted-cert -d -r trustAsRoot -k ~/Library/Keychains/login.keychain /tmp/cert.crt

# 设置代码签名权限
echo "设置代码签名权限..."
security set-trust -s -k ~/Library/Keychains/login.keychain-db -p basic -p codeSign /tmp/cert.crt 2>/dev/null || \
security set-trust -s -k ~/Library/Keychains/login.keychain -p basic -p codeSign /tmp/cert.crt

# 清理临时文件
rm -f /tmp/cert.conf /tmp/cert.key /tmp/cert.crt

echo ""
echo "=========================================="
echo "自签名证书创建完成！"
echo "=========================================="
echo "证书名称: $CERT_NAME"
echo "Team ID: $TEAM_ID"
echo ""
echo "现在可以使用此证书签名应用了。"
echo "使用方法："
echo "  codesign --force --deep --sign \"$CERT_NAME\" swxTools.app"
