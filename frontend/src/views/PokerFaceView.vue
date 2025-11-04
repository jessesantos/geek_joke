<template>
  <div>
    <MoodView mood="poker-face" @click="handleClick" />
    <JokeModal v-model="showModal" @close="handleModalClose" />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import MoodView from '@/components/MoodView.vue'
import JokeModal from '@/components/JokeModal.vue'
import { useMoodStore } from '@/stores/mood'

const router = useRouter()
const moodStore = useMoodStore()
const showModal = ref(false)

const handleClick = () => {
  showModal.value = true
}

const handleModalClose = () => {
  moodStore.changeMood('feliz')
  router.push({ name: 'feliz' })
}
</script>
