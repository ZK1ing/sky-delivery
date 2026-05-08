<template>
  <div class="page">
    <div class="user-header">
      <van-image round width="64" height="64" src="https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png" />
      <h3 v-if="user">{{ user.name || '用户' }}</h3>
      <h3 v-else>未登录</h3>
      <van-button v-if="!user" type="primary" size="small" round @click="handleLogin">模拟登录</van-button>
    </div>
    <van-cell-group inset style="margin-top:16px">
      <van-cell title="收货地址" is-link icon="location-o" @click="$router.push('/address')" />
      <van-cell title="我的订单" is-link icon="orders-o" @click="$router.push('/orders')" />
      <van-cell title="联系客服" is-link icon="service-o" value="400-888-8888" />
    </van-cell-group>
    <van-tabbar v-model="active" :fixed="true">
      <van-tabbar-item icon="home-o" to="/home">首页</van-tabbar-item>
      <van-tabbar-item icon="shopping-cart-o" to="/cart">购物车</van-tabbar-item>
      <van-tabbar-item icon="orders-o" to="/orders">订单</van-tabbar-item>
      <van-tabbar-item icon="user-o" to="/user">我的</van-tabbar-item>
    </van-tabbar>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { showToast } from 'vant'
import { loginByWechat } from '@/api/index'

const active = ref(3)
const user = ref<any>(null)

function handleLogin() {
  showToast('模拟微信登录中...')
  loginByWechat('mock-code-user1').then((res: any) => {
    user.value = res.data
    localStorage.setItem('userToken', res.data.token)
    localStorage.setItem('user', JSON.stringify(res.data))
    showToast('登录成功')
  }).catch(() => { showToast('请确保后端服务已启动') })
}

onMounted(() => {
  const u = localStorage.getItem('user')
  if (u) user.value = JSON.parse(u)
})
</script>

<style scoped>
.user-header { display: flex; flex-direction: column; align-items: center; gap: 12px; padding: 32px 16px 24px; }
.user-header h3 { font-size: 18px; font-weight: 600; }
</style>
