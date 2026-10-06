<template>
  <div class="slidev-layout layout-default">
    <Backdrop :image="$frontmatter.image" :position="$frontmatter.imagePosition" />
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
  letter-spacing: 0.06em;
  color: var(--text-dim);
}
</style>
