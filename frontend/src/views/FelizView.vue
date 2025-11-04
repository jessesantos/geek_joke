<template>
  <MoodView mood="feliz" @click="() => {}" />
</template>

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import MoodView from '@/components/MoodView.vue'
import { useMoodStore } from '@/stores/mood'

const router = useRouter()
const moodStore = useMoodStore()

// Após 3 segundos, retorna para o estado inicial
onMounted(() => {
  setTimeout(() => {
    moodStore.resetMood()
    router.push({ name: 'inicial' })
  }, 3000)
})
</script>
