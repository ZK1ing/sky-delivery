import axios from 'axios'
import { showToast } from 'vant'

const api = axios.create({ baseURL: '', timeout: 15000 })

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('userToken')
  if (token) config.headers['authentication'] = token
  return config
})

api.interceptors.response.use(
  (res) => {
    if (res.data.code === 0) {
      showToast(res.data.msg || '操作失败')
      if (res.data.msg === 'NOT_LOGIN') {
        localStorage.removeItem('userToken')
        localStorage.removeItem('user')
        window.location.href = '/user'
      }
      return Promise.reject(new Error(res.data.msg))
    }
    return res.data
  },
  (err) => { showToast('网络错误'); return Promise.reject(err) }
)

export default api

// ---- 用户 API ----
export function loginByWechat(code: string) {
  return api.post('/user/user/login', { code })
}

// ---- 分类 ----
export function getCategories(type: number) {
  return api.get('/user/category/list', { params: { type } })
}

// ---- 菜品 ----
export function getDishesByCategory(categoryId: number) {
  return api.get('/user/dish/list', { params: { categoryId } })
}

// ---- 套餐 ----
export function getSetmealsByCategory(categoryId: number) {
  return api.get('/user/setmeal/list', { params: { categoryId } })
}

export function getSetmealDetail(id: number) {
  return api.get(`/user/setmeal/dish/${id}`)
}

// ---- 购物车 ----
export function addToCart(data: { dishId?: number; setmealId?: number; dishFlavor?: string }) {
  return api.post('/user/shoppingCart/add', data)
}

export function subFromCart(data: { dishId?: number; setmealId?: number; dishFlavor?: string }) {
  return api.post('/user/shoppingCart/sub', data)
}

export function getCartList() {
  return api.get('/user/shoppingCart/list')
}

export function cleanCart() {
  return api.delete('/user/shoppingCart/clean')
}

// ---- 地址簿 ----
export function getAddressList() {
  return api.get('/user/addressBook/list')
}

export function getDefaultAddress() {
  return api.get('/user/addressBook/default')
}

export function saveAddress(data: any) {
  return api.post('/user/addressBook', data)
}

export function updateAddress(data: any) {
  return api.put('/user/addressBook', data)
}

export function deleteAddress(id: number) {
  return api.delete('/user/addressBook', { params: { id } })
}

export function setDefaultAddress(data: any) {
  return api.put('/user/addressBook/default', data)
}

// ---- 订单 ----
export function submitOrder(data: any) {
  return api.post('/user/order/submit', data)
}

export function getOrders(params: { page: number; pageSize: number; status?: number }) {
  return api.get('/user/order/historyOrders', { params })
}

export function getOrderDetailAPI(id: number) {
  return api.get(`/user/order/orderDetail/${id}`)
}

export function cancelUserOrder(id: number) {
  return api.put(`/user/order/cancel/${id}`)
}

export function orderAgain(id: number) {
  return api.post(`/user/order/repetition/${id}`)
}

export function remindOrder(id: number) {
  return api.put(`/user/order/reminder/${id}`)
}

// ---- 店铺 ----
export function getShopStatus() {
  return api.get('/user/shop/status')
}
