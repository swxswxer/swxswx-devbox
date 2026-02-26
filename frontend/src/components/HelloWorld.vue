<script setup>
import {reactive} from 'vue'
import {Greet} from '../../wailsjs/go/main/App'

const data = reactive({
  name: "",
  resultText: "Please enter your name below 👇",
})

function greet() {
  Greet(data.name).then(result => {
    data.resultText = result
  })
}

</script>

<template>
  <div class="hello-world">
    <h2 style="margin-bottom: 30px; color: #303133;">欢迎使用工具箱</h2>
    <el-alert
      :title="data.resultText"
      type="info"
      show-icon
      style="margin-bottom: 30px;"
    />
    <el-form :inline="true" class="demo-form-inline">
      <el-form-item label="姓名">
        <el-input v-model="data.name" placeholder="请输入您的姓名" style="width: 200px;" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="greet">问候</el-button>
      </el-form-item>
    </el-form>
   
  </div>
</template>

<style scoped>
.hello-world {
  max-width: 800px;
  margin: 0 auto;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
