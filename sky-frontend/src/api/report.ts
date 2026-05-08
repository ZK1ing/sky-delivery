import api from './index'

export function getTurnover(begin: string, end: string) {
  return api.get('/admin/report/turnoverStatistics', { params: { begin, end } })
}

export function getUserStats(begin: string, end: string) {
  return api.get('/admin/report/userStatistics', { params: { begin, end } })
}

export function getOrderStats(begin: string, end: string) {
  return api.get('/admin/report/ordersStatistics', { params: { begin, end } })
}

export function getTop10(begin: string, end: string) {
  return api.get('/admin/report/top10', { params: { begin, end } })
}

export function exportReport(begin: string, end: string) {
  return api.get('/admin/report/export', { params: { begin, end }, responseType: 'blob' })
}
