<template>
  <v-container fluid class="fill-height mood-container">
    <v-row align="center" justify="center">
      <v-col cols="12" class="text-center">
        <div class="emoji-display">😢</div>
        <h2 class="mt-4">Triste</h2>
        <p class="text-grey">Placeholder - Will be implemented in Phase 6</p>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
// MoodView component and click handling will be added in Phase 6
</script>

<style scoped>
.mood-container {
  cursor: pointer;
  user-select: none;
}

.emoji-display {
  font-size: 10rem;
  line-height: 1;
}
</style>
