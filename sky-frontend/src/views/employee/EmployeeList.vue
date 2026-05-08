<template>
  <div class="page">
    <div class="page-toolbar">
      <el-input v-model="searchName" placeholder="搜索员工姓名..." style="width:220px" clearable @clear="load" @keyup.enter="load" />
      <el-button type="primary" @click="dialogVisible = true; editingId = null; resetForm()">
        <el-icon><Plus /></el-icon>新增员工
      </el-button>
    </div>

    <el-card shadow="never">
      <el-table :data="tableData" stripe v-loading="loading" empty-text="暂无员工数据">
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="name" label="姓名" width="120" />
        <el-table-column prop="username" label="账号" width="140" />
        <el-table-column prop="phone" label="手机号" width="140" />
        <el-table-column prop="sex" label="性别" width="70">
          <template #default="{ row }">{{ row.sex === '1' ? '男' : '女' }}</template>
        </el-table-column>
        <el-table-column prop="idNumber" label="身份证号" min-width="180" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-switch :model-value="row.status === 1" @change="handleToggle(row)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="openEdit(row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination v-model:current-page="page" v-model:page-size="pageSize" :total="total" layout="total, sizes, prev, pager, next" :page-sizes="[10,20,50]" @change="load" />
    </el-card>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑员工' : '新增员工'" width="520px" destroy-on-close @closed="resetForm">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="姓名" prop="name"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="账号" prop="username"><el-input v-model="form.username" :disabled="!!editingId" /></el-form-item>
        <el-form-item label="手机号" prop="phone"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="性别" prop="sex"><el-radio-group v-model="form.sex"><el-radio value="1">男</el-radio><el-radio value="0">女</el-radio></el-radio-group></el-form-item>
        <el-form-item label="身份证号" prop="idNumber"><el-input v-model="form.idNumber" /></el-form-item>
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
import { getEmployees, getEmployeeById, addEmployee, updateEmployee, toggleEmployeeStatus } from '@/api/employee'

const tableData = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const saving = ref(false)
const editingId = ref<number | null>(null)
const searchName = ref('')
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const form = reactive({ name: '', username: '', phone: '', sex: '1', idNumber: '' })
const rules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  username: [{ required: true, message: '请输入账号', trigger: 'blur' }],
  phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }],
  sex: [{ required: true, message: '请选择性别', trigger: 'change' }],
  idNumber: [{ required: true, message: '请输入身份证号', trigger: 'blur' }],
}

function resetForm() {
  form.name = ''; form.username = ''; form.phone = ''; form.sex = '1'; form.idNumber = ''
  editingId.value = null
}

async function load() {
  loading.value = true
  try {
    const res: any = await getEmployees({ name: searchName.value, page: page.value, pageSize: pageSize.value })
    tableData.value = res.data.records
    total.value = res.data.total
  } catch { /**/ } finally { loading.value = false }
}

async function openEdit(row: any) {
  editingId.value = row.id
  const res: any = await getEmployeeById(row.id)
  Object.assign(form, res.data)
  dialogVisible.value = true
}

async function handleSave() {
  saving.value = true
  try {
    if (editingId.value) {
      await updateEmployee({ ...form, id: editingId.value })
      ElMessage.success('修改成功')
    } else {
      await addEmployee(form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    load()
  } catch { /**/ } finally { saving.value = false }
}

async function handleToggle(row: any) {
  const newStatus = row.status === 1 ? 0 : 1
  await toggleEmployeeStatus(newStatus, row.id)
  row.status = newStatus
  ElMessage.success(newStatus === 1 ? '已启用' : '已禁用')
}

onMounted(() => { load() })
</script>

<style scoped>
.page { max-width: 1280px; }
.page-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
</style>
