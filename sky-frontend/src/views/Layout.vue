<template>
  <div class="layout">
    <aside class="sidebar">
      <router-link to="/dashboard" class="brand">
        <svg viewBox="0 0 36 36" fill="none" class="brand-icon"><rect width="36" height="36" rx="10" fill="var(--accent)"/><path d="M10 18h16M18 10v16M12 14h12" stroke="#fff" stroke-width="2" stroke-linecap="round"/></svg>
        <span class="brand-text">苍穹外卖</span>
      </router-link>
      <nav class="nav">
        <router-link v-for="item in menuItems" :key="item.path" :to="item.path" class="nav-item" :class="{ active: route.path === item.path }">
          <el-icon><component :is="item.icon" /></el-icon>
          <span>{{ item.title }}</span>
          <span v-if="item.badge" class="badge">{{ item.badge }}</span>
        </router-link>
      </nav>
      <div class="sidebar-footer">
        <el-switch v-model="shopOpen" active-text="营业" inactive-text="打烊" inline-prompt @change="toggleShop" />
      </div>
    </aside>
    <main class="main">
      <header class="topbar">
        <div class="topbar-left">
          <h2>{{ currentTitle }}</h2>
        </div>
        <div class="topbar-right">
          <span class="user-name">{{ userStore.user?.name || '管理员' }}</span>
          <el-button text @click="handleLogout">退出登录</el-button>
        </div>
      </header>
      <div class="content">
        <router-view v-slot="{ Component }">
          <transition name="fade-slide" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { getShopStatus, setShopStatus } from '@/api/shop'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const shopOpen = ref(true)

const menuItems = [
  { path: '/dashboard', title: '工作台', icon: 'HomeFilled' },
  { path: '/employee', title: '员工管理', icon: 'User' },
  { path: '/category', title: '分类管理', icon: 'Menu' },
  { path: '/dish', title: '菜品管理', icon: 'Food' },
  { path: '/setmeal', title: '套餐管理', icon: 'Collection' },
  { path: '/order', title: '订单管理', icon: 'Document' },
  { path: '/report', title: '数据统计', icon: 'DataAnalysis' },
]

const currentTitle = computed(() => menuItems.find((m) => m.path === route.path)?.title || '苍穹外卖')

async function fetchShopStatus() {
  try {
    const res: any = await getShopStatus()
    shopOpen.value = res.data === 1
  } catch { /* */ }
}

async function toggleShop(val: number) {
  try {
    await setShopStatus(val ? 1 : 0)
  } catch { /* */ }
}

function handleLogout() {
  userStore.logout()
  router.push('/login')
}

onMounted(() => { fetchShopStatus() })
</script>

<style scoped>
.layout { display: flex; min-height: 100vh; }
.sidebar {
  width: 240px;
  background: var(--sidebar-bg);
  display: flex;
  flex-direction: column;
  padding: 0;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 100;
  border-right: 1px solid rgba(255,255,255,0.04);
}
.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 24px 20px;
  text-decoration: none;
  border-bottom: 1px solid rgba(255,255,255,0.04);
}
.brand-icon { width: 36px; height: 36px; flex-shrink: 0; }
.brand-text { color: #faf5ed; font-family: var(--font-display); font-size: 18px; font-weight: 600; letter-spacing: -0.01em; }
.nav { flex: 1; padding: 12px 8px; display: flex; flex-direction: column; gap: 2px; }
.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  color: var(--sidebar-text);
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s ease;
  position: relative;
}
.nav-item:hover { background: var(--sidebar-hover); color: #c0c0d4; }
.nav-item.active {
  background: var(--sidebar-active);
  color: var(--accent);
  box-shadow: inset 3px 0 0 var(--accent);
}
.badge {
  margin-left: auto;
  background: var(--danger);
  color: #fff;
  font-size: 11px;
  padding: 2px 7px;
  border-radius: 10px;
  font-weight: 600;
}
.sidebar-footer {
  padding: 16px 20px;
  border-top: 1px solid rgba(255,255,255,0.04);
}
.sidebar-footer :deep(.el-switch__label) { color: #8b8ba7 !important; font-size: 13px; }
.main {
  margin-left: 240px;
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.topbar {
  height: 64px;
  background: #fff;
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 28px;
  position: sticky;
  top: 0;
  z-index: 50;
}
.topbar-left h2 { font-size: 18px; font-weight: 600; color: var(--text-primary); }
.topbar-right { display: flex; align-items: center; gap: 16px; }
.user-name { font-size: 14px; color: var(--text-secondary); }
.content { flex: 1; padding: 24px 28px; }
</style>
