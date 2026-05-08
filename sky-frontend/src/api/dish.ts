import api from './index'

export function getDishes(params: { page: number; pageSize: number; name?: string; categoryId?: number; status?: number }) {
  return api.get('/admin/dish/page', { params })
}

export function getDishById(id: number) {
  return api.get(`/admin/dish/${id}`)
}

export function getDishesByCategory(categoryId: number) {
  return api.get('/admin/dish/list', { params: { categoryId } })
}

export function addDish(data: any) {
  return api.post('/admin/dish', data)
}

export function updateDish(data: any) {
  return api.put('/admin/dish', data)
}

export function deleteDishes(ids: number[]) {
  return api.delete('/admin/dish', { params: { ids: ids.join(',') } })
}

export function toggleDishStatus(status: number, id: number) {
  return api.post(`/admin/dish/status/${status}`, null, { params: { id } })
}
