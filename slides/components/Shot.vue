<script setup lang="ts">
// Supabase panelinden bir ekran görüntüsü: üstte panel içindeki yol,
// isteğe bağlı olarak tıklanacak yeri gösteren cam el.
withDefaults(defineProps<{
  src: string
  path?: string[]
  // Elin işaret parmağı ucunun görüntü üzerindeki konumu (yüzde)
  hand?: [number, number]
  focus?: string
}>(), {})
</script>

<template>
  <figure class="shot">
    <div v-if="path?.length" class="shot__path">
      <template v-for="(p, i) in path" :key="p">
        <span v-if="i" class="shot__sep">→</span>
        <span :class="{ 'shot__last': i === path.length - 1 }">{{ p }}</span>
      </template>
    </div>
    <div class="glass shot__frame">
      <img class="shot__img" :src="src" alt="" :style="focus ? { objectPosition: focus } : undefined">
      <img
        v-if="hand"
        class="shot__hand"
        src="/img/icons/hand.png"
        alt=""
        :style="{ left: `${hand[0]}%`, top: `${hand[1]}%` }"
      >
    </div>
  </figure>
</template>

<style scoped>
.shot {
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 14px;
  min-height: 0;
}

.shot__path {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  font-family: var(--font-mono);
  font-size: 15px;
  color: var(--text-muted);
}

.shot__sep {
  color: var(--text-dim);
}

.shot__last {
  color: var(--accent-ink);
}

.shot__frame {
  position: relative;
  padding: 8px;
  border-radius: 20px;
  overflow: visible;
}

.shot__img {
  display: block;
  width: 100%;
  border-radius: 13px;
  border: 1px solid var(--line);
}

/* Elin parmak ucu (görselin sol üst bölgesi) işaret edilen noktaya oturur */
.shot__hand {
  position: absolute;
  width: 96px;
  height: 96px;
  transform: translate(-22%, -12%);
  filter: drop-shadow(0 10px 18px rgba(11, 31, 23, 0.22));
  pointer-events: none;
}
</style>
