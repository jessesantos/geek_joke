<template>
  <v-container fluid class="fill-height login-container">
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="6" lg="4">
        <LoginForm />
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import LoginForm from '@/components/LoginForm.vue'
</script>

<style scoped>
.login-container {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}
</style>
