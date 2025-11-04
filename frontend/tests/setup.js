import { config } from '@vue/test-utils'

// Mock do localStorage
global.localStorage = {
  data: {},
  getItem(key) {
    return this.data[key] || null
  },
  setItem(key, value) {
    this.data[key] = value
  },
  removeItem(key) {
    delete this.data[key]
  },
  clear() {
    this.data = {}
  },
}

// Configurações globais para os testes
config.global.mocks = {
  $route: {
    params: {},
    query: {},
  },
  $router: {
    push: () => {},
    replace: () => {},
  },
}
