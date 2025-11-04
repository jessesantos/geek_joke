import { defineStore } from 'pinia'
import api from '@/services/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: JSON.parse(localStorage.getItem('user')) || null,
    token: localStorage.getItem('token') || null,
    isAuthenticated: !!localStorage.getItem('token')
  }),

  actions: {
    async login(email, password) {
      try {
        const response = await api.post('/auth/login', {
          email,
          password
        })

        const { token, user } = response.data

        // Armazenar no localStorage
        localStorage.setItem('token', token)
        localStorage.setItem('user', JSON.stringify(user))

        // Atualizar state
        this.token = token
        this.user = user
        this.isAuthenticated = true

        return { success: true }
      } catch (error) {
        console.error('Erro no login:', error)
        return {
          success: false,
          message: error.response?.data?.message || 'Erro ao fazer login. Verifique suas credenciais.'
        }
      }
    },

    async logout() {
      try {
        // Tentar revogar token no backend
        await api.post('/auth/logout')
      } catch (error) {
        console.error('Erro ao fazer logout:', error)
      } finally {
        // Limpar dados locais independente do resultado
        this.clearAuth()
      }
    },

    clearAuth() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.token = null
      this.user = null
      this.isAuthenticated = false
    },

    async checkAuth() {
      if (!this.token) {
        return false
      }

      try {
        // Verificar se o token ainda é válido
        const response = await api.get('/auth/me')
        this.user = response.data
        return true
      } catch (error) {
        // Token inválido
        this.clearAuth()
        return false
      }
    }
  }
})
