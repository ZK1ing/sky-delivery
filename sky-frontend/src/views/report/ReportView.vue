<template>
  <div class="page">
    <div class="page-toolbar">
      <h3 class="page-title">数据统计</h3>
      <div class="toolbar-right">
        <el-date-picker v-model="dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" style="width:260px" />
        <el-button type="primary" @click="loadAll">查询</el-button>
        <el-button @click="handleExport">导出报表</el-button>
      </div>
    </div>

    <div class="charts-grid">
      <el-card shadow="never" class="chart-card">
        <h4>营业额统计</h4>
        <div ref="turnoverChart" class="chart"></div>
      </el-card>
      <el-card shadow="never" class="chart-card">
        <h4>用户统计</h4>
        <div ref="userChart" class="chart"></div>
      </el-card>
      <el-card shadow="never" class="chart-card">
        <h4>订单统计</h4>
        <div ref="orderChart" class="chart"></div>
      </el-card>
      <el-card shadow="never" class="chart-card">
        <h4>销量排名 Top 10</h4>
        <div ref="topChart" class="chart"></div>
      </el-card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import * as echarts from 'echarts'
import { getTurnover, getUserStats, getOrderStats, getTop10, exportReport } from '@/api/report'

const dateRange = ref<string[]>([getDefaultBegin(), getDefaultEnd()])
const turnoverChart = ref(); const userChart = ref(); const orderChart = ref(); const topChart = ref()

function getDefaultBegin() { const d = new Date(); d.setDate(d.getDate() - 7); return d.toISOString().split('T')[0] }
function getDefaultEnd() { return new Date().toISOString().split('T')[0] }

async function loadAll() {
  const [b, e] = dateRange.value
  await Promise.all([
    loadTurnover(b, e), loadUserStats(b, e), loadOrderStats(b, e), loadTop10(b, e)
  ])
}

async function loadTurnover(b: string, e: string) {
  const res: any = await getTurnover(b, e)
  const d = res.data
  const chart = echarts.init(turnoverChart.value)
  chart.setOption({
    tooltip: { trigger: 'axis' },
    xAxis: { type: 'category', data: d.dateList?.split(',') || [] },
    yAxis: { type: 'value' },
    series: [{
      name: '营业额', type: 'line', smooth: true,
      data: (d.turnoverList?.split(',') || []).map(Number),
      lineStyle: { color: '#f0a500', width: 3 },
      itemStyle: { color: '#f0a500' },
      areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(240,165,0,0.3)' }, { offset: 1, color: 'rgba(240,165,0,0)' }]) }
    }]
  })
}

async function loadUserStats(b: string, e: string) {
  const res: any = await getUserStats(b, e)
  const d = res.data
  const dates = d.dateList?.split(',') || []
  const chart = echarts.init(userChart.value)
  chart.setOption({
    tooltip: { trigger: 'axis' },
    legend: { data: ['总用户', '新增用户'], bottom: 0 },
    xAxis: { type: 'category', data: dates },
    yAxis: { type: 'value' },
    series: [
      { name: '总用户', type: 'line', data: (d.totalUserList?.split(',') || []).map(Number), smooth: true, lineStyle: { color: '#3498db' }, itemStyle: { color: '#3498db' } },
      { name: '新增用户', type: 'bar', data: (d.newUserList?.split(',') || []).map(Number), itemStyle: { color: '#9b59b6', borderRadius: [4, 4, 0, 0] } }
    ]
  })
}

async function loadOrderStats(b: string, e: string) {
  const res: any = await getOrderStats(b, e)
  const d = res.data
  const dates = d.dateList?.split(',') || []
  const chart = echarts.init(orderChart.value)
  chart.setOption({
    tooltip: { trigger: 'axis' },
    legend: { data: ['总订单', '有效订单'], bottom: 0 },
    xAxis: { type: 'category', data: dates },
    yAxis: { type: 'value' },
    series: [
      { name: '总订单', type: 'bar', data: (d.orderCountList?.split(',') || []).map(Number), itemStyle: { color: '#f0a500', borderRadius: [4, 4, 0, 0] } },
      { name: '有效订单', type: 'bar', data: (d.validOrderCountList?.split(',') || []).map(Number), itemStyle: { color: '#27ae60', borderRadius: [4, 4, 0, 0] } }
    ]
  })
  document.querySelector('.order-summary')?.remove()
  const summary = document.createElement('div')
  summary.className = 'order-summary'
  summary.innerHTML = `<span>总订单: <b>${d.totalOrderCount||0}</b></span> <span>有效订单: <b>${d.validOrderCount||0}</b></span> <span>完成率: <b>${d.orderCompletionRate||0}%</b></span>`
  summary.style.cssText = 'display:flex;gap:20px;justify-content:center;margin-top:8px;font-size:13px;color:var(--text-secondary)'
  orderChart.value.parentElement?.appendChild(summary)
}

async function loadTop10(b: string, e: string) {
  const res: any = await getTop10(b, e)
  const d = res.data
  const names = d.nameList?.split(',') || []
  const nums = (d.numberList?.split(',') || []).map(Number)
  const chart = echarts.init(topChart.value)
  chart.setOption({
    tooltip: { trigger: 'axis' },
    xAxis: { type: 'value' },
    yAxis: { type: 'category', data: names.reverse(), axisLabel: { fontSize: 11 } },
    series: [{
      type: 'bar', data: nums.reverse(),
      itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
        { offset: 0, color: '#f0a500' }, { offset: 1, color: '#e67e22' }
      ]), borderRadius: [0, 4, 4, 0] }
    }]
  })
}

async function handleExport() {
  const [b, e] = dateRange.value
  try {
    const res: any = await exportReport(b, e)
    const url = URL.createObjectURL(new Blob([res]))
    const a = document.createElement('a')
    a.href = url; a.download = `运营数据报表_${b}_${e}.xlsx`
    a.click(); URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch { /**/ }
}

onMounted(() => { nextTick(() => loadAll()) })
</script>

<style scoped>
.page { max-width: 1600px; }
.page-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.toolbar-right { display: flex; gap: 12px; }
.charts-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.chart-card h4 { font-size: 15px; font-weight: 600; margin-bottom: 12px; }
.chart { width: 100%; height: 280px; }
</style>
