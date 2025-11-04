import { defineStore } from 'pinia'

export const useMoodStore = defineStore('mood', {
  state: () => ({
    currentMood: 'inicial',
    clickCount: 0,
    moods: ['inicial', 'triste', 'poker-face', 'feliz']
  }),

  getters: {
    getCurrentMoodEmoji: (state) => {
      const emojiMap = {
        inicial: '😐',
        triste: '😢',
        'poker-face': '🫣',
        feliz: '😄'
      }
      return emojiMap[state.currentMood] || '😐'
    },

    getCurrentMoodText: (state) => {
      const textMap = {
        inicial: 'Inicial',
        triste: 'Triste',
        'poker-face': 'Poker Face',
        feliz: 'Feliz'
      }
      return textMap[state.currentMood] || 'Inicial'
    }
  },

  actions: {
    changeMood(newMood) {
      if (this.moods.includes(newMood)) {
        this.currentMood = newMood
        this.clickCount++
      }
    },

    resetMood() {
      this.currentMood = 'inicial'
      this.clickCount = 0
    }
  }
})
