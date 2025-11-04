import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useMoodStore } from '../../src/stores/mood'

describe('Mood Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('deve inicializar com estado inicial correto', () => {
    const store = useMoodStore()

    expect(store.currentMood).toBe('inicial')
    expect(store.clickCount).toBe(0)
  })

  it('deve retornar emoji correto para cada humor', () => {
    const store = useMoodStore()

    store.currentMood = 'inicial'
    expect(store.getCurrentMoodEmoji).toBe('😐')

    store.currentMood = 'triste'
    expect(store.getCurrentMoodEmoji).toBe('😢')

    store.currentMood = 'poker-face'
    expect(store.getCurrentMoodEmoji).toBe('🫣')

    store.currentMood = 'feliz'
    expect(store.getCurrentMoodEmoji).toBe('😄')
  })

  it('deve retornar texto correto para cada humor', () => {
    const store = useMoodStore()

    store.currentMood = 'inicial'
    expect(store.getCurrentMoodText).toBe('Estado Inicial')

    store.currentMood = 'triste'
    expect(store.getCurrentMoodText).toBe('Estado Triste')

    store.currentMood = 'poker-face'
    expect(store.getCurrentMoodText).toBe('Poker Face')

    store.currentMood = 'feliz'
    expect(store.getCurrentMoodText).toBe('Estado Feliz')
  })

  it('deve mudar o humor corretamente', () => {
    const store = useMoodStore()

    expect(store.currentMood).toBe('inicial')

    store.changeMood('triste')
    expect(store.currentMood).toBe('triste')
    expect(store.clickCount).toBe(1)

    store.changeMood('poker-face')
    expect(store.currentMood).toBe('poker-face')
    expect(store.clickCount).toBe(2)

    store.changeMood('feliz')
    expect(store.currentMood).toBe('feliz')
    expect(store.clickCount).toBe(3)
  })

  it('deve incrementar o contador de cliques', () => {
    const store = useMoodStore()

    expect(store.clickCount).toBe(0)

    store.changeMood('triste')
    expect(store.clickCount).toBe(1)

    store.changeMood('poker-face')
    expect(store.clickCount).toBe(2)

    store.changeMood('feliz')
    expect(store.clickCount).toBe(3)
  })

  it('deve resetar o humor para o estado inicial', () => {
    const store = useMoodStore()

    // Mudar para diferentes estados
    store.changeMood('triste')
    store.changeMood('poker-face')
    store.changeMood('feliz')

    expect(store.currentMood).toBe('feliz')
    expect(store.clickCount).toBe(3)

    // Resetar
    store.resetMood()

    expect(store.currentMood).toBe('inicial')
    expect(store.clickCount).toBe(0)
  })

  it('deve retornar lista de humores disponíveis', () => {
    const store = useMoodStore()

    expect(store.moods).toEqual(['inicial', 'triste', 'poker-face', 'feliz'])
    expect(store.moods.length).toBe(4)
  })

  it('deve validar humor inválido', () => {
    const store = useMoodStore()

    store.currentMood = 'humor_invalido'

    // Humor inválido deve retornar emoji padrão
    expect(store.getCurrentMoodEmoji).toBe('❓')
    expect(store.getCurrentMoodText).toBe('Humor Desconhecido')
  })
})
