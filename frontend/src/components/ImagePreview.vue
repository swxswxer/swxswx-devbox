<script setup>
import { ref, computed } from 'vue'

const imagePath = ref('')

const imageUrl = computed(() => {
  if (!imagePath.value.trim()) return ''
  const path = imagePath.value.startsWith('/') ? imagePath.value.slice(1) : imagePath.value
  return `https://pic.leshuazf.com/${path}`
})

function clearInput() {
  imagePath.value = ''
}

function copyUrl() {
  if (imageUrl.value) {
    navigator.clipboard.writeText(imageUrl.value)
  }
}
</script>

<template>
  <div class="image-preview-container">
    <div class="input-section">
      <div class="section-header">
        <h3>图片路径</h3>
        <div class="header-actions">
          <button
            class="copy-btn"
            @click="copyUrl"
            :disabled="!imagePath"
          >
            复制链接
          </button>
          <button
            class="clear-btn"
            @click="clearInput"
            :disabled="!imagePath"
          >
            清空
          </button>
        </div>
      </div>
      <div class="input-wrapper">
        <span class="url-prefix">https://pic.leshuazf.com/</span>
        <input
          v-model="imagePath"
          class="path-input"
          placeholder="请输入图片路径，如：picture3pro/M00/7E/7C/xxx.jpg"
        />
      </div>
    </div>

    <div class="preview-section">
      <div class="section-header">
        <h3>图片预览</h3>
      </div>
      <div class="preview-content">
        <div v-if="!imagePath" class="empty-placeholder">
          <span class="placeholder-icon">🖼️</span>
          <span class="placeholder-text">请输入图片路径进行预览</span>
        </div>
        <div v-else class="image-wrapper">
          <el-image
            :src="imageUrl"
            alt="预览图片"
            class="preview-image"
            fit="contain"
            :preview-src-list="[imageUrl]"
            :initial-index="0"
            preview-teleported
          >
            <template #error>
              <div class="image-error">
                <span>图片加载失败</span>
              </div>
            </template>
          </el-image>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.image-preview-container {
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
.copy-btn {
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

.copy-btn:hover:not(:disabled) {
  border-color: #1890ff;
  color: #1890ff;
}

.clear-btn:disabled,
.copy-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.input-wrapper {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background-color: #fafafa;
}

.url-prefix {
  color: #666;
  font-size: 14px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  white-space: nowrap;
  margin-right: 8px;
  flex-shrink: 0;
}

.path-input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 14px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  outline: none;
  min-width: 0;
}

.path-input::placeholder {
  color: #999;
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

.empty-placeholder {
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

.placeholder-text {
  font-size: 14px;
}

.image-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.preview-image {
  max-width: 100%;
  max-height: 100%;
  width: 100%;
  height: 100%;
}

.preview-image :deep(.el-image__inner) {
  object-fit: contain;
}

.image-error {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  color: #999;
  font-size: 14px;
}

@media (max-width: 768px) {
  .url-prefix {
    font-size: 12px;
  }
  
  .path-input {
    font-size: 12px;
  }
  
  .placeholder-icon {
    font-size: 36px;
  }
}
</style>
