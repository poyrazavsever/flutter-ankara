<script setup lang="ts">
// Soru Panosu'nun sade bir maketi. Gerçek ekran görüntüleri gelene kadar
// ve slaytlarda tutarlı bir "uygulama" temsili olarak kullanılır.
withDefaults(defineProps<{
  user: string
  highlight?: boolean
  online?: number
}>(), { online: 42 })

const questions = [
  { who: 'Ayşe', text: 'RLS kurallarını test etmek için en iyi yol ne?', mine: 'Ayşe' },
  { who: 'Mehmet', text: 'Realtime çok kullanıcıda nasıl ölçekleniyor?', mine: 'Mehmet' },
  { who: 'Zeynep', text: 'Storage dosyalarına erişimi nasıl sınırlarım?', mine: '' },
]
</script>

<template>
  <div class="glass board">
    <div class="board__bar">
      <div class="board__title">Soru Panosu</div>
      <div class="board__meta"><span class="dot dot--accent" /> {{ online }} kişi · {{ user }}</div>
    </div>
    <div v-if="highlight" class="board__q board__q--new">
      <div class="board__who">Ayşe · şimdi</div>
      <div class="board__text">Supabase'i Flutter'da offline nasıl kullanırım?</div>
    </div>
    <div v-for="q in questions" :key="q.text" class="board__q">
      <div class="board__who">{{ q.who }}</div>
      <div class="board__text">{{ q.text }}</div>
      <div v-if="q.mine === user" class="board__del">Sil</div>
    </div>
    <div class="board__input">Konuşmacıya bir soru sor…</div>
  </div>
</template>

<style scoped>
.board {
  padding: 22px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  font-size: 15px;
}

.board__bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.board__title {
  font-weight: 600;
  font-size: 18px;
  letter-spacing: -0.02em;
}

.board__meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text-dim);
}

.board__q {
  position: relative;
  padding: 12px 16px;
  border-radius: 14px;
  background: var(--bg-raised);
  border: 1px solid var(--glass-border);
}

.board__q--new {
  border-color: rgba(19, 128, 76, 0.45);
  background: var(--accent-tint);
}

.board__who {
  font-family: var(--font-mono);
  font-size: 11px;
  color: var(--text-dim);
  margin-bottom: 4px;
}

.board__text {
  color: var(--text);
  line-height: 1.35;
  padding-right: 36px;
}

.board__del {
  position: absolute;
  right: 14px;
  top: 12px;
  font-family: var(--font-mono);
  font-size: 11px;
  color: var(--deny-ink);
}

.board__input {
  margin-top: 4px;
  padding: 12px 16px;
  border-radius: 14px;
  border: 1px dashed var(--line);
  color: var(--text-dim);
}
</style>
