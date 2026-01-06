import { createRouter, createWebHistory } from 'vue-router'

// Các component
import Login from '../components/Login.vue'
import Dashboard from '../components/Dashboard.vue'
import Products from '@/components/Products.vue'

// Layout chung (sidebar + header)
import AppLayout from '../layouts/AppLayout.vue'

// Store để kiểm tra đăng nhập
import { useUserStore } from '../stores/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login
  },

  {
    path: '/',
    component: AppLayout, // Layout chung cho tất cả trang sau login
    meta: { requiresAuth: true },
    children: [
      {
        path: '', // Trang chủ
        redirect: '/dashboard'
      },
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: Dashboard
      },
      {
        path: '/products',
        name: 'Products',
        component: Products
      },
      // Thêm các route khác ở đây sau này
      // Ví dụ:
      // {
      //   path: 'products',
      //   name: 'Products',
      //   component: () => import('../components/Products.vue')
      // },
      // {
      //   path: 'orders',
      //   name: 'Orders',
      //   component: () => import('../components/Orders.vue')
      // },
    ]
  },

  // Redirect mọi đường dẫn không tồn tại về login hoặc dashboard
  {
    path: '/:catchAll(.*)',
    redirect: '/login'
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// Bảo vệ route (guard)
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()

  // Nếu route yêu cầu đăng nhập mà chưa có user → chuyển về login
  if (to.meta.requiresAuth && !userStore.user) {
    next('/login')
  } 
  // Nếu đã login mà vào /login → chuyển về dashboard
  else if (to.path === '/login' && userStore.user) {
    next('/dashboard')
  } 
  // Các trường hợp khác → cho đi bình thường
  else {
    next()
  }
})

export default router