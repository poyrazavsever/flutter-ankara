// KONUSMA.md'den slayt görselli, yazdırılabilir konuşma metni üretir.
// Kullanım: node docs/konusma/build.mjs  (görseller için önce: cd slides && npx slidev export --format png --output ../docs/konusma/slides, ardından PNG→JPG)
import { readFileSync, writeFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const here = dirname(fileURLToPath(import.meta.url))
const require = createRequire(join(here, '../../slides/package.json'))
const md = require('markdown-it')({ html: false, typographer: true })

const src = readFileSync(join(here, '../KONUSMA.md'), 'utf8').replace(/\r\n/g, '\n')
const [, part1Raw, part2Raw] = src.split(/^# Bölüm \d — .*$/m)

// Bölüm 1: arka plan bilgisi, "## 1.x" başlıklarına göre
const background = part1Raw.split(/^## /m).slice(1).map((s) => {
  const nl = s.indexOf('\n')
  return { title: s.slice(0, nl).trim(), html: md.render(s.slice(nl + 1).replace(/^---\s*$/gm, '')) }
})

// Bölüm 2: slayt slayt metin
const [intro, ...rest] = part2Raw.split(/^### Slayt /m)
const tail = rest.at(-1).split(/^## Prova kontrol listesi/m)
rest[rest.length - 1] = tail[0]
const checklist = (tail[1] || '').trim().split('\n').filter(l => l.startsWith('- [ ]')).map(l => l.slice(6))

let clock = 0
const fmt = s => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`
const slides = rest.map((s) => {
  const nl = s.indexOf('\n')
  const m = s.slice(0, nl).match(/^(\d+) — (.+?) · (.+)$/)
  const [, n, title, timeRaw] = m
  const t = timeRaw.match(/(\d+):(\d+)/)
  const secs = t ? +t[1] * 60 + +t[2] : 0
  const start = clock
  clock += secs
  const isSection = title.startsWith('Bölüm:')
  const body = s.slice(nl + 1)
    .replace(/^---\s*$/gm, '')
    .replace(/`\[→\]`/g, '')
    .trim()
  return { n: +n, title, timeRaw, start, isSection, html: md.render(body) }
})

const esc = s => s.replace(/&/g, '&amp;').replace(/</g, '&lt;')

const html = `<!doctype html>
<html lang="tr" translate="no">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="google" content="notranslate">
<title>Konuşma Metni</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600&family=Geist+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
:root {
  --bg: #F3F6F4; --card: #FFFFFF; --line: #DDE6E0;
  --text: #0B1F17; --muted: #4F665A; --dim: #84978C;
  --accent: #3ECF8E; --accent-ink: #13804C; --accent-soft: #E3F7EC;
  --deny-ink: #B42E2E;
}
* { box-sizing: border-box; }
html { scroll-behavior: smooth; }
body { margin: 0; background: var(--bg); color: var(--text); font: 17px/1.6 Geist, system-ui, sans-serif; }
code { font-family: 'Geist Mono', monospace; font-size: .86em; background: var(--accent-soft); color: var(--accent-ink); padding: 1px 6px; border-radius: 6px; }
strong { font-weight: 600; }
em { color: var(--muted); }
.wrap { max-width: 1180px; margin: 0 auto; padding: 0 24px; }

header.top { padding: 56px 0 28px; }
header.top .eyebrow { font: 500 13px 'Geist Mono', monospace; letter-spacing: .12em; text-transform: uppercase; color: var(--accent-ink); }
header.top h1 { font-size: 40px; line-height: 1.1; letter-spacing: -.03em; margin: 10px 0 12px; }
header.top .meta { color: var(--muted); }
header.top .meta p { margin: 4px 0; }

nav.toc { position: sticky; top: 0; z-index: 5; background: color-mix(in srgb, var(--bg) 88%, transparent); backdrop-filter: blur(10px); border-bottom: 1px solid var(--line); }
nav.toc .wrap { display: flex; gap: 6px; overflow-x: auto; padding-top: 10px; padding-bottom: 10px; scrollbar-width: thin; }
nav.toc a { flex: none; font: 500 13px 'Geist Mono', monospace; color: var(--muted); text-decoration: none; padding: 5px 10px; border-radius: 8px; border: 1px solid transparent; }
nav.toc a:hover { border-color: var(--line); background: var(--card); }
nav.toc a.sec { color: var(--accent-ink); }
nav.toc a.tab { margin-left: auto; color: var(--text); border-color: var(--line); background: var(--card); }

.slide { display: grid; grid-template-columns: 400px 1fr; gap: 32px; background: var(--card); border: 1px solid var(--line); border-radius: 18px; padding: 24px; margin: 20px 0; scroll-margin-top: 70px; break-inside: avoid; }
.slide img { width: 100%; border-radius: 10px; border: 1px solid var(--line); display: block; }
.slide .side { display: flex; flex-direction: column; gap: 12px; }
.chips { display: flex; gap: 8px; flex-wrap: wrap; }
.chip { font: 500 12.5px 'Geist Mono', monospace; padding: 3px 9px; border-radius: 7px; background: var(--bg); color: var(--muted); }
.chip.time { background: var(--accent-soft); color: var(--accent-ink); }
.slide h2 { font-size: 23px; letter-spacing: -.02em; margin: 0 0 6px; line-height: 1.25; }
.slide h2 .n { font: 500 15px 'Geist Mono', monospace; color: var(--dim); margin-right: 10px; }
.say p { margin: 0 0 12px; }
.say p:last-child { margin-bottom: 0; }
.say ol, .say ul { padding-left: 22px; margin: 0 0 12px; }
.say li { margin-bottom: 6px; }

.slide.section { grid-template-columns: 200px 1fr; padding: 14px 24px; align-items: center; background: transparent; border-style: dashed; }
.slide.section h2 { font-size: 19px; color: var(--accent-ink); }
.slide.section .say { color: var(--muted); }

h2.part { font-size: 30px; letter-spacing: -.025em; margin: 72px 0 6px; }
p.part-sub { color: var(--muted); margin: 0 0 18px; }
details.bg { background: var(--card); border: 1px solid var(--line); border-radius: 14px; margin: 12px 0; }
details.bg summary { cursor: pointer; padding: 16px 22px; font-weight: 600; font-size: 18px; list-style: none; }
details.bg summary::before { content: '+'; font-family: 'Geist Mono', monospace; color: var(--accent-ink); display: inline-block; width: 22px; }
details.bg[open] summary::before { content: '–'; }
details.bg .body { padding: 0 22px 18px 44px; }
table { border-collapse: collapse; width: 100%; font-size: 15px; margin: 8px 0 14px; display: block; overflow-x: auto; }
th, td { text-align: left; padding: 8px 10px; border-bottom: 1px solid var(--line); vertical-align: top; }
th { font: 500 12.5px 'Geist Mono', monospace; color: var(--dim); }
pre { background: #0F1F18; color: #DDEFE5; padding: 14px 16px; border-radius: 10px; overflow-x: auto; font-size: 14px; }
pre code { background: none; color: inherit; padding: 0; }

ul.check { list-style: none; padding: 0; }
ul.check li { background: var(--card); border: 1px solid var(--line); border-radius: 12px; padding: 12px 16px 12px 48px; margin: 8px 0; position: relative; }
ul.check li::before { content: ''; position: absolute; left: 16px; top: 15px; width: 18px; height: 18px; border: 2px solid var(--accent); border-radius: 5px; }
footer { color: var(--dim); font-size: 14px; padding: 48px 0 64px; }

@media (max-width: 860px) {
  .slide, .slide.section { grid-template-columns: 1fr; gap: 16px; padding: 16px; }
  header.top h1 { font-size: 30px; }
  .wrap { padding: 0 16px; }
}
@media print {
  @page { size: A4 landscape; margin: 12mm; }
  body { background: #fff; font-size: 13px; }
  nav.toc, details.bg summary::before { display: none; }
  .slide { grid-template-columns: 330px 1fr; border-color: #ccc; margin: 0 0 10px; padding: 14px; }
  .slide.section { padding: 8px 14px; }
  details.bg { border: 0; }
  details.bg .body { display: block; padding-left: 0; }
  h2.part { break-before: page; margin-top: 0; }
}
</style>
</head>
<body>
<header class="top"><div class="wrap">
  <div class="eyebrow">Flutter Ankara · Konuşma metni</div>
  <h1>Flutter ile Uçtan Uca Uygulama</h1>
  <div class="meta"><p>Toplam hedef süre <strong>${fmt(clock)}</strong>, soru-cevap dahil. Her kartta slaydın başlama dakikası ve süresi var; bölüm geçişlerinde (kesikli kartlar) durma.</p><p>Üstteki numaralarla slayda atla. En altta prova listesi ve konunun arka planı var.</p></div>
</div></header>

<nav class="toc"><div class="wrap">
${slides.map(s => `<a href="#s${s.n}"${s.isSection ? ' class="sec"' : ''} title="${esc(s.title)}">${s.n}</a>`).join('')}
<a class="tab" href="#arka-plan">Arka plan</a><a class="tab" href="#prova" style="margin-left:0">Prova</a>
</div></nav>

<main class="wrap">
${slides.map(s => `<section class="slide${s.isSection ? ' section' : ''}" id="s${s.n}">
  <div class="side">
    ${s.isSection ? '' : `<img src="slides/${s.n}.jpg" alt="Slayt ${s.n}" loading="lazy">`}
    <div class="chips"><span class="chip">${fmt(s.start)}'da başla</span><span class="chip time">${esc(s.timeRaw)}</span></div>
  </div>
  <div>
    <h2><span class="n">${String(s.n).padStart(2, '0')}</span>${esc(s.title)}</h2>
    <div class="say">${s.html}</div>
  </div>
</section>`).join('\n')}

<h2 class="part" id="prova">Prova kontrol listesi</h2>
<ul class="check">${checklist.map(c => `<li>${md.renderInline(c)}</li>`).join('')}</ul>

<h2 class="part" id="arka-plan">Arka plan: konuyu derinlemesine anla</h2>
<p class="part-sub">Slaytta söylenenden fazlası. Sahnede gelebilecek sorulara hazırlık için.</p>
${background.map(b => `<details class="bg"><summary>${esc(b.title)}</summary><div class="body">${b.html}</div></details>`).join('\n')}
</main>

<footer class="wrap">docs/KONUSMA.md dosyasından üretildi. Güncellemek için: <code>node docs/konusma/build.mjs</code></footer>
</body>
</html>
`

writeFileSync(join(here, 'index.html'), html)
console.log(`${slides.length} slayt, toplam ${fmt(clock)} → docs/konusma/index.html`)
