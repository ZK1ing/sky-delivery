import api from './index'

export function login(username: string, password: string) {
  return api.post('/admin/employee/login', { username, password })
}

export function getEmployees(params: { name?: string; page: number; pageSize: number }) {
  return api.get('/admin/employee/page', { params })
}

export function getEmployeeById(id: number) {
  return api.get(`/admin/employee/${id}`)
}

export function addEmployee(data: any) {
  return api.post('/admin/employee', data)
}

export function updateEmployee(data: any) {
  return api.put('/admin/employee', data)
}

export function toggleEmployeeStatus(status: number, id: number) {
  return api.post(`/admin/employee/status/${status}`, null, { params: { id } })
}
