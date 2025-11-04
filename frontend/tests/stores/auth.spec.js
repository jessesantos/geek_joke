import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '../../src/stores/auth'

// Mock do módulo api
vi.mock('../../src/services/api', () => ({
  default: {
    post: vi.fn(),
    get: vi.fn(),
  },
}))

describe('Auth Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
    vi.clearAllMocks()
  })

  it('deve inicializar com estado não autenticado', () => {
    const store = useAuthStore()

    expect(store.user).toBeNull()
    expect(store.token).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })

  it('deve fazer login com sucesso', async () => {
    const store = useAuthStore()
    const api = (await import('../../src/services/api')).default

    const mockResponse = {
      data: {
        token: 'fake-jwt-token',
        user: {
          id: 1,
          email: 'teste@teste.com',
        },
      },
    }

    api.post.mockResolvedValue(mockResponse)

    const result = await store.login('teste@teste.com', 'senha123')

    expect(result.success).toBe(true)
    expect(store.token).toBe('fake-jwt-token')
    expect(store.user).toEqual(mockResponse.data.user)
    expect(store.isAuthenticated).toBe(true)
    expect(localStorage.getItem('token')).toBe('fake-jwt-token')
  })

  it('deve falhar ao fazer login com credenciais inválidas', async () => {
    const store = useAuthStore()
    const api = (await import('../../src/services/api')).default

    api.post.mockRejectedValue({
      response: {
        status: 400,
        data: { message: 'Credenciais inválidas' },
      },
    })

    const result = await store.login('teste@teste.com', 'senhaerrada')

    expect(result.success).toBe(false)
    expect(result.message).toBeDefined()
    expect(store.token).toBeNull()
    expect(store.user).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })

  it('deve fazer logout corretamente', () => {
    const store = useAuthStore()

    // Simular usuário logado
    store.token = 'fake-token'
    store.user = { id: 1, email: 'teste@teste.com' }
    localStorage.setItem('token', 'fake-token')
    localStorage.setItem('user', JSON.stringify(store.user))

    store.logout()

    expect(store.token).toBeNull()
    expect(store.user).toBeNull()
    expect(store.isAuthenticated).toBe(false)
    expect(localStorage.getItem('token')).toBeNull()
    expect(localStorage.getItem('user')).toBeNull()
  })

  it('deve verificar autenticação com token válido', async () => {
    const store = useAuthStore()
    const api = (await import('../../src/services/api')).default

    const mockUser = {
      id: 1,
      email: 'teste@teste.com',
    }

    localStorage.setItem('token', 'fake-token')

    api.get.mockResolvedValue({
      data: mockUser,
    })

    await store.checkAuth()

    expect(store.user).toEqual(mockUser)
    expect(store.token).toBe('fake-token')
    expect(store.isAuthenticated).toBe(true)
  })

  it('deve limpar auth quando token é inválido', async () => {
    const store = useAuthStore()
    const api = (await import('../../src/services/api')).default

    localStorage.setItem('token', 'invalid-token')

    api.get.mockRejectedValue({
      response: { status: 401 },
    })

    await store.checkAuth()

    expect(store.user).toBeNull()
    expect(store.token).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })

  it('deve restaurar token do localStorage', () => {
    localStorage.setItem('token', 'stored-token')
    localStorage.setItem('user', JSON.stringify({ id: 1, email: 'teste@teste.com' }))

    const store = useAuthStore()

    // A store deve carregar do localStorage no estado inicial
    expect(store.token).toBe('stored-token')
    expect(store.user).toEqual({ id: 1, email: 'teste@teste.com' })
    expect(store.isAuthenticated).toBe(true)
  })

  it('deve limpar auth quando clearAuth é chamado', () => {
    const store = useAuthStore()

    store.token = 'fake-token'
    store.user = { id: 1, email: 'teste@teste.com' }
    localStorage.setItem('token', 'fake-token')

    store.clearAuth()

    expect(store.token).toBeNull()
    expect(store.user).toBeNull()
    expect(store.isAuthenticated).toBe(false)
    expect(localStorage.getItem('token')).toBeNull()
  })
})
