<script setup lang="ts">
withDefaults(defineProps<{
  tone?: 'neutral' | 'accent' | 'flutter' | 'deny'
  pad?: 'sm' | 'md' | 'lg'
}>(), { tone: 'neutral', pad: 'md' })
</script>

<template>
  <div class="glass" :class="[tone !== 'neutral' && `glass--${tone}`, `glass-pad--${pad}`]">
    <slot />
  </div>
</template>

<style scoped>
.glass-pad--sm { padding: 18px 22px; }
.glass-pad--md { padding: 28px 32px; }
.glass-pad--lg { padding: 44px 52px; }
</style>
