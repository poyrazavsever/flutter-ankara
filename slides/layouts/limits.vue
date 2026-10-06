<template>
  <div class="slidev-layout layout-limits">
    <Backdrop />
    <aside class="limits-aside">
      <img v-if="$frontmatter.icon" class="limits-icon" :src="`/img/icons/${$frontmatter.icon}.png`" alt="">
      <div class="limits-service">{{ $frontmatter.service }}</div>
      <div class="limits-caption">Sınırlar ve dikkat</div>
    </aside>
    <main class="limits-main">
      <slot />
    </main>
    <div class="slide-footer">
      <span>Flutter Ankara</span>
      <span>{{ $page }}</span>
    </div>
  </div>
</template>

<style scoped>
.layout-limits {
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: 64px;
  align-items: center;
}

.limits-aside {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.limits-icon {
  width: 180px;
  height: 180px;
  margin: 0 0 20px -18px;
}

.limits-service {
  font-size: 40px;
  font-weight: 600;
  letter-spacing: -0.03em;
  line-height: 1.1;
}

.limits-caption {
  margin-top: 10px;
  font-family: var(--font-mono);
  font-size: 15px;
  color: var(--deny-ink);
}

.limits-main {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.slide-footer {
  position: absolute !important;
  left: 80px;
  right: 80px;
  bottom: 28px;
  display: flex;
  justify-content: space-between;
  font-family: var(--font-mono);
  font-size: 13px;
  letter-spacing: 0.06em;
  color: var(--text-dim);
}
</style>
