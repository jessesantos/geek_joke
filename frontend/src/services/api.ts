/**
 * Axios API Service Configuration
 *
 * Configures Axios with base URL and JWT authentication interceptor
 * Following Documentation-Driven Development specs from TO_DO.md Phase 4
 */
import axios from 'axios'
import type { AxiosInstance, InternalAxiosRequestConfig } from 'axios'

// Base URL - will use Nginx proxy in production (https://localhost/api)
const baseURL = import.meta.env.VITE_API_URL || 'https://localhost/api'

// Create Axios instance
const api: AxiosInstance = axios.create({
  baseURL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Request interceptor - adds JWT token to all requests
api.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = localStorage.getItem('auth_token')

    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`
    }

    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor - handles 401 errors (expired token)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid - clear localStorage and redirect to login
      localStorage.removeItem('auth_token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }

    return Promise.reject(error)
  }
)

export default api
