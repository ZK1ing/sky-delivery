<template>
  <div class="page">
    <div class="page-toolbar">
      <div class="toolbar-left">
        <el-input v-model="searchName" placeholder="搜索分类名称..." style="width:220px" clearable @clear="load" @keyup.enter="load" />
        <el-select v-model="filterType" placeholder="分类类型" style="width:140px;margin-left:12px" clearable @change="load">
          <el-option label="菜品分类" :value="1" /><el-option label="套餐分类" :value="2" />
        </el-select>
      </div>
      <el-button type="primary" @click="dialogVisible = true; editingId = null; resetForm()">
        <el-icon><Plus /></el-icon>新增分类
      </el-button>
    </div>

    <el-card shadow="never">
      <el-table :data="tableData" stripe v-loading="loading" empty-text="暂无分类数据">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="分类名称" min-width="180" />
        <el-table-column label="分类类型" width="120">
          <template #default="{ row }"><el-tag :type="row.type === 1 ? '' : 'success'" size="small">{{ row.type === 1 ? '菜品分类' : '套餐分类' }}</el-tag></template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="100" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-switch :model-value="row.status === 1" @change="handleToggle(row)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="openEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination v-model:current-page="page" v-model:page-size="pageSize" :total="total" layout="total, sizes, prev, pager, next" :page-sizes="[10,20,50]" @change="load" />
    </el-card>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑分类' : '新增分类'" width="480px" destroy-on-close @closed="resetForm">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="分类名称" prop="name"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="分类类型" prop="type"><el-radio-group v-model="form.type"><el-radio :value="1">菜品分类</el-radio><el-radio :value="2">套餐分类</el-radio></el-radio-group></el-form-item>
        <el-form-item label="排序" prop="sort"><el-input-number v-model="form.sort" :min="0" /></el-form-item>
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
import { getCategories, addCategory, updateCategory, deleteCategory, toggleCategoryStatus } from '@/api/category'

const tableData = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const saving = ref(false)
const editingId = ref<number | null>(null)
const searchName = ref('')
const filterType = ref<number | undefined>(undefined)
const page = ref(1); const pageSize = ref(10); const total = ref(0)

const form = reactive({ name: '', type: 1, sort: 0 })
const rules = {
  name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }],
  type: [{ required: true, message: '请选择分类类型', trigger: 'change' }],
}

function resetForm() { form.name = ''; form.type = 1; form.sort = 0; editingId.value = null }

async function load() {
  loading.value = true
  try {
    const res: any = await getCategories({ name: searchName.value, type: filterType.value, page: page.value, pageSize: pageSize.value })
    tableData.value = res.data.records; total.value = res.data.total
  } catch { /**/ } finally { loading.value = false }
}

function openEdit(row: any) {
  editingId.value = row.id
  Object.assign(form, row)
  dialogVisible.value = true
}

async function handleSave() {
  saving.value = true
  try {
    if (editingId.value) { await updateCategory({ ...form, id: editingId.value }); ElMessage.success('修改成功') }
    else { await addCategory(form); ElMessage.success('新增成功') }
    dialogVisible.value = false; load()
  } catch { /**/ } finally { saving.value = false }
}

async function handleDelete(row: any) {
  await ElMessageBox.confirm('确认删除该分类？删除后不可恢复。', '警告', { type: 'warning' })
  await deleteCategory(row.id); ElMessage.success('删除成功'); load()
}

async function handleToggle(row: any) {
  const ns = row.status === 1 ? 0 : 1
  await toggleCategoryStatus(ns, row.id)
  row.status = ns; ElMessage.success(ns === 1 ? '已启用' : '已禁用')
}

onMounted(() => { load() })
</script>

<style scoped>
.page { max-width: 1280px; }
.page-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.toolbar-left { display: flex; gap: 12px; }
</style>
