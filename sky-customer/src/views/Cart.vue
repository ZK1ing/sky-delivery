<template>
  <div class="page">
    <van-nav-bar title="购物车" left-arrow @click-left="$router.back()" fixed placeholder />
    <van-empty v-if="!items.length" description="购物车是空的" image="search" />
    <div v-else class="cart-list">
      <div v-for="item in items" :key="item.id" class="cart-item">
        <img :src="item.image || 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png'" class="cart-img" />
        <div class="cart-info">
          <span class="cart-name">{{ item.name }}</span>
          <span class="cart-df" v-if="item.dishFlavor">{{ item.dishFlavor }}</span>
          <span class="cart-price">¥{{ (item.amount * item.number).toFixed(2) }}</span>
        </div>
        <div class="cart-ctrl">
          <van-stepper v-model="item.number" :min="1" @change="onCountChange(item)" />
        </div>
      </div>
    </div>
    <div v-if="items.length" class="cart-footer">
      <div class="cart-total">
        <span class="total-label">合计</span>
        <span class="total-value">¥{{ total.toFixed(2) }}</span>
      </div>
      <van-button type="primary" round size="large" @click="goCheckout" style="flex:1;max-width:200px">去结算</van-button>
    </div>
    <van-tabbar v-model="active" :fixed="true">
      <van-tabbar-item icon="home-o" to="/home">首页</van-tabbar-item>
      <van-tabbar-item icon="shopping-cart-o" :badge="items.length || ''" to="/cart">购物车</van-tabbar-item>
      <van-tabbar-item icon="orders-o" to="/orders">订单</van-tabbar-item>
      <van-tabbar-item icon="user-o" to="/user">我的</van-tabbar-item>
    </van-tabbar>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { getCartList, addToCart, subFromCart, cleanCart } from '@/api/index'

const router = useRouter()
const active = ref(1)
const items = ref<any[]>([])

const total = computed(() => items.value.reduce((s, i) => s + i.amount * i.number, 0))

async function load() {
  try { const res: any = await getCartList(); items.value = res.data || [] } catch { /**/ }
}

async function onCountChange(item: any) {
  try {
    if (item.number > 0) {
      await addToCart({ dishId: item.dishId, setmealId: item.setmealId, dishFlavor: item.dishFlavor })
    }
  } catch { load() }
}

function goCheckout() { router.push('/checkout') }

onMounted(() => load())
</script>

<style scoped>
.cart-list { padding: 12px 0; }
.cart-item {
  background: #fff; margin: 0 12px 8px; border-radius: 12px; padding: 12px;
  display: flex; align-items: center; gap: 12px;
}
.cart-img { width: 64px; height: 64px; border-radius: 8px; object-fit: cover; }
.cart-info { flex: 1; display: flex; flex-direction: column; gap: 2px; }
.cart-name { font-size: 15px; font-weight: 600; }
.cart-df { font-size: 12px; color: #999; }
.cart-price { font-size: 16px; font-weight: 700; color: var(--accent); }
.cart-footer {
  position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%);
  width: 100%; max-width: 480px; background: #fff; padding: 12px 16px;
  display: flex; align-items: center; justify-content: space-between;
  border-top: 1px solid #eee; box-shadow: 0 -2px 8px rgba(0,0,0,0.05);
}
.total-label { font-size: 14px; color: #666; }
.total-value { font-size: 20px; font-weight: 700; color: var(--accent); margin-left: 8px; }
</style>
