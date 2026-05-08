<template>
  <div class="login-page">
    <div class="login-bg"></div>
    <div class="login-card">
      <div class="login-header">
        <div class="logo-icon">
          <svg viewBox="0 0 40 40" fill="none"><rect width="40" height="40" rx="12" fill="var(--accent)"/><path d="M12 20h16M20 12v16M14 16h12" stroke="#fff" stroke-width="2.5" stroke-linecap="round"/></svg>
        </div>
        <h1>苍穹外卖</h1>
        <p>管理后台登录</p>
      </div>
      <el-form ref="formRef" :model="form" :rules="rules" size="large">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="请输入账号" prefix-icon="User" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" prefix-icon="Lock" @keyup.enter="handleLogin" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" :loading="loading" class="login-btn">
            {{ loading ? '登录中...' : '登 录' }}
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { login } from '@/api/employee'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const loading = ref(false)
const form = reactive({ username: 'admin', password: '123456' })
const rules = {
  username: [{ required: true, message: '请输入账号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

async function handleLogin() {
  loading.value = true
  try {
    const res: any = await login(form.username, form.password)
    userStore.setAuth(res.data.token, res.data)
    ElMessage.success('登录成功')
    router.push('/')
  } catch { /* api interceptor handles error */ }
  finally { loading.value = false }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #14141f;
  position: relative;
  overflow: hidden;
}
.login-bg {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 60% 50% at 50% 40%, rgba(240,165,0,.12) 0%, transparent 70%),
    radial-gradient(ellipse 80% 60% at 20% 80%, rgba(240,165,0,.06) 0%, transparent 60%),
    radial-gradient(ellipse 50% 50% at 80% 20%, rgba(240,165,0,.08) 0%, transparent 60%);
  animation: bgPulse 8s ease-in-out infinite alternate;
}
@keyframes bgPulse {
  0% { opacity: 0.8; }
  100% { opacity: 1.2; }
}
.login-card {
  position: relative;
  z-index: 1;
  width: 400px;
  max-width: 90vw;
  padding: 48px 40px 40px;
  background: rgba(255,255,255,0.04);
  backdrop-filter: blur(24px);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 20px;
  box-shadow: 0 24px 80px rgba(0,0,0,0.4);
  animation: cardIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}
@keyframes cardIn {
  from { opacity: 0; transform: translateY(20px) scale(0.97); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}
.login-header { text-align: center; margin-bottom: 36px; }
.logo-icon { margin: 0 auto 16px; width: 48px; }
.login-header h1 { color: #faf5ed; font-size: 24px; font-weight: 600; margin-bottom: 6px; letter-spacing: 0.02em; }
.login-header p { color: #8b8ba7; font-size: 14px; }
.login-btn { width: 100%; height: 46px; font-size: 16px; border-radius: 10px; }
:deep(.el-input__wrapper) {
  background: rgba(255,255,255,0.06) !important;
  border: 1px solid rgba(255,255,255,0.1) !important;
  box-shadow: none !important;
  border-radius: 10px !important;
}
:deep(.el-input__wrapper:hover) { border-color: rgba(255,255,255,0.2) !important; }
:deep(.el-input__wrapper.is-focus) { border-color: var(--accent) !important; }
:deep(.el-input__inner) { color: #faf5ed !important; }
:deep(.el-input__inner::placeholder) { color: #5a5a7a !important; }
:deep(.el-form-item__error) { color: #e74c3c; }
</style>
