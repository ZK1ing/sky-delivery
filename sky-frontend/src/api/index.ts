import axios from 'axios'
import { ElMessage } from 'element-plus'

const api = axios.create({
  baseURL: '',
  timeout: 15000,
})

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) config.headers['token'] = token
  return config
})

api.interceptors.response.use(
  (res) => {
    if (res.data.code === 0) {
      ElMessage.error(res.data.msg || '操作失败')
      return Promise.reject(new Error(res.data.msg))
    }
    return res.data
  },
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }
    ElMessage.error(err.message || '网络错误')
    return Promise.reject(err)
  }
)

export default api
