<template>
  <div>
    <van-nav-bar title="确认下单" left-arrow @click-left="$router.back()" fixed placeholder />

    <div class="address-card" @click="$router.push('/address')">
      <div v-if="address" class="addr-detail">
        <div class="addr-line1"><van-icon name="location-o" /><span>{{ address.consignee }} {{ address.phone }}</span></div>
        <div class="addr-line2">{{ address.provinceName }}{{ address.cityName }}{{ address.districtName }} {{ address.detail }}</div>
      </div>
      <div v-else class="addr-empty">请选择收货地址 <van-icon name="arrow" /></div>
    </div>

    <div class="order-items">
      <div v-for="item in items" :key="item.id" class="order-item">
        <img :src="item.image || 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png'" class="oi-img" />
        <div class="oi-info">
          <span class="oi-name">{{ item.name }}</span>
          <span class="oi-df" v-if="item.dishFlavor">{{ item.dishFlavor }}</span>
        </div>
        <span class="oi-price">x{{ item.number }} ¥{{ (item.amount * item.number).toFixed(2) }}</span>
      </div>
    </div>

    <div class="remark-box">
      <van-field v-model="remark" label="备注" placeholder="选填" />
    </div>

    <div class="submit-bar">
      <div class="sb-left">合计 <span class="sb-price">¥{{ total.toFixed(2) }}</span></div>
      <van-button type="primary" round size="normal" @click="handleSubmit" :loading="submitting">提交订单</van-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { getCartList, getDefaultAddress, submitOrder, cleanCart } from '@/api/index'

const router = useRouter()
const items = ref<any[]>([])
const address = ref<any>(null)
const remark = ref('')
const submitting = ref(false)

const total = computed(() => items.value.reduce((s, i) => s + i.amount * i.number, 0))

async function load() {
  try { const res: any = await getCartList(); items.value = res.data || [] } catch { /**/ }
  try { const res: any = await getDefaultAddress(); address.value = res.data } catch { /**/ }
}

async function handleSubmit() {
  if (!address.value) { showToast('请选择收货地址'); return }
  submitting.value = true
  try {
    const amount = total.value
    await submitOrder({
      addressBookId: address.value.id,
      payMethod: 1,
      remark: remark.value,
      amount,
      estimatedDeliveryTime: null,
      deliveryStatus: 1,
      tablewareNumber: 1,
      tablewareStatus: 1,
      packAmount: 2
    })
    await cleanCart()
    showToast('下单成功')
    router.push('/orders')
  } catch { /**/ } finally { submitting.value = false }
}

onMounted(() => load())
</script>

<style scoped>
.address-card { margin: 12px; padding: 16px; background: #fff; border-radius: 12px; }
.addr-line1 { font-size: 15px; font-weight: 600; display: flex; align-items: center; gap: 6px; }
.addr-line2 { font-size: 13px; color: #666; margin-top: 6px; }
.addr-empty { display: flex; justify-content: space-between; align-items: center; color: #999; font-size: 14px; }
.order-items { margin: 0 12px; background: #fff; border-radius: 12px; overflow: hidden; }
.order-item { display: flex; align-items: center; gap: 10px; padding: 12px; border-bottom: 1px solid #f5f5f5; }
.oi-img { width: 48px; height: 48px; border-radius: 8px; object-fit: cover; }
.oi-info { flex: 1; display: flex; flex-direction: column; }
.oi-name { font-size: 14px; font-weight: 600; }
.oi-df { font-size: 12px; color: #999; }
.oi-price { font-size: 13px; color: #666; white-space: nowrap; }
.remark-box { margin: 12px; background: #fff; border-radius: 12px; overflow: hidden; }
.submit-bar {
  position: fixed; bottom: 0; left: 50%; transform: translateX(-50%);
  width: 100%; max-width: 480px; background: #fff; padding: 12px 16px;
  display: flex; align-items: center; justify-content: space-between;
  border-top: 1px solid #eee; box-shadow: 0 -2px 8px rgba(0,0,0,0.05);
}
.sb-left { font-size: 14px; }
.sb-price { font-size: 22px; font-weight: 700; color: var(--accent); margin-left: 6px; }
</style>
