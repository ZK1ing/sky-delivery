import api from './index'

export function getShopStatus() {
  return api.get('/admin/shop/status')
}

export function setShopStatus(status: number) {
  return api.put(`/admin/shop/${status}`)
}

export function uploadFile(file: File) {
  const formData = new FormData()
  formData.append('file', file)
  return api.post('/admin/common/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}
