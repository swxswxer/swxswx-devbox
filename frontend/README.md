# swxTools

一款基于 Vue 3 + Wails 构建的桌面端开发者工具箱，提供常用的加密、格式化、比对等功能。

## 功能特性

### 🔐 加密工具

#### MD5 和 Base64
- **功能**：支持 MD5 哈希、Base64 编码、MD5+Base64 组合加密
- **特性**：
  - MD5 支持大写/小写输出切换
  - 一键复制加密结果
  - 实时预览加密输出
- **依赖**：`blueimp-md5`

#### HMAC-SM3
- **功能**：国密 HMAC-SM3 摘要加密，输出 Base64 编码
- **特性**：
  - 支持自定义密钥
  - 遵循 RFC 2104 标准实现
  - 适用于国密场景的数据完整性验证
- **依赖**：`gm-crypto`

### 📝 格式化工具

#### JSON/XML 格式化
- **功能**：JSON 和 XML 格式化与压缩
- **特性**：
  - 自动识别 JSON/XML 格式
  - 支持格式化（美化）与压缩（最小化）切换
  - 支持 Key 按 ASCII 排序
  - 语法高亮显示
  - 错误提示与格式校验
- **依赖**：`highlight.js`、`fast-xml-parser`

### 🔍 比对工具

#### 文本比对
- **功能**：两段文本的差异对比
- **特性**：
  - 并排显示原始文本与新文本
  - 高亮显示新增、删除、修改的内容
  - 支持行级、字符级差异对比
- **依赖**：`v-code-diff`

### 🖼️ 其他工具

#### 乐刷图片预览
- **功能**：乐刷图片路径在线预览
- **特性**：
  - 自动拼接 CDN 域名前缀
  - 实时预览图片
  - 一键复制完整链接

#### 地址转二维码
- **功能**：URL 地址生成二维码
- **特性**：
  - 支持任意 URL 或文本生成二维码
  - 右键保存二维码图片
  - 自定义二维码尺寸
- **依赖**：`qrcode`

## 技术栈

| 类别 | 技术 |
|------|------|
| 前端框架 | Vue 3 |
| 构建工具 | Vite 3 |
| UI 组件库 | Element Plus |
| 桌面框架 | Wails (Go) |
| 代码高亮 | highlight.js |
| 国密算法 | gm-crypto |

## 依赖说明

### 生产依赖

| 依赖包 | 版本 | 用途 |
|--------|------|------|
| `vue` | ^3.2.37 | 前端框架 |
| `element-plus` | ^2.13.2 | UI 组件库 |
| `blueimp-md5` | ^2.19.0 | MD5 加密算法 |
| `gm-crypto` | ^0.1.12 | 国密算法（SM2/SM3/SM4），用于 HMAC-SM3 |
| `qrcode` | ^1.5.4 | 二维码生成 |
| `v-code-diff` | ^1.13.1 | 文本差异对比 |
| `highlight.js` | ^11.9.0 | 代码语法高亮，用于 JSON/XML 格式化 |
| `fast-xml-parser` | ^4.3.2 | XML 解析与构建 |

### 开发依赖

| 依赖包 | 版本 | 用途 |
|--------|------|------|
| `vite` | ^3.0.7 | 构建工具 |
| `@vitejs/plugin-vue` | ^3.0.3 | Vite Vue 插件 |

## 项目结构

```
frontend/
├── src/
│   ├── components/           # 组件目录
│   │   ├── JsonFormatter.vue # JSON/XML 格式化
│   │   ├── TextDiff.vue      # 文本比对
│   │   ├── Md5AndBase64.vue  # MD5/Base64 加密
│   │   ├── HmacSm3.vue       # HMAC-SM3 加密
│   │   ├── ImagePreview.vue  # 图片预览
│   │   ├── QRCodeGenerator.vue # 二维码生成
│   │   └── HelloWorld.vue    # 示例组件
│   ├── App.vue               # 根组件
│   └── main.js               # 入口文件
├── package.json
└── vite.config.js
```

## 开发指南

### 环境要求

- Node.js >= 16
- Go >= 1.18 (Wails)
- macOS / Windows / Linux

### 本地开发

```bash
# 安装依赖
cd frontend
npm install

# 启动前端开发服务器
npm run dev

# 启动 Wails 开发模式（需要 Go 环境）
wails dev
```

### 构建

```bash
# 构建前端
npm run build

# 构建 Wails 应用
wails build
```

### 构建 DMG 文件 (macOS)

```bash
create-dmg \
  --volname "swxTools" \
  --window-pos 200 120 \
  --window-size 600 300 \
  --icon-size 100 \
  --icon "swxTools.app" 175 120 \
  --hide-extension "swxTools.app" \
  --app-drop-link 425 120 \
  /Users/swxswx/Desktop/code/work-code/swxTools/swxTools.dmg \
  /Users/swxswx/Desktop/code/work-code/swxTools/build/bin/swxTools.app
```

## 截图预览

> 待补充

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
