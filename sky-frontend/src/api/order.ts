import api from './index'

export function searchOrders(params: any) {
  return api.get('/admin/order/conditionSearch', { params })
}

export function getOrderStatistics() {
  return api.get('/admin/order/statistics')
}

export function getOrderDetail(id: number) {
  return api.get(`/admin/order/details/${id}`)
}

export function confirmOrder(data: { id: number }) {
  return api.put('/admin/order/confirm', data)
}

export function rejectOrder(data: { id: number; rejectionReason: string }) {
  return api.put('/admin/order/rejection', data)
}

export function cancelOrder(data: { id: number; cancelReason: string }) {
  return api.put('/admin/order/cancel', data)
}

export function deliveryOrder(id: number) {
  return api.put(`/admin/order/delivery/${id}`)
}

export function completeOrder(id: number) {
  return api.put(`/admin/order/complete/${id}`)
}
