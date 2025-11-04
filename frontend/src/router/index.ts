/**
 * Vue Router Configuration
 *
 * Defines application routes with authentication guards
 * Following Documentation-Driven Development specs from TO_DO.md Phase 5
 */
import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

// Placeholder views - will be created in Phase 5 and 6
const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/inicial',
    name: 'inicial',
    component: () => import('@/views/InicialView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/triste',
    name: 'triste',
    component: () => import('@/views/TristeView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/poker-face',
    name: 'poker-face',
    component: () => import('@/views/PokerFaceView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/feliz',
    name: 'feliz',
    component: () => import('@/views/FelizView.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// Navigation guard for authentication
// Will be fully implemented in Phase 5
router.beforeEach((to, _from, next) => {
  const token = localStorage.getItem('auth_token')
  const requiresAuth = to.meta.requiresAuth

  if (requiresAuth && !token) {
    // Redirect to login if route requires auth and no token
    next('/login')
  } else if (to.path === '/login' && token) {
    // Redirect to inicial if already logged in
    next('/inicial')
  } else {
    next()
  }
})

export default router
