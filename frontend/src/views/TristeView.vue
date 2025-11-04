<template>
  <MoodView mood="triste" @click="handleClick" />
</template>

<script setup>
import { useRouter } from 'vue-router'
import MoodView from '@/components/MoodView.vue'
import { useMoodStore } from '@/stores/mood'

const router = useRouter()
const moodStore = useMoodStore()

const handleClick = () => {
  moodStore.changeMood('poker-face')
  router.push({ name: 'poker-face' })
}
</script>
