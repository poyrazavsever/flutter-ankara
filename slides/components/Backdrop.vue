<script setup lang="ts">
// Slayt zemini: düz açık renk. `image` verilirse Higgsfield görseli yerleşir
// ve cam paneller onun üzerinde kırılır.
defineProps<{
  image?: string
  position?: string
}>()
</script>

<template>
  <div class="backdrop">
    <img v-if="image" class="backdrop__image" :src="image" :style="{ objectPosition: position ?? 'center' }" alt="">
  </div>
</template>

<style scoped>
.backdrop {
  position: absolute;
  inset: 0;
  z-index: 0;
  background: var(--bg);
  pointer-events: none;
}

.backdrop__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
