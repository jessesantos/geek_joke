<template>
  <div class="mood-container" @click="handleClick">
    <v-container fluid class="fill-height">
      <v-row align="center" justify="center">
        <v-col cols="12" class="text-center">
          <div class="mood-emoji">{{ emoji }}</div>
          <div class="mood-text mt-4">{{ text }}</div>
          <div class="mood-instruction mt-8 text-medium-emphasis">
            {{ instruction }}
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- Botão de logout no canto superior direito -->
    <v-btn
      icon="mdi-logout"
      class="logout-btn"
      color="error"
      variant="text"
      @click.stop="handleLogout"
      title="Sair"
    />
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const props = defineProps({
  mood: {
    type: String,
    required: true,
    validator: (value) => ['inicial', 'triste', 'poker-face', 'feliz'].includes(value)
  }
})

const emit = defineEmits(['click'])

const router = useRouter()
const authStore = useAuthStore()

const emoji = computed(() => {
  const emojiMap = {
    inicial: '😐',
    triste: '😢',
    'poker-face': '🫣',
    feliz: '😄'
  }
  return emojiMap[props.mood]
})

const text = computed(() => {
  const textMap = {
    inicial: 'Estado Inicial',
    triste: 'Estado Triste',
    'poker-face': 'Poker Face',
    feliz: 'Estado Feliz'
  }
  return textMap[props.mood]
})

const instruction = computed(() => {
  const instructionMap = {
    inicial: 'Clique na tela para mudar de estado',
    triste: 'Clique novamente para continuar',
    'poker-face': 'Clique para ver uma piada!',
    feliz: 'Aguarde um momento...'
  }
  return instructionMap[props.mood]
})

const handleClick = () => {
  emit('click')
}

const handleLogout = async () => {
  await authStore.logout()
  router.push({ name: 'login' })
}
</script>

<style scoped>
.mood-container {
  width: 100vw;
  height: 100vh;
  cursor: pointer;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  user-select: none;
}

.mood-emoji {
  font-size: 15rem;
  line-height: 1;
  animation: float 3s ease-in-out infinite;
}

.mood-text {
  font-size: 3rem;
  font-weight: bold;
  color: white;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.mood-instruction {
  font-size: 1.5rem;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.logout-btn {
  position: absolute;
  top: 20px;
  right: 20px;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
}

/* Responsivo */
@media (max-width: 768px) {
  .mood-emoji {
    font-size: 10rem;
  }

  .mood-text {
    font-size: 2rem;
  }

  .mood-instruction {
    font-size: 1.2rem;
  }
}

@media (max-width: 480px) {
  .mood-emoji {
    font-size: 7rem;
  }

  .mood-text {
    font-size: 1.5rem;
  }

  .mood-instruction {
    font-size: 1rem;
  }
}
</style>
