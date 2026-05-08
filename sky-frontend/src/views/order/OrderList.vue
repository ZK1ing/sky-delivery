<template>
  <div class="page">
    <div class="page-toolbar">
      <div class="toolbar-left">
        <el-input v-model="searchNumber" placeholder="订单号..." style="width:180px" clearable @clear="load" @keyup.enter="load" />
        <el-input v-model="searchPhone" placeholder="手机号..." style="width:160px;margin-left:12px" clearable @clear="load" @keyup.enter="load" />
        <el-select v-model="filterStatus" placeholder="订单状态" style="width:130px;margin-left:12px" clearable @change="load">
          <el-option label="待付款" :value="1" />
          <el-option label="待接单" :value="2" />
          <el-option label="已接单" :value="3" />
          <el-option label="派送中" :value="4" />
          <el-option label="已完成" :value="5" />
          <el-option label="已取消" :value="6" />
        </el-select>
        <el-date-picker v-model="dateRange" type="datetimerange" range-separator="至" start-placeholder="开始时间" end-placeholder="结束时间" format="YYYY-MM-DD HH:mm" value-format="YYYY-MM-DD HH:mm:ss" style="margin-left:12px;width:320px" @change="load" />
      </div>
    </div>

    <div class="stats-row">
      <span class="stat-chip pending">待接单: {{ stats.toBeConfirmed || 0 }}</span>
      <span class="stat-chip confirmed">待派送: {{ stats.confirmed || 0 }}</span>
      <span class="stat-chip delivering">派送中: {{ stats.deliveryInProgress || 0 }}</span>
    </div>

    <el-card shadow="never">
      <el-table :data="tableData" stripe v-loading="loading" empty-text="暂无订单数据">
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="number" label="订单号" min-width="160" />
        <el-table-column prop="phone" label="手机号" width="130" />
        <el-table-column prop="consignee" label="收货人" width="100" />
        <el-table-column prop="amount" label="金额" width="100">
          <template #default="{ row }"><span style="color:var(--accent);font-weight:600">¥{{ row.amount }}</span></template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }"><el-tag :type="statusType(row.status)" size="small">{{ statusText(row.status) }}</el-tag></template>
        </el-table-column>
        <el-table-column prop="orderTime" label="下单时间" width="170" />
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <el-button v-if="row.status === 2" type="primary" link size="small" @click="handleConfirm(row)">接单</el-button>
            <el-button v-if="row.status === 2" type="warning" link size="small" @click="handleReject(row)">拒单</el-button>
            <el-button v-if="row.status === 3" type="primary" link size="small" @click="handleDelivery(row)">派送</el-button>
            <el-button v-if="row.status === 4" type="success" link size="small" @click="handleComplete(row)">完成</el-button>
            <el-button v-if="row.status !== 5 && row.status !== 6" type="danger" link size="small" @click="handleCancel(row)">取消</el-button>
            <el-button type="primary" link size="small" @click="openDetail(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination v-model:current-page="page" v-model:page-size="pageSize" :total="total" layout="total, sizes, prev, pager, next" :page-sizes="[10,20,50]" @change="load" />
    </el-card>

    <el-dialog v-model="detailVisible" title="订单详情" width="640px">
      <template v-if="detail">
        <el-descriptions :column="2" border size="small">
          <el-descriptions-item label="订单号">{{ detail.number }}</el-descriptions-item>
          <el-descriptions-item label="状态">{{ statusText(detail.status) }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ detail.orderTime }}</el-descriptions-item>
          <el-descriptions-item label="金额">¥{{ detail.amount }}</el-descriptions-item>
          <el-descriptions-item label="收货人">{{ detail.consignee }}</el-descriptions-item>
          <el-descriptions-item label="手机号">{{ detail.phone }}</el-descriptions-item>
          <el-descriptions-item label="地址" :span="2">{{ detail.address }}</el-descriptions-item>
          <el-descriptions-item label="备注" :span="2">{{ detail.remark || '-' }}</el-descriptions-item>
        </el-descriptions>
        <div v-if="detail.orderDetailList?.length" style="margin-top:16px">
          <h4 style="margin-bottom:8px">订单明细</h4>
          <el-table :data="detail.orderDetailList" size="small">
            <el-table-column prop="name" label="菜品" />
            <el-table-column prop="number" label="数量" width="80" />
            <el-table-column prop="amount" label="金额" width="100">
              <template #default="{ row }">¥{{ row.amount }}</template>
            </el-table-column>
          </el-table>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { searchOrders, getOrderStatistics, getOrderDetail, confirmOrder, rejectOrder, cancelOrder, deliveryOrder, completeOrder } from '@/api/order'

const tableData = ref([]); const loading = ref(false)
const searchNumber = ref(''); const searchPhone = ref(''); const filterStatus = ref<number | undefined>(undefined)
const dateRange = ref<any[]>([])
const page = ref(1); const pageSize = ref(10); const total = ref(0)
const stats = ref<any>({})
const detailVisible = ref(false); const detail = ref<any>(null)

const statusMap: Record<number, string> = { 1: '待付款', 2: '待接单', 3: '已接单', 4: '派送中', 5: '已完成', 6: '已取消' }
function statusText(s: number) { return statusMap[s] || '未知' }
function statusType(s: number) {
  const map: Record<number, string> = { 1: 'info', 2: 'danger', 3: 'warning', 4: '', 5: 'success', 6: 'info' }
  return map[s] || 'info'
}

async function load() {
  loading.value = true
  try {
    const params: any = { page: page.value, pageSize: pageSize.value, number: searchNumber.value, phone: searchPhone.value, status: filterStatus.value }
    if (dateRange.value?.length === 2) { params.beginTime = dateRange.value[0]; params.endTime = dateRange.value[1] }
    const res: any = await searchOrders(params)
    tableData.value = res.data.records; total.value = res.data.total
  } catch { /**/ } finally { loading.value = false }
}

async function loadStats() { try { const res: any = await getOrderStatistics(); stats.value = res.data || {} } catch { /**/ } }

async function openDetail(row: any) { const res: any = await getOrderDetail(row.id); detail.value = res.data; detailVisible.value = true }

async function handleConfirm(row: any) { await confirmOrder({ id: row.id }); ElMessage.success('已接单'); load(); loadStats() }

async function handleReject(row: any) {
  const { value } = await ElMessageBox.prompt('请输入拒单原因', '拒单')
  if (!value) return
  await rejectOrder({ id: row.id, rejectionReason: value }); ElMessage.success('已拒单'); load(); loadStats()
}

async function handleCancel(row: any) {
  const { value } = await ElMessageBox.prompt('请输入取消原因', '取消订单')
  if (!value) return
  await cancelOrder({ id: row.id, cancelReason: value }); ElMessage.success('已取消'); load(); loadStats()
}

async function handleDelivery(row: any) { await deliveryOrder(row.id); ElMessage.success('已派送'); load(); loadStats() }
async function handleComplete(row: any) { await completeOrder(row.id); ElMessage.success('已完成'); load(); loadStats() }

onMounted(() => { load(); loadStats() })
</script>

<style scoped>
.page { max-width: 1440px; }
.page-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.toolbar-left { display: flex; align-items: center; flex-wrap: wrap; gap: 0; }
.stats-row { display: flex; gap: 16px; margin-bottom: 16px; }
.stat-chip { padding: 6px 16px; border-radius: 20px; font-size: 13px; font-weight: 600; }
.stat-chip.pending { background: #fde8e8; color: #c0392b; }
.stat-chip.confirmed { background: #fef3c7; color: #b45309; }
.stat-chip.delivering { background: #dbeafe; color: #1d4ed8; }
</style>
