<script setup>
import { ref } from 'vue'

const inputText = ref('')
const outputText = ref('')
const showCopySuccess = ref(false)

function encode() {
  if (!inputText.value.trim()) {
    outputText.value = ''
    return
  }
  try {
    outputText.value = encodeURIComponent(inputText.value)
  } catch (e) {
    outputText.value = '编码失败: ' + e.message
  }
}

function decode() {
  if (!inputText.value.trim()) {
    outputText.value = ''
    return
  }
  try {
    outputText.value = decodeURIComponent(inputText.value)
  } catch (e) {
    outputText.value = '解码失败: 无效的 URL 编码字符串'
  }
}

function clearInput() {
  inputText.value = ''
  outputText.value = ''
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

function exchange() {
  inputText.value = outputText.value
  outputText.value = ''
}
</script>

<template>
  <div class="urlencode-container">
    <div class="main-content">
      <div class="input-section">
        <div class="section-header">
          <h3>输入文本</h3>
        </div>
        <textarea
          v-model="inputText"
          class="text-input"
          placeholder="请输入需要编码或解码的文本..."
        ></textarea>
        <div class="button-group">
          <button
            class="action-button primary-button"
            @click="encode"
            :disabled="!inputText.trim()"
          >
            编码
          </button>
          <button
            class="action-button primary-button"
            @click="decode"
            :disabled="!inputText.trim()"
          >
            解码
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
          <h3>输出结果</h3>
          <div class="header-buttons">
            <button
              class="copy-button"
              @click="exchange"
              :disabled="!outputText"
            >
              交换
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
          <div v-if="outputText" class="urlencode-output">
            {{ outputText }}
          </div>
          <div v-else class="empty-output">
            请在左侧输入内容并点击编码或解码
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
.urlencode-container {
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

.urlencode-output {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  word-break: break-all;
  color: #333;
  background-color: #fff;
  padding: 12px;
  border-radius: 4px;
  border: 1px solid #e0e0e0;
  white-space: pre-wrap;
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
    min-width: 100px;
  }
}
</style>
