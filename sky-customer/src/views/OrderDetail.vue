<template>
  <div>
    <van-nav-bar title="订单详情" left-arrow @click-left="$router.back()" fixed placeholder />
    <div v-if="order" class="detail">
      <div class="od-status">{{ statusText(order.status) }}</div>
      <van-cell-group inset>
        <van-cell title="订单号" :value="order.number" />
        <van-cell title="下单时间" :value="order.orderTime" />
        <van-cell title="金额" :value="'¥' + order.amount" />
        <van-cell title="收货人" :value="order.consignee" />
        <van-cell title="手机号" :value="order.phone" />
        <van-cell title="地址" :value="order.address" :label="true" />
      </van-cell-group>
      <h4 class="items-title">订单明细</h4>
      <van-cell-group inset>
        <van-cell v-for="d in order.orderDetailList" :key="d.id" :title="d.name" :value="'x' + d.number + ' ¥' + d.amount" />
      </van-cell-group>
      <div class="od-actions">
        <van-button v-if="order.status === 1 || order.status === 2" type="danger" round @click="handleCancel">取消订单</van-button>
        <van-button v-if="order.status === 5" type="primary" round @click="handleAgain">再来一单</van-button>
        <van-button v-if="order.status === 2 || order.status === 3 || order.status === 4" type="warning" round @click="handleRemind">催单</van-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { showToast } from 'vant'
import { getOrderDetailAPI, cancelUserOrder, orderAgain, remindOrder } from '@/api/index'

const route = useRoute()
const order = ref<any>(null)

const statusMap: Record<number, string> = { 1: '待付款', 2: '待接单', 3: '已接单', 4: '派送中', 5: '已完成', 6: '已取消' }
function statusText(s: number) { return statusMap[s] || '未知' }

async function load() {
  try { const id = Number(route.params.id); const res: any = await getOrderDetailAPI(id); order.value = res.data } catch { /**/ }
}

async function handleCancel() {
  try { await cancelUserOrder(order.value.id); showToast('已取消'); load() } catch { /**/ }
}
async function handleAgain() {
  try { await orderAgain(order.value.id); showToast('已加入购物车') } catch { /**/ }
}
async function handleRemind() {
  try { await remindOrder(order.value.id); showToast('已催单') } catch { /**/ }
}

onMounted(() => load())
</script>

<style scoped>
.detail { padding: 12px 0 0; }
.od-status { text-align: center; font-size: 18px; font-weight: 700; padding: 16px; color: var(--accent); }
.items-title { margin: 16px 12px 8px; font-size: 14px; font-weight: 600; }
.od-actions { display: flex; gap: 12px; justify-content: center; padding: 24px; }
</style>
