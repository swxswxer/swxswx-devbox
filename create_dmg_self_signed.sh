#!/bin/bash

# 使用自签名证书打包脚本（美化 DMG）
# 适用于个人使用和小范围分发

# 设置变量
APP_NAME="swxTools"
APP_PATH="/Users/swxswx/Desktop/code/work-code/swxTools/build/bin/${APP_NAME}.app"
DMG_PATH="/Users/swxswx/Desktop/code/work-code/swxTools/${APP_NAME}.dmg"
TEMP_DIR="/tmp/${APP_NAME}_dmg"

# 自签名证书配置
CERT_NAME="Self-Signed Certificate for swxTools"

echo "=========================================="
echo "使用自签名证书打包 $APP_NAME"
echo "=========================================="

# 检查证书是否存在
if ! security find-certificate -c "$CERT_NAME" /Library/Keychains/System.keychain &>/dev/null; then
    echo "错误: 自签名证书不存在"
    echo "请先运行: ./create_self_signed_cert.sh"
    exit 1
fi

# 检查应用是否存在
if [ ! -d "$APP_PATH" ]; then
    echo "错误: 应用不存在于 $APP_PATH"
    echo "请先运行 'wails build' 构建应用"
    exit 1
fi

# 移除所有扩展属性
echo "移除扩展属性..."
xattr -cr "$APP_PATH"

# 确保可执行权限
echo "设置可执行权限..."
chmod -R 755 "$APP_PATH"
chmod +x "$APP_PATH/Contents/MacOS/swxTools"

# 移除任何现有的签名
echo "移除现有签名..."
codesign --remove-signature "$APP_PATH" 2>/dev/null || true

# 使用自签名证书签名
echo "使用自签名证书签名..."
codesign --force --deep --sign "$CERT_NAME" "$APP_PATH"

# 验证签名
echo "验证签名..."
codesign -v "$APP_PATH" 2>&1
if [ $? -eq 0 ]; then
    echo "✓ 签名验证成功"
else
    echo "✗ 签名验证失败"
    exit 1
fi

# 显示签名信息
echo ""
echo "签名信息："
codesign -dvv "$APP_PATH"

# 清理之前的临时目录
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

# 创建临时目录
mkdir -p "$TEMP_DIR"

# 复制应用到临时目录
echo "复制应用到临时目录..."
cp -R "$APP_PATH" "$TEMP_DIR/"

# 使用 create-dmg 创建美观的 DMG
if command -v create-dmg &> /dev/null; then
    echo "使用 create-dmg 创建美观的 DMG..."
    create-dmg \
      --volname "$APP_NAME" \
      --window-pos 200 120 \
      --window-size 600 300 \
      --icon-size 100 \
      --icon "${APP_NAME}.app" 175 120 \
      --hide-extension "${APP_NAME}.app" \
      --app-drop-link 425 120 \
      "$DMG_PATH" \
      "$TEMP_DIR"
else
    # 使用系统自带的 hdiutil
    echo "使用 hdiutil 创建 DMG..."
    hdiutil create -volname "$APP_NAME" -srcfolder "$TEMP_DIR" -ov -format UDZO "$DMG_PATH"
fi

# 清理临时目录
echo "清理临时目录..."
rm -rf "$TEMP_DIR"

echo ""
echo "=========================================="
echo "打包完成！"
echo "=========================================="
echo "DMG 文件: $DMG_PATH"
echo ""
echo "注意：使用自签名证书的应用，其他用户首次打开时需要："
echo "1. 右键点击应用 -> 打开 -> 点击'打开'按钮"
echo "2. 或者在系统偏好设置 -> 安全性与隐私 -> 允许从以下位置下载的应用"
echo ""
echo "如需完全绕过安全检查，用户可以运行："
echo "  sudo xattr -cr /Applications/swxTools.app"
echo "  sudo spctl --master-disable"
