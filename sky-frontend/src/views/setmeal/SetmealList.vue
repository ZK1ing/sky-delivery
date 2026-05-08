<template>
  <div class="page">
    <div class="page-toolbar">
      <div class="toolbar-left">
        <el-input v-model="searchName" placeholder="搜索套餐..." style="width:200px" clearable @clear="load" @keyup.enter="load" />
        <el-select v-model="filterCategoryId" placeholder="套餐分类" style="width:150px;margin-left:12px" clearable @change="load">
          <el-option v-for="c in categories" :key="c.id" :label="c.name" :value="c.id" />
        </el-select>
      </div>
      <div class="toolbar-right">
        <el-button type="danger" :disabled="selectedIds.length===0" @click="handleBatchDelete">批量删除</el-button>
        <el-button type="primary" @click="openCreate"><el-icon><Plus /></el-icon>新增套餐</el-button>
      </div>
    </div>

    <el-card shadow="never">
      <el-table :data="tableData" stripe v-loading="loading" @selection-change="(v:any) => selectedIds = v.map((r:any) => r.id)" empty-text="暂无套餐数据">
        <el-table-column type="selection" width="50" />
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="name" label="套餐名称" min-width="160" />
        <el-table-column label="图片" width="90">
          <template #default="{ row }"><el-avatar :src="row.image" shape="square" size="small" v-if="row.image" /></template>
        </el-table-column>
        <el-table-column prop="categoryName" label="分类" width="110" />
        <el-table-column prop="price" label="价格" width="110">
          <template #default="{ row }"><span style="color:var(--accent);font-weight:600">¥{{ row.price }}</span></template>
        </el-table-column>
        <el-table-column label="状态" width="90">
          <template #default="{ row }"><el-switch :model-value="row.status === 1" @change="handleToggle(row)" /></template>
        </el-table-column>
        <el-table-column prop="updateTime" label="更新时间" width="170" />
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="openEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination v-model:current-page="page" v-model:page-size="pageSize" :total="total" layout="total, sizes, prev, pager, next" :page-sizes="[10,20,50]" @change="load" />
    </el-card>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑套餐' : '新增套餐'" width="720px" destroy-on-close @closed="resetForm">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="套餐名称" prop="name"><el-input v-model="form.name" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="分类" prop="categoryId"><el-select v-model="form.categoryId" style="width:100%"><el-option v-for="c in categories" :key="c.id" :label="c.name" :value="c.id" /></el-select></el-form-item></el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="价格" prop="price"><el-input-number v-model="form.price" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="图片" prop="image">
          <div class="upload-wrap">
            <el-input v-model="form.image" placeholder="图片URL" readonly />
            <el-upload :show-file-list="false" :before-upload="handleUpload" accept="image/*" style="display:inline-block;margin-left:8px">
              <el-button type="primary" :loading="uploading">上传</el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item label="描述" prop="description"><el-input v-model="form.description" type="textarea" :rows="2" /></el-form-item>
        <el-form-item label="包含菜品">
          <div v-for="(sd, idx) in form.setmealDishes" :key="idx" class="dish-row">
            <el-input v-model="sd.name" placeholder="菜品名称" style="width:150px" />
            <el-input-number v-model="sd.price" :min="0" :precision="2" placeholder="原价" style="width:130px;margin-left:8px" controls-position="right" />
            <el-input-number v-model="sd.copies" :min="1" placeholder="份数" style="width:100px;margin-left:8px" controls-position="right" />
            <el-button type="danger" link @click="form.setmealDishes.splice(idx,1)"><el-icon><Delete /></el-icon></el-button>
          </div>
          <el-button type="primary" link @click="form.setmealDishes.push({ name:'', price:0, copies:1 })">+ 添加菜品</el-button>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">{{ editingId ? '保存' : '新增' }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getSetmeals, getSetmealById, addSetmeal, updateSetmeal, deleteSetmeals, toggleSetmealStatus } from '@/api/setmeal'
import { getAllCategories } from '@/api/category'
import { uploadFile } from '@/api/shop'

const tableData = ref([]); const categories = ref<any[]>([])
const loading = ref(false); const dialogVisible = ref(false); const saving = ref(false); const uploading = ref(false)
const editingId = ref<number | null>(null); const selectedIds = ref<number[]>([])
const searchName = ref(''); const filterCategoryId = ref<number | undefined>(undefined)
const page = ref(1); const pageSize = ref(10); const total = ref(0)

const form = reactive<any>({ name: '', categoryId: undefined, price: 0, image: '', description: '', setmealDishes: [] })
const rules = {
  name: [{ required: true, message: '请输入套餐名称', trigger: 'blur' }],
  categoryId: [{ required: true, message: '请选择分类', trigger: 'change' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
}

function resetForm() { form.name = ''; form.categoryId = undefined; form.price = 0; form.image = ''; form.description = ''; form.setmealDishes = []; editingId.value = null }

async function load() {
  loading.value = true
  try {
    const res: any = await getSetmeals({ name: searchName.value, categoryId: filterCategoryId.value, page: page.value, pageSize: pageSize.value })
    tableData.value = res.data.records; total.value = res.data.total
  } catch { /**/ } finally { loading.value = false }
}

async function loadCategories() { try { const res: any = await getAllCategories(2); categories.value = res.data || [] } catch { /**/ } }

function openCreate() { editingId.value = null; resetForm(); dialogVisible.value = true }

async function openEdit(row: any) {
  editingId.value = row.id
  const res: any = await getSetmealById(row.id)
  const d = res.data
  form.name = d.name; form.categoryId = d.categoryId; form.price = d.price
  form.image = d.image || ''; form.description = d.description || ''
  form.setmealDishes = d.setmealDishes ? d.setmealDishes.map((s: any) => ({ name: s.name, price: s.price, copies: s.copies })) : []
  dialogVisible.value = true
}

async function handleSave() {
  saving.value = true
  try {
    const data = { ...form, categoryId: Number(form.categoryId), price: Number(form.price) }
    if (editingId.value) { data.id = editingId.value; await updateSetmeal(data); ElMessage.success('修改成功') }
    else { await addSetmeal(data); ElMessage.success('新增成功') }
    dialogVisible.value = false; load()
  } catch { /**/ } finally { saving.value = false }
}

async function handleDelete(id: number) {
  await ElMessageBox.confirm('确认删除该套餐？', '警告', { type: 'warning' })
  await deleteSetmeals([id]); ElMessage.success('删除成功'); load()
}

async function handleBatchDelete() {
  await ElMessageBox.confirm(`确认删除选中的 ${selectedIds.value.length} 个套餐？`, '警告', { type: 'warning' })
  await deleteSetmeals(selectedIds.value); ElMessage.success('删除成功'); load()
}

async function handleToggle(row: any) { const ns = row.status === 1 ? 0 : 1; await toggleSetmealStatus(ns, row.id); row.status = ns }

async function handleUpload(file: File) { uploading.value = true; try { const res: any = await uploadFile(file); form.image = res.data; ElMessage.success('上传成功') } catch { /**/ } finally { uploading.value = false }; return false }

onMounted(() => { load(); loadCategories() })
</script>

<style scoped>
.page { max-width: 1280px; }
.page-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.toolbar-left { display: flex; gap: 0; }
.toolbar-right { display: flex; gap: 8px; }
.upload-wrap { display: flex; align-items: center; width: 100%; }
.dish-row { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
</style>
