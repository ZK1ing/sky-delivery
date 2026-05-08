<template>
  <div>
    <van-nav-bar title="收货地址" left-arrow @click-left="$router.back()" fixed placeholder />
    <div class="addr-list">
      <div v-for="addr in list" :key="addr.id" class="addr-card" :class="{ default: addr.isDefault }" @click="selectAddr(addr)">
        <div class="addr-top">
          <span class="addr-name">{{ addr.consignee }}</span>
          <span class="addr-phone">{{ addr.phone }}</span>
          <van-tag v-if="addr.isDefault" type="warning" size="mini">默认</van-tag>
        </div>
        <div class="addr-detail">{{ addr.provinceName }}{{ addr.cityName }}{{ addr.districtName }} {{ addr.detail }}</div>
        <div class="addr-actions">
          <van-button size="small" plain type="primary" @click.stop="setDefault(addr)">设为默认</van-button>
          <van-button size="small" plain type="danger" @click.stop="delAddr(addr.id)">删除</van-button>
        </div>
      </div>
      <van-empty v-if="!list.length" description="暂无地址" />
    </div>
    <div class="add-btn"><van-button type="primary" block round @click="showForm = true; editing = null">添加新地址</van-button></div>

    <van-popup v-model:show="showForm" position="bottom" round :style="{ padding: '20px' }">
      <van-form @submit="saveAddr">
        <van-cell-group inset>
          <van-field v-model="form.consignee" label="收货人" placeholder="请输入姓名" />
          <van-field v-model="form.phone" label="手机号" placeholder="请输入手机号" />
          <van-field v-model="form.sex" label="性别" placeholder="0女 1男" />
          <van-field v-model="form.provinceName" label="省份" placeholder="如：广东省" />
          <van-field v-model="form.cityName" label="城市" placeholder="如：广州市" />
          <van-field v-model="form.districtName" label="区/县" placeholder="如：天河区" />
          <van-field v-model="form.detail" label="详细地址" placeholder="详细地址" />
          <van-field v-model="form.label" label="标签" placeholder="如：家/公司/学校" />
        </van-cell-group>
        <div style="margin:16px"><van-button block round type="primary" native-type="submit">保存</van-button></div>
      </van-form>
    </van-popup>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { getAddressList, saveAddress, updateAddress, deleteAddress, setDefaultAddress } from '@/api/index'

const router = useRouter()
const list = ref<any[]>([])
const showForm = ref(false)
const editing = ref<any>(null)
const form = reactive<any>({ consignee: '', phone: '', sex: '1', provinceName: '', cityName: '', districtName: '', detail: '', label: '' })

async function load() {
  try { const res: any = await getAddressList(); list.value = res.data || [] } catch { /**/ }
}

async function saveAddr() {
  try {
    if (editing.value) { await updateAddress({ ...form, id: editing.value.id }) }
    else { await saveAddress(form) }
    showToast('保存成功')
    showForm.value = false
    load()
  } catch { /**/ }
}

async function delAddr(id: number) { try { await deleteAddress(id); showToast('已删除'); load() } catch { /**/ } }

async function setDefault(addr: any) { try { await setDefaultAddress(addr); showToast('已设置'); load() } catch { /**/ } }

async function selectAddr(addr: any) { try { await setDefaultAddress(addr) } catch { /**/ } router.back() }

onMounted(() => load())
</script>

<style scoped>
.addr-list { padding: 12px 0 80px; }
.addr-card { margin: 0 12px 10px; background: #fff; border-radius: 12px; padding: 14px; }
.addr-card.default { border: 1px solid var(--accent); }
.addr-top { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.addr-name { font-size: 15px; font-weight: 600; }
.addr-phone { font-size: 13px; color: #666; }
.addr-detail { font-size: 13px; color: #555; margin-bottom: 10px; }
.addr-actions { display: flex; gap: 8px; }
.add-btn { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); width: calc(100% - 32px); max-width: 448px; }
</style>
