import api from './index'

export function getBusinessData() {
  return api.get('/admin/workspace/businessData')
}

export function getOrderOverview() {
  return api.get('/admin/workspace/overviewOrders')
}

export function getDishOverview() {
  return api.get('/admin/workspace/overviewDishes')
}

export function getSetmealOverview() {
  return api.get('/admin/workspace/overviewSetmeals')
}
