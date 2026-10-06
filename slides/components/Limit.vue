<script setup lang="ts">
// "Sınırlar ve dikkat" satırı: solda öne çıkan sayı/etiket, sağda açıklama.
defineProps<{
  value: string
  tone?: 'deny' | 'neutral'
}>()
</script>

<template>
  <div class="glass limit">
    <div class="limit__value" :class="{ 'limit__value--neutral': tone === 'neutral' }">{{ value }}</div>
    <div class="limit__text"><slot /></div>
  </div>
</template>

<style scoped>
.limit {
  display: grid;
  grid-template-columns: 200px 1fr;
  align-items: center;
  gap: 28px;
  padding: 22px 30px;
}

.limit__value {
  font-family: var(--font-mono);
  font-size: 26px;
  font-weight: 500;
  letter-spacing: -0.02em;
  color: var(--deny-ink);
}

.limit__value--neutral {
  color: var(--accent-ink);
}

.limit__text {
  font-size: 20px;
  line-height: 1.45;
  color: var(--text-muted);
}

.limit__text :deep(strong) {
  color: var(--text);
}
</style>
