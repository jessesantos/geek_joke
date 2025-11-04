/**
 * Authentication Store (Pinia)
 *
 * Manages user authentication state and JWT token
 * Will be fully implemented in Phase 5
 */
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import api from '@/services/api'

interface User {
  id: number
  email: string
  created_at: string
}

interface LoginCredentials {
  email: string
  password: string
}

interface LoginResponse {
  token: string
  user: User
}

export const useAuthStore = defineStore('auth', () => {
  // State
  const user = ref<User | null>(null)
  const token = ref<string | null>(null)

  // Getters
  const isAuthenticated = computed(() => !!token.value)

  // Actions
  async function login(credentials: LoginCredentials): Promise<void> {
    try {
      const response = await api.post<LoginResponse>('/auth/login', credentials)
      const { token: authToken, user: userData } = response.data

      // Store token and user data
      token.value = authToken
      user.value = userData

      // Persist to localStorage
      localStorage.setItem('auth_token', authToken)
      localStorage.setItem('user', JSON.stringify(userData))
    } catch (error) {
      console.error('Login failed:', error)
      throw error
    }
  }

  function logout(): void {
    // Clear state
    token.value = null
    user.value = null

    // Clear localStorage
    localStorage.removeItem('auth_token')
    localStorage.removeItem('user')
  }

  function checkAuth(): void {
    // Restore from localStorage on app initialization
    const storedToken = localStorage.getItem('auth_token')
    const storedUser = localStorage.getItem('user')

    if (storedToken && storedUser) {
      token.value = storedToken
      user.value = JSON.parse(storedUser)
    }
  }

  return {
    user,
    token,
    isAuthenticated,
    login,
    logout,
    checkAuth
  }
})
