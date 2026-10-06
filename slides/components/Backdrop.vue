<script setup lang="ts">
// Slayt arka planı: koyu zümrüt zemin, yumuşak ışık lekeleri ve ince doku.
// `image` verilirse Higgsfield görseli zeminin üzerine yerleşir.
withDefaults(defineProps<{
  variant?: 'default' | 'cover' | 'section' | 'quiet'
  image?: string
}>(), { variant: 'default' })
</script>

<template>
  <div class="backdrop" :class="`backdrop--${variant}`">
    <img v-if="image" class="backdrop__image" :src="image" alt="">
    <div class="backdrop__orb backdrop__orb--a" />
    <div class="backdrop__orb backdrop__orb--b" />
    <div class="backdrop__orb backdrop__orb--c" />
    <div class="backdrop__grain" />
    <div class="backdrop__vignette" />
  </div>
</template>

<style scoped>
.backdrop {
  position: absolute;
  inset: 0;
  z-index: 0;
  overflow: hidden;
  background: radial-gradient(120% 90% at 50% 0%, var(--bg-2), var(--bg-1) 55%, var(--bg-0));
  pointer-events: none;
}

.backdrop__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.backdrop__orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
}

.backdrop__orb--a {
  width: 520px;
  height: 520px;
  right: -120px;
  top: -160px;
  background: radial-gradient(circle, rgba(62, 207, 142, 0.38), transparent 70%);
}

.backdrop__orb--b {
  width: 460px;
  height: 460px;
  left: -160px;
  bottom: -200px;
  background: radial-gradient(circle, rgba(36, 180, 126, 0.28), transparent 70%);
}

.backdrop__orb--c {
  width: 300px;
  height: 300px;
  left: 45%;
  top: 55%;
  background: radial-gradient(circle, rgba(84, 197, 248, 0.1), transparent 70%);
}

.backdrop--cover .backdrop__orb--a {
  width: 780px;
  height: 780px;
  right: -180px;
  top: -220px;
}

.backdrop--section .backdrop__orb--a {
  right: 20%;
  top: 10%;
  width: 640px;
  height: 640px;
}

.backdrop--quiet .backdrop__orb {
  opacity: 0.45;
}

.backdrop__grain {
  position: absolute;
  inset: 0;
  opacity: 0.07;
  mix-blend-mode: overlay;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
}

.backdrop__vignette {
  position: absolute;
  inset: 0;
  background: radial-gradient(130% 100% at 50% 40%, transparent 55%, rgba(0, 0, 0, 0.55));
}
</style>
