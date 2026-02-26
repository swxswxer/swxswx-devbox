<script setup>
import { ref, computed } from 'vue'
import md5 from 'blueimp-md5'

const inputText = ref('')
const outputText = ref('')
const isUpperCase = ref(false)
const mode = ref('md5')
const showCopySuccess = ref(false)

const modes = [
  { key: 'md5', label: 'MD5' },
  { key: 'base64', label: 'Base64' },
  { key: 'md5+base64', label: 'MD5+Base64' }
]

const isBase64Mode = computed(() => {
  return mode.value === 'base64' || mode.value === 'md5+base64'
})

const processedOutput = computed(() => {
  if (!inputText.value.trim()) return ''
  let result = ''
  if (mode.value === 'md5') {
    result = md5(inputText.value)
    return isUpperCase.value ? result.toUpperCase() : result.toLowerCase()
  } else if (mode.value === 'base64') {
    return btoa(inputText.value)
  } else if (mode.value === 'md5+base64') {
    return btoa(md5(inputText.value))
  }
  return result
})

const outputTitle = computed(() => {
  const currentMode = modes.find(m => m.key === mode.value)
  return currentMode ? `${currentMode.label} 输出` : '输出'
})

function encrypt() {
  if (!inputText.value.trim()) {
    outputText.value = ''
    return
  }
  outputText.value = processedOutput.value
}

function clearInput() {
  inputText.value = ''
  outputText.value = ''
}

function toggleCase() {
  isUpperCase.value = !isUpperCase.value
  if (inputText.value.trim() && mode.value === 'md5') {
    outputText.value = processedOutput.value
  }
}

function setMode(newMode) {
  mode.value = newMode
  if (inputText.value.trim()) {
    outputText.value = processedOutput.value
  }
}

function copyToClipboard() {
  if (outputText.value) {
    navigator.clipboard.writeText(outputText.value).then(() => {
      showCopySuccess.value = true
      setTimeout(() => {
        showCopySuccess.value = false
      }, 2000)
    }).catch(err => {
      console.error('复制失败:', err)
    })
  }
}
</script>

<template>
  <div class="md5-container">
    <div class="main-content">
      <div class="input-section">
        <div class="section-header">
          <h3>输入文本</h3>
        </div>
        <textarea
          v-model="inputText"
          class="text-input"
          placeholder="请输入需要加密的文本..."
        ></textarea>
        <div class="button-group">
          <button
            class="action-button primary-button"
            @click="encrypt"
            :disabled="!inputText.trim()"
          >
            加密
          </button>
          <button
            class="action-button"
            @click="clearInput"
          >
            清空
          </button>
        </div>
      </div>
      
      <div class="output-section">
        <div class="section-header">
          <h3>{{ outputTitle }}</h3>
          <div class="header-buttons">
            <button
              v-for="m in modes"
              :key="m.key"
              class="mode-button"
              @click="setMode(m.key)"
              :class="{ 'active': mode === m.key }"
            >
              {{ m.label }}
            </button>
            <button
              class="mode-button"
              @click="toggleCase"
              :class="{ 'active': isUpperCase }"
              :disabled="isBase64Mode"
            >
              {{ isUpperCase ? '大写' : '小写' }}
            </button>
            <button
              class="copy-button"
              @click="copyToClipboard"
              :disabled="!outputText"
            >
              复制
            </button>
          </div>
        </div>
        <div class="output-content">
          <div v-if="outputText" class="md5-output">
            {{ outputText }}
          </div>
          <div v-else class="empty-output">
            请在左侧输入内容并点击加密
          </div>
        </div>
        <div v-if="showCopySuccess" class="copy-success">
          复制成功！
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.md5-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
  overflow: hidden;
}

.main-content {
  display: flex;
  flex: 1;
  gap: 20px;
  overflow: hidden;
  min-height: 0;
  align-items: center;
}

.input-section,
.output-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  min-height: 0;
  height: 70%;
}

.input-section {
  margin-left: 20px;
}

.output-section {
  margin-right: 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background-color: #f5f5f5;
  border-bottom: 1px solid #e0e0e0;
  height: 48px;
  box-sizing: border-box;
  flex-shrink: 0;
}

.section-header h3 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.header-buttons {
  display: flex;
  gap: 8px;
}

.text-input {
  flex: 1;
  width: 100%;
  padding: 16px;
  border: none;
  resize: none;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 14px;
  line-height: 1.5;
  background-color: #fafafa;
  overflow-y: auto;
  min-height: 0;
}

.text-input:focus {
  outline: none;
  background-color: #fff;
}

.text-input::placeholder {
  color: #999;
}

.button-group {
  display: flex;
  gap: 12px;
  padding: 12px 16px;
  background-color: #f5f5f5;
  border-top: 1px solid #e0e0e0;
  flex-shrink: 0;
}

.action-button {
  flex: 1;
  padding: 8px 20px;
  font-size: 14px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.3s;
}

.action-button:hover:not(:disabled) {
  border-color: #1890ff;
  color: #1890ff;
}

.action-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.primary-button {
  background-color: #1890ff;
  border-color: #1890ff;
  color: #fff;
}

.primary-button:hover:not(:disabled) {
  background-color: #40a9ff;
  border-color: #40a9ff;
  color: #fff;
}

.mode-button {
  padding: 4px 12px;
  font-size: 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.3s;
}

.mode-button:hover {
  border-color: #1890ff;
  color: #1890ff;
}

.mode-button.active {
  background-color: #1890ff;
  border-color: #1890ff;
  color: #fff;
}

.copy-button {
  padding: 4px 12px;
  font-size: 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.3s;
}

.copy-button:hover:not(:disabled) {
  border-color: #1890ff;
  color: #1890ff;
}

.copy-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.output-content {
  flex: 1;
  padding: 16px;
  background-color: #fafafa;
  overflow-y: auto;
  min-height: 0;
}

.md5-output {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 16px;
  line-height: 1.6;
  word-break: break-all;
  color: #333;
  background-color: #fff;
  padding: 12px;
  border-radius: 4px;
  border: 1px solid #e0e0e0;
}

.empty-output {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  height: 100%;
  color: #999;
  font-style: italic;
  padding-top: 16px;
}

.output-section {
  position: relative;
}

.copy-success {
  position: absolute;
  top: 60px;
  right: 16px;
  padding: 6px 12px;
  background-color: #52c41a;
  color: white;
  font-size: 12px;
  border-radius: 4px;
  animation: fadeInOut 2s ease-in-out;
  z-index: 10;
}

@keyframes fadeInOut {
  0% { opacity: 0; transform: translateY(-10px); }
  20% { opacity: 1; transform: translateY(0); }
  80% { opacity: 1; transform: translateY(0); }
  100% { opacity: 0; transform: translateY(-10px); }
}

@media (max-width: 768px) {
  .main-content {
    flex-direction: column;
  }
  
  .input-section,
  .output-section {
    min-height: 200px;
  }
  
  .button-group {
    flex-wrap: wrap;
  }
  
  .action-button {
    flex: 1;
    min-width: 120px;
  }
}
</style>
