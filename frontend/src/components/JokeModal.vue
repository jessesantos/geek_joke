<template>
  <v-dialog v-model="dialog" persistent max-width="600px">
    <v-card>
      <v-card-title class="text-h5 bg-primary">
        <v-icon left class="mr-2">mdi-emoticon-lol-outline</v-icon>
        Piada Geek
      </v-card-title>

      <v-card-text class="pt-6">
        <div v-if="loading" class="text-center py-8">
          <v-progress-circular indeterminate color="primary" size="64" />
          <div class="mt-4">Buscando piada...</div>
        </div>

        <div v-else-if="error" class="text-center py-8">
          <v-icon color="error" size="64">mdi-alert-circle-outline</v-icon>
          <div class="mt-4 text-error">{{ error }}</div>
        </div>

        <div v-else class="joke-content py-4">
          <p class="text-h6">{{ joke }}</p>
        </div>
      </v-card-text>

      <v-divider />

      <v-card-actions>
        <v-spacer />
        <v-btn color="primary" variant="text" @click="handleClose" :disabled="loading">
          Fechar
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, watch } from 'vue'
import api from '@/services/api'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue', 'close'])

const dialog = ref(props.modelValue)
const joke = ref('')
const loading = ref(false)
const error = ref('')

// Watch para sincronizar com v-model
watch(
  () => props.modelValue,
  (newValue) => {
    dialog.value = newValue
    if (newValue) {
      fetchJoke()
    }
  }
)

watch(dialog, (newValue) => {
  emit('update:modelValue', newValue)
})

const fetchJoke = async () => {
  loading.value = true
  error.value = ''
  joke.value = ''

  try {
    const response = await api.get('/jokes/random')
    joke.value = response.data.joke
  } catch (err) {
    console.error('Erro ao buscar piada:', err)
    error.value = 'Não foi possível carregar a piada. Tente novamente.'
  } finally {
    loading.value = false
  }
}

const handleClose = () => {
  dialog.value = false
  emit('close')
}
</script>

<style scoped>
.joke-content {
  min-height: 150px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.joke-content p {
  line-height: 1.6;
  color: rgba(0, 0, 0, 0.87);
}
</style>
