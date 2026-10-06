<template>
  <div class="slidev-layout layout-cover">
    <Backdrop :image="$frontmatter.image" :position="$frontmatter.imagePosition" />
    <div class="cover-content">
      <slot />
    </div>
    <div class="cover-meta">
      <slot name="meta" />
    </div>
  </div>
</template>

<style scoped>
.layout-cover {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 80px 96px;
}

.cover-content {
  max-width: 720px;
}

.cover-content :deep(h1) {
  font-size: 76px;
  line-height: 1.02;
  letter-spacing: -0.045em;
}

.cover-content :deep(h1 + p) {
  margin-top: 28px;
  font-size: 28px;
}

.cover-meta {
  position: absolute !important;
  left: 96px;
  right: 96px;
  bottom: 56px;
}
</style>
