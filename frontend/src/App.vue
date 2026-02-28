<script setup>
import { ref } from 'vue'
import HelloWorld from './components/HelloWorld.vue'
import JsonFormatter from './components/JsonFormatter.vue'
import TextDiff from "./components/TextDiff.vue";
import Md5AndBase64 from "./components/Md5AndBase64.vue";
import ImagePreview from "./components/ImagePreview.vue";
import QRCodeGenerator from "./components/QRCodeGenerator.vue";
import HmacSm3 from "./components/HmacSm3.vue";
import UrlEncode from "./components/UrlEncode.vue";

// 导航项数据
const navItems = [
  // { id: 'hello', name: 'HelloWorld', component: HelloWorld },
  { id: 'json-formatter', name: 'JSON格式化', component: JsonFormatter },
  { id: 'text-diff', name: '文本比对', component: TextDiff },
  { id: 'md5AndBase64', name: 'MD5和Base64', component: Md5AndBase64 },
  { id: 'HmacSm3', name: 'HmacSm3加密', component: HmacSm3 },
  { id: 'url-encode', name: 'URLENCODE', component: UrlEncode },
  { id: 'image-preview', name: '乐刷图片预览', component: ImagePreview },
  { id: 'QRCode-Generator', name: '地址转二维码', component: QRCodeGenerator },
]

// 当前选中的导航项
const currentNav = ref('json-formatter')

// 切换导航项
function switchNav(id) {
  currentNav.value = id
}
</script>

<template>
  <div class="app-container">
    <!-- 左侧导航栏 -->
    <aside class="sidebar" style="background-color: #001529; overflow: hidden;">
      <div class="sidebar-header" style="padding: 20px; text-align: center; border-bottom: 1px solid #1f2d3d;">
        <h1 style="color: white; font-size: 1.2rem; font-weight: bold; margin: 0;">工具箱</h1>
      </div>
      <el-menu
        :default-active="currentNav"
        class="nav-menu"
        background-color="#001529"
        text-color="#fff"
        active-text-color="#409EFF"
        router="false"
        @select="switchNav"
        style="border-right: none; height: calc(100% - 60px);"
      >
        <el-menu-item 
          v-for="item in navItems" 
          :key="item.id"
          :index="item.id"
        >
          <template #title>
            <span>{{ item.name }}</span>
          </template>
        </el-menu-item>
      </el-menu>
    </aside>
    
    <!-- 右侧工具区 -->
    <main class="tool-area" style="background-color: #f5f7fa; padding: 20px;">
      <div class="tool-card" shadow="hover">
        <keep-alive>
          <component :is="navItems.find(item => item.id === currentNav)?.component || HelloWorld" />
        </keep-alive>
      </div>
    </main>
  </div>
</template>

<style>
/* 全局样式重置 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Nunito', sans-serif;
  background-color: #f5f5f5;
  color: #333;
  min-height: 100vh;
  overflow-x: hidden;
}

/* 应用容器 */
.app-container {
  display: flex;
  min-height: 100vh;
  width: 100%;
}

/* 左侧导航栏 */
.sidebar {
  width: 150px;
  min-width: 150px;
  height: 100vh;
  position: sticky;
  top: 0;
}

/* 右侧工具区 */
.tool-area {
  flex: 1;
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.tool-card {
  background-color: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 0;
  margin: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .tool-card {
    padding: 20px;
  }
}

@media (max-width: 768px) {
  .sidebar {
    width: 120px;
    min-width: 120px;
  }
  
  .sidebar-header h1 {
    font-size: 1rem !important;
  }
  
  .el-menu-item {
    font-size: 0.8rem !important;
    padding: 0 10px !important;
  }
  
  .tool-area {
    padding: 10px;
  }
  
  .tool-card {
    padding: 15px;
    min-height: calc(100vh - 20px);
  }
}

@media (max-width: 480px) {
  .sidebar {
    width: 100px;
    min-width: 100px;
  }
  
  .el-menu-item {
    font-size: 0.7rem !important;
    padding: 0 8px !important;
  }
}
</style>
