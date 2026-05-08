<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getBusinessData, getOrderOverview, getDishOverview, getSetmealOverview } from '@/api/workspace'
import { getOrderStatistics } from '@/api/order'

const businessData = ref<any>({})
const orderOverview = ref<any>({})
const dishOverview = ref<any>({})
const setmealOverview = ref<any>({})
const orderStats = ref<any>({})

async function loadData() {
  try { const res: any = await getBusinessData(); businessData.value = res.data || {} } catch { /**/ }
  try { const res: any = await getOrderOverview(); orderOverview.value = res.data || {} } catch { /**/ }
  try { const res: any = await getDishOverview(); dishOverview.value = res.data || {} } catch { /**/ }
  try { const res: any = await getSetmealOverview(); setmealOverview.value = res.data || {} } catch { /**/ }
  try { const res: any = await getOrderStatistics(); orderStats.value = res.data || {} } catch { /**/ }
}

onMounted(() => { loadData() })

const statCards = [
  { label: '今日营业额', value: () => businessData.value.turnover || 0, unit: '¥', color: '#f0a500', icon: 'Money' },
  { label: '有效订单', value: () => businessData.value.validOrderCount || 0, unit: '', color: '#27ae60', icon: 'Sell' },
  { label: '订单完成率', value: () => businessData.value.orderCompletionRate || 0, unit: '%', color: '#3498db', icon: 'TrendCharts' },
  { label: '平均客单价', value: () => businessData.value.unitPrice || 0, unit: '¥', color: '#9b59b6', icon: 'Coin' },
  { label: '新增用户', value: () => businessData.value.newUsers || 0, unit: '', color: '#e67e22', icon: 'UserFilled' },
]

const orderCards = [
  { label: '待接单', value: () => orderStats.value.toBeConfirmed || 0, color: '#e74c3c' },
  { label: '待派送', value: () => orderStats.value.confirmed || 0, color: '#f39c12' },
  { label: '派送中', value: () => orderStats.value.deliveryInProgress || 0, color: '#3498db' },
  { label: '全部订单', value: () => orderOverview.value.allOrders || 0, color: '#7f8c8d' },
  { label: '已完成', value: () => orderOverview.value.completedOrders || 0, color: '#27ae60' },
  { label: '已取消', value: () => orderOverview.value.cancelledOrders || 0, color: '#95a5a6' },
]
</script>

<template>
  <div class="dashboard">
    <h2 class="page-title">工作台概览</h2>

    <div class="stat-grid">
      <div v-for="card in statCards" :key="card.label" class="stat-card" :style="{ '--card-color': card.color }">
        <div class="stat-icon"><el-icon :size="22"><component :is="card.icon" /></el-icon></div>
        <div class="stat-body">
          <span class="stat-value">{{ card.unit }}{{ card.value() }}</span>
          <span class="stat-label">{{ card.label }}</span>
        </div>
      </div>
    </div>

    <h3 class="section-title">订单概览</h3>
    <div class="order-grid">
      <div v-for="card in orderCards" :key="card.label" class="order-card" :style="{ borderLeftColor: card.color }">
        <span class="order-value">{{ card.value() }}</span>
        <span class="order-label">{{ card.label }}</span>
      </div>
    </div>

    <h3 class="section-title">菜品 & 套餐</h3>
    <div class="menu-grid">
      <div class="menu-card">
        <div class="menu-card-header">菜品</div>
        <div class="menu-stats">
          <div class="menu-stat"><span class="menu-num on">{{ dishOverview.sold || 0 }}</span><span>在售</span></div>
          <div class="menu-stat"><span class="menu-num off">{{ dishOverview.discontinued || 0 }}</span><span>停售</span></div>
        </div>
      </div>
      <div class="menu-card">
        <div class="menu-card-header">套餐</div>
        <div class="menu-stats">
          <div class="menu-stat"><span class="menu-num on">{{ setmealOverview.sold || 0 }}</span><span>在售</span></div>
          <div class="menu-stat"><span class="menu-num off">{{ setmealOverview.discontinued || 0 }}</span><span>停售</span></div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard { max-width: 1280px; }
.page-title { font-size: 22px; margin-bottom: 24px; font-weight: 600; }
.section-title { font-size: 16px; margin: 28px 0 16px; font-weight: 600; color: var(--text-secondary); }
.stat-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; }
.stat-card {
  background: var(--bg-card);
  border-radius: var(--radius);
  padding: 20px;
  border: 1px solid var(--border);
  box-shadow: var(--shadow-sm);
  display: flex;
  gap: 16px;
  align-items: center;
  transition: box-shadow 0.2s, transform 0.2s;
}
.stat-card:hover { box-shadow: var(--shadow); transform: translateY(-1px); }
.stat-icon {
  width: 48px; height: 48px; border-radius: 12px;
  background: color-mix(in srgb, var(--card-color) 12%, transparent);
  color: var(--card-color);
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.stat-value { font-family: var(--font-display); font-size: 24px; font-weight: 700; color: var(--text-primary); }
.stat-label { font-size: 13px; color: var(--text-secondary); display: block; margin-top: 2px; }
.stat-body { display: flex; flex-direction: column; }
.order-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 12px; }
.order-card {
  background: var(--bg-card);
  border-radius: var(--radius);
  padding: 16px 20px;
  border: 1px solid var(--border);
  border-left: 3px solid;
  box-shadow: var(--shadow-sm);
}
.order-value { font-family: var(--font-display); font-size: 28px; font-weight: 700; display: block; }
.order-label { font-size: 13px; color: var(--text-secondary); margin-top: 4px; display: block; }
.menu-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.menu-card {
  background: var(--bg-card);
  border-radius: var(--radius);
  padding: 20px;
  border: 1px solid var(--border);
  box-shadow: var(--shadow-sm);
}
.menu-card-header { font-weight: 600; margin-bottom: 16px; font-size: 15px; }
.menu-stats { display: flex; gap: 32px; }
.menu-stat { display: flex; flex-direction: column; align-items: center; gap: 4px; font-size: 13px; color: var(--text-secondary); }
.menu-num { font-family: var(--font-display); font-size: 32px; font-weight: 700; }
.menu-num.on { color: var(--success); } .menu-num.off { color: #95a5a6; }
</style>
