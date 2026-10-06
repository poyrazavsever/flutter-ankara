import { defineConfig } from 'vite'

// Slidev'in yerleşik kod stillerindeki bir kural lightningcss küçültücüsünü
// bozuyor; CSS küçültmeyi kapatmak derlemeyi düzeltiyor.
export default defineConfig({
  build: {
    cssMinify: false,
  },
})
