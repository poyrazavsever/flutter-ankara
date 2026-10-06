<template>
  <div class="slidev-layout layout-section">
    <Backdrop variant="section" :image="$frontmatter.image" />
    <div class="section-number">{{ $frontmatter.number }}</div>
    <div class="section-content">
      <slot />
    </div>
  </div>
</template>

<style scoped>
.layout-section {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 80px 96px 96px;
}

.section-number {
  font-family: var(--font-mono);
  font-size: 18px;
  letter-spacing: 0.2em;
  color: var(--accent);
  margin-bottom: 24px;
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
</style>
