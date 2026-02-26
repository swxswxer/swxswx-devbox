<script setup>
import { ref } from 'vue'
import { SM3 } from 'gm-crypto'

const inputText = ref('')
const secretKey = ref('')
const outputText = ref('')
const showCopySuccess = ref(false)

const BLOCK_SIZE = 64

function stringToBytes(str) {
  return new TextEncoder().encode(str)
}

function bytesToHex(bytes) {
  return Array.from(bytes).map(b => b.toString(16).padStart(2, '0')).join('')
}

function hexToBytes(hex) {
  const bytes = []
  for (let i = 0; i < hex.length; i += 2) {
    bytes.push(parseInt(hex.substr(i, 2), 16))
  }
  return new Uint8Array(bytes)
}

function xorBytes(a, b) {
  const result = new Uint8Array(a.length)
  for (let i = 0; i < a.length; i++) {
    result[i] = a[i] ^ b[i]
  }
  return result
}

function concatBytes(a, b) {
  const result = new Uint8Array(a.length + b.length)
  result.set(a)
  result.set(b, a.length)
  return result
}

function sm3Hash(data) {
  if (typeof data === 'string') {
    const hex = SM3.digest(data, 'utf8', 'hex')
    return hexToBytes(hex)
  } else {
    const hex = SM3.digest(data.buffer, undefined, 'hex')
    return hexToBytes(hex)
  }
}

function hmacSm3(message, key) {
  const keyBytes = stringToBytes(key)
  const messageBytes = stringToBytes(message)
  
  let processedKey = keyBytes
  if (keyBytes.length > BLOCK_SIZE) {
    processedKey = sm3Hash(key)
  }
  
  const paddedKey = new Uint8Array(BLOCK_SIZE)
  paddedKey.set(processedKey)
  
  const ipad = new Uint8Array(BLOCK_SIZE).fill(0x36)
  const opad = new Uint8Array(BLOCK_SIZE).fill(0x5c)
  
  const iKeyPad = xorBytes(paddedKey, ipad)
  const oKeyPad = xorBytes(paddedKey, opad)
  
  const innerData = concatBytes(iKeyPad, messageBytes)
  const innerHash = sm3Hash(innerData)
  
  const outerData = concatBytes(oKeyPad, innerHash)
  const outerHash = sm3Hash(outerData)
  
  return btoa(String.fromCharCode.apply(null, outerHash))
}

function encrypt() {
  if (!inputText.value.trim()) {
    outputText.value = ''
    return
  }
  outputText.value = hmacSm3(inputText.value, secretKey.value)
}

function clearInput() {
  inputText.value = ''
  secretKey.value = ''
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
</script>

<template>
  <div class="hmac-sm3-container">
    <div class="main-content">
      <div class="input-section">
        <div class="section-header">
          <h3>输入</h3>
        </div>
        <div class="input-fields">
          <div class="input-group">
            <label class="input-label">加密内容</label>
            <textarea
              v-model="inputText"
              class="text-input"
              placeholder="请输入需要加密的文本..."
            ></textarea>
          </div>
          <div class="input-group">
            <label class="input-label">加密密钥</label>
            <input
              v-model="secretKey"
              class="key-input"
              placeholder="请输入密钥..."
              type="text"
            />
          </div>
        </div>
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
          <h3>HMAC-SM3 输出 (Base64)</h3>
          <div class="header-buttons">
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
          <div v-if="outputText" class="hmac-output">
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
.hmac-sm3-container {
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
  position: relative;
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

.input-fields {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  min-height: 0;
}

.input-group {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
}

.input-group:first-child {
  flex: 2;
}

.input-group:last-child {
  flex: 0 0 auto;
}

.input-label {
  padding: 8px 16px 4px;
  font-size: 12px;
  color: #666;
  background-color: #fafafa;
}

.text-input {
  flex: 1;
  width: 100%;
  padding: 12px 16px;
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

.key-input {
  width: 100%;
  padding: 12px 16px;
  border: none;
  border-top: 1px solid #e0e0e0;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 14px;
  line-height: 1.5;
  background-color: #fafafa;
  box-sizing: border-box;
}

.key-input:focus {
  outline: none;
  background-color: #fff;
}

.key-input::placeholder {
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

.hmac-output {
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
