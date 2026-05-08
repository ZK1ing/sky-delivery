import api from './index'

export function getSetmeals(params: { page: number; pageSize: number; name?: string; categoryId?: number; status?: number }) {
  return api.get('/admin/setmeal/page', { params })
}

export function getSetmealById(id: number) {
  return api.get(`/admin/setmeal/${id}`)
}

export function addSetmeal(data: any) {
  return api.post('/admin/setmeal', data)
}

export function updateSetmeal(data: any) {
  return api.put('/admin/setmeal', data)
}

export function deleteSetmeals(ids: number[]) {
  return api.delete('/admin/setmeal', { params: { ids: ids.join(',') } })
}

export function toggleSetmealStatus(status: number, id: number) {
  return api.post(`/admin/setmeal/status/${status}`, null, { params: { id } })
}
