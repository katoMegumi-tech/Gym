import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const venueManagerAllowedPaths = new Set([
  '/',
  '/dashboard',
  '/venues',
  '/courts',
  '/coupons',
  '/feedback'
])

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue')
      },
      {
        path: 'venues',
        name: 'Venues',
        component: () => import('@/views/Venues.vue')
      },
      {
        path: 'courts',
        name: 'Courts',
        component: () => import('@/views/Courts.vue')
      },
      {
        path: 'reservations',
        name: 'Reservations',
        component: () => import('@/views/Reservations.vue')
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('@/views/Users.vue')
      },
      {
        path: 'announcements',
        name: 'Announcements',
        component: () => import('@/views/Announcements.vue')
      },
      {
        path: 'payments',
        name: 'Payments',
        component: () => import('@/views/Payments.vue')
      },
      {
        path: 'coupons',
        name: 'Coupons',
        component: () => import('@/views/Coupons.vue')
      },
      {
        path: 'feedback',
        name: 'Feedback',
        component: () => import('@/views/Feedback.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  const roleCode = userStore.userInfo?.roleCode

  if (to.path !== '/login' && !userStore.token) {
    next('/login')
  } else if (to.path === '/login' && userStore.token) {
    next('/')
  } else if (roleCode === 'VENUE_MANAGER' && !venueManagerAllowedPaths.has(to.path)) {
    next('/venues')
  } else {
    next()
  }
})

export default router
