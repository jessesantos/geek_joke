<template>
  <v-card class="mx-auto pa-12 pb-8" elevation="8" max-width="448" rounded="lg">
    <div class="text-center mb-6">
      <img
        src="@/assets/images/logo-gj.png"
        alt="Geek Joke Logo"
        class="logo"
      />
    </div>
    <div class="text-subtitle-1 text-medium-emphasis text-center mb-4">
      Entre para acessar piadas geek
    </div>

    <v-form @submit.prevent="handleSubmit" ref="form">
      <div class="text-subtitle-1 text-medium-emphasis">Email</div>

      <v-text-field
        v-model="email"
        density="compact"
        placeholder="Digite seu email"
        prepend-inner-icon="mdi-email-outline"
        variant="outlined"
        :rules="emailRules"
        :error-messages="errorMessage"
        @input="errorMessage = ''"
      />

      <div
        class="text-subtitle-1 text-medium-emphasis d-flex align-center justify-space-between"
      >
        Senha
      </div>

      <v-text-field
        v-model="password"
        :append-inner-icon="visible ? 'mdi-eye-off' : 'mdi-eye'"
        :type="visible ? 'text' : 'password'"
        density="compact"
        placeholder="Digite sua senha"
        prepend-inner-icon="mdi-lock-outline"
        variant="outlined"
        :rules="passwordRules"
        :error-messages="errorMessage"
        @click:append-inner="visible = !visible"
        @input="errorMessage = ''"
      />

      <v-btn
        type="submit"
        class="mb-8"
        color="primary"
        size="large"
        variant="tonal"
        block
        :loading="loading"
      >
        Entrar
      </v-btn>
    </v-form>

    <v-alert v-if="errorMessage" type="error" variant="tonal" class="mb-4">
      {{ errorMessage }}
    </v-alert>

    <v-card-text class="text-center">
      <div class="text-caption text-medium-emphasis">
        Email: cliente@incuca.com.br
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const router = useRouter();
const authStore = useAuthStore();

const form = ref(null);
const email = ref('');
const password = ref('');
const visible = ref(false);
const loading = ref(false);
const errorMessage = ref('');

// Regras de validação
const emailRules = [
  (v) => !!v || 'Email é obrigatório',
  (v) => /.+@.+\..+/.test(v) || 'Email deve ser válido',
];

const passwordRules = [
  (v) => !!v || 'Senha é obrigatória',
  (v) => v.length >= 8 || 'Senha deve ter no mínimo 8 caracteres',
];

const handleSubmit = async () => {
  // Validar formulário
  const { valid } = await form.value.validate();

  if (!valid) {
    return;
  }

  loading.value = true;
  errorMessage.value = '';

  try {
    const result = await authStore.login(email.value, password.value);

    if (result.success) {
      // Redirecionar para página inicial
      router.push({ name: 'inicial' });
    } else {
      errorMessage.value = result.message || 'Erro ao fazer login';
    }
  } catch (error) {
    errorMessage.value = 'Erro ao conectar com o servidor';
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.v-card {
  border: thin solid rgba(0, 0, 0, 0.12);
}

.logo {
  max-width: 150px;
  height: auto;
}
</style>
