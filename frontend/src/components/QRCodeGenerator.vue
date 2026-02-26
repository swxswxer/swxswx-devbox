<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import QRCode from 'qrcode'
import { ElMessage } from 'element-plus'

const inputUrl = ref('')
const qrCodeDataUrl = ref('')
const isGenerating = ref(false)
const contextMenuVisible = ref(false)
const contextMenuPosition = ref({ x: 0, y: 0 })

async function generateQRCode() {
  if (!inputUrl.value.trim()) return
  
  isGenerating.value = true
  try {
    qrCodeDataUrl.value = await QRCode.toDataURL(inputUrl.value, {
      width: 300,
      margin: 2,
      color: {
        dark: '#000000',
        light: '#ffffff'
      }
    })
  } catch (error) {
    console.error('生成二维码失败:', error)
    qrCodeDataUrl.value = ''
  } finally {
    isGenerating.value = false
  }
}

function clearInput() {
  inputUrl.value = ''
  qrCodeDataUrl.value = ''
}

function handleContextMenu(event) {
  event.preventDefault()
  if (!qrCodeDataUrl.value) return
  
  contextMenuPosition.value = {
    x: event.clientX,
    y: event.clientY
  }
  contextMenuVisible.value = true
}

function hideContextMenu() {
  contextMenuVisible.value = false
}

function dataURLtoBlob(dataURL) {
  const arr = dataURL.split(',')
  const mime = arr[0].match(/:(.*?);/)[1]
  const bstr = atob(arr[1])
  let n = bstr.length
  const u8arr = new Uint8Array(n)
  while (n--) {
    u8arr[n] = bstr.charCodeAt(n)
  }
  return new Blob([u8arr], { type: mime })
}

async function copyImageToClipboard() {
  if (!qrCodeDataUrl.value) return
  
  try {
    const blob = dataURLtoBlob(qrCodeDataUrl.value)
    await navigator.clipboard.write([
      new ClipboardItem({ [blob.type]: blob })
    ])
    ElMessage.success('图片已复制到剪贴板')
  } catch (error) {
    console.error('复制图片失败:', error)
    ElMessage.error('复制图片失败，请重试')
  } finally {
    hideContextMenu()
  }
}

async function copyImageUrl() {
  if (!qrCodeDataUrl.value) return
  
  try {
    await navigator.clipboard.writeText(qrCodeDataUrl.value)
    ElMessage.success('链接已复制到剪贴板')
  } catch (error) {
    console.error('复制链接失败:', error)
    ElMessage.error('复制链接失败，请重试')
  } finally {
    hideContextMenu()
  }
}

onMounted(() => {
  document.addEventListener('click', hideContextMenu)
})

onUnmounted(() => {
  document.removeEventListener('click', hideContextMenu)
})
</script>

<template>
  <div class="qrcode-container">
    <div class="input-section">
      <div class="section-header">
        <h3>输入地址</h3>
        <div class="header-actions">
          <button
            class="clear-btn"
            @click="clearInput"
            :disabled="!inputUrl"
          >
            清空
          </button>
        </div>
      </div>
      <div class="input-wrapper">
        <input
          v-model="inputUrl"
          class="url-input"
          placeholder="请输入需要转换的地址，如：https://example.com"
        />
        <button
          class="generate-btn"
          @click="generateQRCode"
          :disabled="!inputUrl || isGenerating"
        >
          {{ isGenerating ? '生成中...' : '生成二维码' }}
        </button>
      </div>
    </div>

    <div class="preview-section">
      <div class="section-header">
        <h3>二维码预览</h3>
      </div>
      <div class="preview-content">
        <div v-if="isGenerating" class="loading-placeholder">
          <span class="loading-text">生成中...</span>
        </div>
        <div v-else-if="qrCodeDataUrl" class="qrcode-wrapper">
          <img
            :src="qrCodeDataUrl"
            alt="二维码"
            class="qrcode-image"
            @contextmenu="handleContextMenu"
          />
        </div>
        <div v-else class="empty-placeholder">
          <span class="placeholder-icon">📱</span>
          <span class="placeholder-text">请输入地址并点击生成按钮</span>
        </div>
        
        <div
          v-if="contextMenuVisible"
          class="context-menu"
          :style="{ left: contextMenuPosition.x + 'px', top: contextMenuPosition.y + 'px' }"
          @click.stop
        >
          <div class="menu-item" @click="copyImageToClipboard">
            <span class="menu-icon">📋</span>
            <span>复制图片</span>
          </div>
          <div class="menu-item" @click="copyImageUrl">
            <span class="menu-icon">🔗</span>
            <span>复制图片链接</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.qrcode-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
  position: relative;
  overflow: hidden;
}

.input-section {
  display: flex;
  flex-direction: column;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 10px;
  flex-shrink: 0;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 16px;
  background-color: #f5f5f5;
  border-bottom: 1px solid #e0e0e0;
  height: 40px;
  box-sizing: border-box;
  flex-shrink: 0;
}

.section-header h3 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.header-actions {
  display: flex;
  gap: 8px;
}

.clear-btn,
.download-btn {
  padding: 4px 12px;
  font-size: 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.3s;
}

.clear-btn:hover:not(:disabled) {
  border-color: #ff4d4f;
  color: #ff4d4f;
}

.download-btn:hover:not(:disabled) {
  border-color: #52c41a;
  color: #52c41a;
}

.clear-btn:disabled,
.download-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.input-wrapper {
  display: flex;
  align-items: stretch;
  padding: 12px 16px;
  background-color: #fafafa;
  gap: 12px;
}

.url-input {
  flex: 1;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background: #fff;
  font-size: 14px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  outline: none;
  min-width: 0;
  padding: 0 12px;
  height: 32px;
}

.url-input:focus {
  border-color: #52c41a;
}

.url-input::placeholder {
  color: #999;
}

.generate-btn {
  padding: 0 16px;
  font-size: 14px;
  border: none;
  border-radius: 4px;
  background-color: #52c41a;
  color: #fff;
  cursor: pointer;
  transition: all 0.3s;
  height: 32px;
  white-space: nowrap;
}

.generate-btn:hover:not(:disabled) {
  background-color: #73d13d;
}

.generate-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.preview-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  min-height: 0;
}

.preview-content {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #fafafa;
  overflow: hidden;
  padding: 16px;
  min-height: 0;
}

.empty-placeholder,
.loading-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #999;
}

.placeholder-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.placeholder-text,
.loading-text {
  font-size: 14px;
}

.qrcode-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.qrcode-image {
  max-width: 300px;
  max-height: 300px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  cursor: pointer;
}

.context-menu {
  position: fixed;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  padding: 8px 0;
  min-width: 160px;
  z-index: 1000;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 10px 16px;
  cursor: pointer;
  transition: background-color 0.2s;
  font-size: 14px;
  color: #333;
}

.menu-item:hover {
  background-color: #f5f5f5;
}

.menu-icon {
  margin-right: 10px;
  font-size: 14px;
}

@media (max-width: 768px) {
  .url-input {
    font-size: 12px;
  }
  
  .placeholder-icon {
    font-size: 36px;
  }
  
  .qrcode-image {
    max-width: 200px;
    max-height: 200px;
  }
}
</style>
