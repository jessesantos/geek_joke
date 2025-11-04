/**
 * Mood Store (Pinia)
 *
 * Manages mood state and transitions
 * Will be fully implemented in Phase 6
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'

export type MoodType = 'inicial' | 'triste' | 'poker-face' | 'feliz'

export const useMoodStore = defineStore('mood', () => {
  // State
  const currentMood = ref<MoodType>('inicial')
  const clickCount = ref(0)

  // Actions
  function changeMood(newMood: MoodType): void {
    currentMood.value = newMood
    clickCount.value++
  }

  function resetMood(): void {
    currentMood.value = 'inicial'
    clickCount.value = 0
  }

  return {
    currentMood,
    clickCount,
    changeMood,
    resetMood
  }
})
