<script setup>
import { ref } from 'vue'
import { CodeDiff } from 'v-code-diff'

const oldText = ref('')
const newText = ref('')

function clearOld() {
  oldText.value = ''
}

function clearNew() {
  newText.value = ''
}
</script>

<template>
  <div class="text-diff-container">
    <div class="main-content">
      <div class="input-section">
        <div class="section-header">
          <h3>原始文本</h3>
          <button
            class="clear-btn"
            @click="clearOld"
            :disabled="!oldText"
          >
            清空
          </button>
        </div>
        <textarea
          v-model="oldText"
          class="text-input"
          placeholder="请输入原始文本..."
        ></textarea>
      </div>
      
      <div class="input-section">
        <div class="section-header">
          <h3>新文本</h3>
          <button
            class="clear-btn"
            @click="clearNew"
            :disabled="!newText"
          >
            清空
          </button>
        </div>
        <textarea
          v-model="newText"
          class="text-input"
          placeholder="请输入新文本..."
        ></textarea>
      </div>
    </div>

    <div class="diff-section">
      <CodeDiff
        :old-string="oldText"
        :new-string="newText"
        output-format="side-by-side"
        maxHeight="45vh"
        :context = 5
      />
    </div>

  </div>
</template>

<style scoped>
.text-diff-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
  position: relative;
  overflow: hidden;
}

.main-content {
  display: flex;
  gap: 10px;
  overflow: hidden;
  margin-bottom: 10px;
  flex: 1;
  min-height: 0;
}

.input-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  min-height: 0;
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

.clear-btn {
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

.clear-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
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

.diff-section {
  flex: 1;
  overflow: hidden;
  min-height: 0;
}

.diff-output :deep(.d2h-wrapper) {
  margin: 0;
}

.diff-output :deep(.d2h-code-side-linenumber) {
  user-select: none;
}

.diff-output :deep(.d2h-code-line-ctn) {
  white-space: pre-wrap;
  word-wrap: break-word;
}

@media (max-width: 768px) {
  .main-content {
    flex-direction: column;
  }
  
  .input-section {
    min-height: 200px;
  }
  
  .button-section {
    flex-wrap: wrap;
  }
  
  .action-button {
    flex: 1;
    min-width: 120px;
  }
}
</style>
