<template>
  <div class="slidev-layout layout-default">
    <Backdrop :variant="$frontmatter.backdrop ?? 'quiet'" :image="$frontmatter.image" />
    <div v-if="$frontmatter.kicker" class="kicker">{{ $frontmatter.kicker }}</div>
    <slot />
    <div class="slide-footer">
      <span>Flutter Ankara</span>
      <span>{{ $page }}</span>
    </div>
  </div>
</template>

<style scoped>
.layout-default {
  display: flex;
  flex-direction: column;
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
  letter-spacing: 0.08em;
  color: var(--text-dim);
}
</style>
