import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', redirect: '/home' },
    { path: '/home', name: 'Home', component: () => import('@/views/Home.vue'), meta: { title: '首页' } },
    { path: '/cart', name: 'Cart', component: () => import('@/views/Cart.vue'), meta: { title: '购物车' } },
    { path: '/orders', name: 'Orders', component: () => import('@/views/Orders.vue'), meta: { title: '订单' } },
    { path: '/user', name: 'User', component: () => import('@/views/User.vue'), meta: { title: '我的' } },
    { path: '/checkout', name: 'Checkout', component: () => import('@/views/Checkout.vue'), meta: { title: '确认下单' } },
    { path: '/address', name: 'Address', component: () => import('@/views/Address.vue'), meta: { title: '收货地址' } },
    { path: '/order-detail/:id', name: 'OrderDetail', component: () => import('@/views/OrderDetail.vue'), meta: { title: '订单详情' } },
  ]
})

export default router
