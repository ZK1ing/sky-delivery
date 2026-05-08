import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: () => import('@/views/Login.vue'),
      meta: { title: '登录' }
    },
    {
      path: '/',
      component: () => import('@/views/Layout.vue'),
      redirect: '/dashboard',
      children: [
        {
          path: 'dashboard',
          name: 'Dashboard',
          component: () => import('@/views/Dashboard.vue'),
          meta: { title: '工作台', icon: 'HomeFilled' }
        },
        {
          path: 'employee',
          name: 'Employee',
          component: () => import('@/views/employee/EmployeeList.vue'),
          meta: { title: '员工管理', icon: 'User' }
        },
        {
          path: 'category',
          name: 'Category',
          component: () => import('@/views/category/CategoryList.vue'),
          meta: { title: '分类管理', icon: 'Menu' }
        },
        {
          path: 'dish',
          name: 'Dish',
          component: () => import('@/views/dish/DishList.vue'),
          meta: { title: '菜品管理', icon: 'Food' }
        },
        {
          path: 'setmeal',
          name: 'Setmeal',
          component: () => import('@/views/setmeal/SetmealList.vue'),
          meta: { title: '套餐管理', icon: 'Collection' }
        },
        {
          path: 'order',
          name: 'Order',
          component: () => import('@/views/order/OrderList.vue'),
          meta: { title: '订单管理', icon: 'Document' }
        },
        {
          path: 'report',
          name: 'Report',
          component: () => import('@/views/report/ReportView.vue'),
          meta: { title: '数据统计', icon: 'DataAnalysis' }
        }
      ]
    }
  ]
})

router.beforeEach((to, _from, next) => {
  const token = localStorage.getItem('token')
  if (to.path !== '/login' && !token) next('/login')
  else if (to.path === '/login' && token) next('/')
  else next()
})

export default router
