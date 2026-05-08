<template>
  <div class="page">
    <van-nav-bar title="我的订单" fixed placeholder />
    <van-tabs v-model:active="tab" @change="onTabChange" color="#f0a500" sticky>
      <van-tab :name="-1" title="全部" />
      <van-tab :name="2" title="待接单" />
      <van-tab :name="3" title="已接单" />
      <van-tab :name="4" title="派送中" />
      <van-tab :name="5" title="已完成" />
      <van-tab :name="6" title="已取消" />
    </van-tabs>
    <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
      <van-empty v-if="!list.length && !loading" description="暂无订单" />
      <div v-else class="order-list">
        <div v-for="order in list" :key="order.id" class="order-card" @click="$router.push(`/order-detail/${order.id}`)">
          <div class="oc-header">
            <span class="oc-number">#{{ order.number?.slice(-8) }}</span>
            <van-tag :type="statusType(order.status)" size="small">{{ statusText(order.status) }}</van-tag>
          </div>
          <div class="oc-items">{{ formatItems(order.orderDetailList || []) }}</div>
          <div class="oc-footer">
            <span class="oc-time">{{ order.orderTime }}</span>
            <span class="oc-amount">¥{{ order.amount }}</span>
          </div>
        </div>
      </div>
    </van-pull-refresh>
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
import { getOrders } from '@/api/index'

const active = ref(2)
const tab = ref(-1)
const list = ref<any[]>([])
const refreshing = ref(false)
const loading = ref(false)

const statusMap: Record<number, string> = { 1: '待付款', 2: '待接单', 3: '已接单', 4: '派送中', 5: '已完成', 6: '已取消' }
function statusText(s: number) { return statusMap[s] || '未知' }
function statusType(s: number) {
  const m: Record<number, string> = { 1: 'default', 2: 'danger', 3: 'warning', 4: 'primary', 5: 'success', 6: 'default' }
  return m[s] || 'default'
}
function formatItems(items: any[]) {
  return items.map(i => `${i.name}x${i.number}`).join(', ') || '无菜品'
}

async function load() {
  loading.value = true
  try {
    const res: any = await getOrders({ page: 1, pageSize: 50, status: tab.value === -1 ? undefined : tab.value })
    list.value = res.data?.records || []
  } catch { /**/ } finally { loading.value = false }
}

async function onRefresh() { await load(); refreshing.value = false }
function onTabChange() { load() }

onMounted(() => load())
</script>

<style scoped>
.order-list { padding: 12px 0; }
.order-card { margin: 0 12px 10px; background: #fff; border-radius: 12px; padding: 14px; }
.oc-header { display: flex; justify-content: space-between; align-items: center; }
.oc-number { font-size: 14px; font-weight: 600; color: #666; }
.oc-items { font-size: 13px; color: #333; margin: 10px 0; line-height: 1.6; }
.oc-footer { display: flex; justify-content: space-between; align-items: center; }
.oc-time { font-size: 12px; color: #999; }
.oc-amount { font-size: 16px; font-weight: 700; color: var(--accent); }
</style>
