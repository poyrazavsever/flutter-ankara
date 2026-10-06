<template>
  <div class="slidev-layout layout-section">
    <Backdrop :image="$frontmatter.image" :position="$frontmatter.imagePosition" />
    <div class="section-content">
      <slot />
    </div>
    <div v-if="$frontmatter.time" class="section-time">{{ $frontmatter.time }}</div>
  </div>
</template>

<style scoped>
.layout-section {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 80px 96px 96px;
}

.section-content :deep(h1) {
  font-size: 88px;
  letter-spacing: -0.05em;
  max-width: 900px;
}

.section-content :deep(p) {
  margin-top: 20px;
  font-size: 26px;
  max-width: 720px;
}

.section-time {
  position: absolute !important;
  right: 96px;
  bottom: 104px;
  font-family: var(--font-mono);
  font-size: 15px;
  color: var(--text-dim);
}
</style>
