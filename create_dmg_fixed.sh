#!/bin/bash

# 设置变量
APP_NAME="swxTools"
APP_PATH="/Users/swxswx/Desktop/code/work-code/swxTools/build/bin/${APP_NAME}.app"
DMG_PATH="/Users/swxswx/Desktop/code/work-code/swxTools/${APP_NAME}.dmg"
TEMP_DIR="/tmp/${APP_NAME}_dmg"

echo "=========================================="
echo "开始打包 $APP_NAME"
echo "=========================================="

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

# 重新签名（ad-hoc 签名）
echo "重新签名应用..."
codesign --force --deep --sign - "$APP_PATH"

# 验证签名
echo "验证签名..."
codesign -v "$APP_PATH" 2>&1
if [ $? -eq 0 ]; then
    echo "✓ 签名验证成功"
else
    echo "✗ 签名验证失败"
    exit 1
fi

# 清理之前的临时目录
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

# 创建临时目录
mkdir -p "$TEMP_DIR"

# 复制应用到临时目录
echo "复制应用到临时目录..."
cp -R "$APP_PATH" "$TEMP_DIR/"

# 对临时目录中的应用也进行签名
echo "对临时目录中的应用进行签名..."
xattr -cr "$TEMP_DIR/${APP_NAME}.app"
codesign --force --deep --sign - "$TEMP_DIR/${APP_NAME}.app"

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

echo "=========================================="
echo "DMG 文件已创建: $DMG_PATH"
echo "=========================================="
echo ""
echo "安装说明："
echo "1. 双击 DMG 文件打开"
echo "2. 将 swxTools.app 拖拽到 Applications 文件夹"
echo "3. 在 Applications 文件夹中找到 swxTools.app"
echo "4. 右键点击 -> 打开 -> 点击'打开'按钮"
echo ""
echo "如果仍然提示'已损坏'，请在终端运行："
echo "sudo xattr -cr /Applications/swxTools.app"
echo "sudo codesign --force --deep --sign - /Applications/swxTools.app"
