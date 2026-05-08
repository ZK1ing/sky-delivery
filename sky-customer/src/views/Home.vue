<template>
  <div class="home">
    <div class="header">
      <h1>苍穹外卖</h1>
      <div class="header-tag" :class="{ open: shopOpen }">{{ shopOpen ? '营业中' : '休息中' }}</div>
    </div>

    <van-tabs v-model:active="activeType" @change="onTabChange" color="#f0a500" sticky>
      <van-tab title="菜品"><van-empty v-if="!categories.length && !loading" description="暂无分类" />
        <div v-for="cat in categories" :key="cat.id" class="section">
          <h3 class="section-title">{{ cat.name }}</h3>
          <div class="dish-list">
            <div v-for="dish in dishMap[cat.id]" :key="dish.id" class="dish-card" @click="showDishAction(dish)">
              <img :src="dish.image || 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png'" class="dish-img" />
              <div class="dish-info">
                <span class="dish-name">{{ dish.name }}</span>
                <span class="dish-desc">{{ dish.description }}</span>
                <span class="dish-price">¥{{ dish.price }}</span>
              </div>
              <van-icon name="add-circle" size="24px" color="#f0a500" @click.stop="addDishToCart(dish)" />
            </div>
          </div>
        </div>
      </van-tab>
      <van-tab title="套餐"><van-empty v-if="!setMealCats.length && !loading" description="暂无套餐" />
        <div v-for="cat in setMealCats" :key="cat.id" class="section">
          <h3 class="section-title">{{ cat.name }}</h3>
          <div class="setmeal-grid">
            <div v-for="sm in setmealMap[cat.id]" :key="sm.id" class="setmeal-card" @click="showSetmealAction(sm)">
              <img :src="sm.image || 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png'" class="setmeal-img" />
              <div class="setmeal-info">
                <span class="setmeal-name">{{ sm.name }}</span>
                <span class="setmeal-price">¥{{ sm.price }}</span>
              </div>
            </div>
          </div>
        </div>
      </van-tab>
    </van-tabs>

    <van-action-sheet v-model:show="actionShow" :title="actionTitle" :actions="flavorActions" @select="onFlavorSelect" cancel-text="关闭" />

    <div class="bottom-bar">
      <van-icon name="shopping-cart-o" size="28" :badge="cartCount || ''" @click="$router.push('/cart')" />
    </div>

    <van-tabbar v-model="active" :fixed="true" :border="true" :safe-area-inset-bottom="true">
      <van-tabbar-item icon="home-o" to="/home">首页</van-tabbar-item>
      <van-tabbar-item icon="shopping-cart-o" :badge="cartCount || ''" to="/cart">购物车</van-tabbar-item>
      <van-tabbar-item icon="orders-o" to="/orders">订单</van-tabbar-item>
      <van-tabbar-item icon="user-o" to="/user">我的</van-tabbar-item>
    </van-tabbar>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { showToast } from 'vant'
import { getCategories, getDishesByCategory, getSetmealsByCategory, addToCart, getCartList, getShopStatus } from '@/api/index'

const active = ref(0)
const activeType = ref(0)
const shopOpen = ref(true)
const categories = ref<any[]>([])
const setMealCats = ref<any[]>([])
const dishMap = reactive<Record<number, any[]>>({})
const setmealMap = reactive<Record<number, any[]>>({})
const loading = ref(false)
const cartCount = ref(0)

const actionShow = ref(false)
const actionTitle = ref('选择口味')
const flavorActions = ref<any[]>([])
const actionTarget = ref<any>(null)

async function loadCategories() {
  try { const res: any = await getCategories(1); categories.value = res.data || [] } catch { /**/ }
}

async function loadSetmealCats() {
  try { const res: any = await getCategories(2); setMealCats.value = res.data || [] } catch { /**/ }
}

async function loadDishes() {
  for (const cat of categories.value) {
    try { const res: any = await getDishesByCategory(cat.id); dishMap[cat.id] = res.data || [] } catch { /**/ }
  }
}

async function loadSetmeals() {
  for (const cat of setMealCats.value) {
    try { const res: any = await getSetmealsByCategory(cat.id); setmealMap[cat.id] = res.data || [] } catch { /**/ }
  }
}

async function refreshCart() {
  try { const res: any = await getCartList(); cartCount.value = (res.data || []).reduce((s: number, c: any) => s + c.number, 0) } catch { /**/ }
}

async function onTabChange(idx: any) {
  // idx is actually a string name in Vant 4, loaded when tabs change
}

function showDishAction(dish: any) {
  actionTarget.value = { type: 'dish', id: dish.id }
  flavorActions.value = [{ name: '直接加入购物车', value: '' }]
  actionShow.value = true
}

function showSetmealAction(sm: any) {
  actionTarget.value = { type: 'setmeal', id: sm.id }
  flavorActions.value = [{ name: '加入购物车', value: '' }]
  actionShow.value = true
}

async function onFlavorSelect() {
  if (!actionTarget.value) return
  const t = actionTarget.value
  try {
    if (t.type === 'dish') await addToCart({ dishId: t.id })
    else await addToCart({ setmealId: t.id })
    showToast('已加入购物车')
    refreshCart()
  } catch { /**/ }
  actionShow.value = false
}

async function addDishToCart(dish: any) {
  try { await addToCart({ dishId: dish.id }); showToast('已加入购物车'); refreshCart() } catch { /**/ }
}

async function checkShop() {
  try { const res: any = await getShopStatus(); shopOpen.value = res.data === 1 } catch { /**/ }
}

onMounted(async () => {
  loading.value = true
  await Promise.all([loadCategories(), loadSetmealCats(), checkShop(), refreshCart()])
  await loadDishes()
  await loadSetmeals()
  loading.value = false
})
</script>

<style scoped>
.home { padding-bottom: 60px; }
.header {
  background: linear-gradient(135deg, #f0a500, #e67e22);
  color: #fff;
  padding: 20px 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header h1 { font-size: 22px; font-weight: 700; }
.header-tag { font-size: 12px; padding: 4px 12px; border-radius: 20px; background: rgba(255,255,255,0.3); }
.header-tag.open { background: rgba(39,174,96,0.3); }
.section { padding: 0 16px; }
.section-title { font-size: 16px; font-weight: 600; margin: 16px 0 10px; padding-left: 8px; border-left: 3px solid var(--accent); }
.dish-card {
  display: flex; align-items: center; gap: 12px;
  background: #fff; border-radius: 12px; padding: 12px; margin-bottom: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}
.dish-img { width: 72px; height: 72px; border-radius: 8px; object-fit: cover; }
.dish-info { flex: 1; display: flex; flex-direction: column; gap: 2px; }
.dish-name { font-size: 15px; font-weight: 600; }
.dish-desc { font-size: 12px; color: #999; }
.dish-price { font-size: 16px; font-weight: 700; color: var(--accent); }
.setmeal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.setmeal-card {
  background: #fff; border-radius: 12px; overflow: hidden;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}
.setmeal-img { width: 100%; height: 120px; object-fit: cover; }
.setmeal-info { padding: 10px; }
.setmeal-name { font-size: 14px; font-weight: 600; display: block; }
.setmeal-price { font-size: 15px; font-weight: 700; color: var(--accent); margin-top: 4px; display: block; }
.bottom-bar { display: none; }
</style>
