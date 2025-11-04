import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
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
  history: createWebHistory(),
  routes
})

// Guard de navegação global
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()

  // Se a rota requer autenticação
  if (to.meta.requiresAuth) {
    // Verificar se está autenticado
    if (!authStore.isAuthenticated) {
      // Redirecionar para login
      next({ name: 'login' })
    } else {
      // Verificar se o token ainda é válido
      const isValid = await authStore.checkAuth()
      if (isValid) {
        next()
      } else {
        next({ name: 'login' })
      }
    }
  } else {
    // Rota pública
    // Se já está autenticado e tenta acessar login, redireciona para inicial
    if (to.name === 'login' && authStore.isAuthenticated) {
      next({ name: 'inicial' })
    } else {
      next()
    }
  }
})

export default router
