import api from './index'

export function getCategories(params: { page: number; pageSize: number; name?: string; type?: number }) {
  return api.get('/admin/category/page', { params })
}

export function getAllCategories(type?: number) {
  return api.get('/admin/category/list', { params: { type } })
}

export function addCategory(data: any) {
  return api.post('/admin/category', data)
}

export function updateCategory(data: any) {
  return api.put('/admin/category', data)
}

export function deleteCategory(id: number) {
  return api.delete('/admin/category', { params: { id } })
}

export function toggleCategoryStatus(status: number, id: number) {
  return api.post(`/admin/category/status/${status}`, null, { params: { id } })
}
