---
title: Flutter ile Uçtan Uca Uygulama
info: Flutter Ankara — Auth, Database ve Realtime
layout: cover
aspectRatio: 16/9
canvasWidth: 1280
colorSchema: dark
fonts:
  sans: Geist
  mono: Geist Mono
  provider: google
transition: fade
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
---

<div class="kicker">Flutter Ankara</div>

# Flutter ile Uçtan Uca Uygulama

Auth, Database ve <span class="text-accent">Realtime</span>

<template #meta>
  <div class="flex items-center justify-between">
    <div class="flex items-center gap-3">
      <span class="pill"><span class="text-flutter">●</span> Flutter</span>
      <span class="pill"><span class="text-accent">●</span> Supabase</span>
    </div>
    <span class="text-muted font-mono text-sm tracking-widest">POYRAZ AVSEVER</span>
  </div>
</template>

---
layout: section
number: '02'
---

# Supabase ne sağlıyor?

Soru panosunun arkasındaki beş parça.

---
kicker: Supabase ne sağlıyor?
---

## Her parçanın panoda bir karşılığı var

<div class="grid grid-cols-5 gap-5 mt-4">
  <Glass tone="accent">
    <div class="part-index">01</div>
    <h3>Database</h3>
    <p class="mt-3">Soruların saklanması</p>
  </Glass>
  <Glass tone="accent">
    <div class="part-index">02</div>
    <h3>Auth</h3>
    <p class="mt-3">Soruyu gönderen kullanıcının tanınması</p>
  </Glass>
  <Glass tone="accent">
    <div class="part-index">03</div>
    <h3>Realtime</h3>
    <p class="mt-3">Yeni soruların açık ekranlara ulaşması</p>
  </Glass>
  <Glass>
    <div class="part-index dim">04</div>
    <h3 class="text-muted">Storage</h3>
    <p class="mt-3">İleride görsel ve dosya</p>
  </Glass>
  <Glass>
    <div class="part-index dim">05</div>
    <h3 class="text-muted">Edge Functions</h3>
    <p class="mt-3">İleride gizli anahtarlı işlemler</p>
  </Glass>
</div>

<p class="mt-10 text-lg">İlk üçünü <strong>canlı göstereceğiz</strong>, son ikisinin nerede devreye girdiğini sonra konumlandıracağız.</p>

<style>
.part-index { font-family: var(--font-mono); font-size: 14px; color: var(--accent); margin-bottom: 40px; }
.part-index.dim { color: var(--text-dim); }
</style>

---
kicker: Flutter nasıl bağlanıyor?
---

## Bağlantı tek yerde kurulur

<div class="grid grid-cols-[1.4fr_1fr] gap-10 items-start">

```dart {all|4-7|10}
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://<project-ref>.supabase.co',
    anonKey: 'sb_publishable_...',
  );
  runApp(const SoruPanosu());
}

final supabase = Supabase.instance.client;
```

<div class="flex flex-col gap-4">
  <Glass pad="sm">
    <div class="text-accent font-mono text-sm mb-1">url</div>
    <p class="text-base">Projenin adresi</p>
  </Glass>
  <Glass pad="sm">
    <div class="text-accent font-mono text-sm mb-1">publishable key</div>
    <p class="text-base">İstemcide kullanılabilir, erişimi <strong>RLS</strong> sınırlar</p>
  </Glass>
  <Glass pad="sm" tone="deny">
    <div class="text-deny font-mono text-sm mb-1">secret key</div>
    <p class="text-base">Flutter uygulamasına asla konmaz</p>
  </Glass>
</div>

</div>

---
kicker: Auth ve RLS
---

## Giriş yaptı, peki ne yapabilir?

<div class="grid grid-cols-2 gap-8 mt-2">
  <Glass tone="flutter" pad="lg">
    <div class="font-mono text-sm text-flutter mb-6">ARAYÜZ</div>
    <h3>Sil butonunu gizlemek</h3>
    <p class="mt-4">Kullanıcıya ne göstereceğimize karar verir. İstek yine de gönderilebilir.</p>
  </Glass>
  <Glass tone="accent" pad="lg">
    <div class="font-mono text-sm text-accent mb-6">VERİTABANI</div>
    <h3>Silme isteğini reddetmek</h3>
    <p class="mt-4">Kural Postgres'te çalışır. İstek nereden gelirse gelsin geçerlidir.</p>
  </Glass>
</div>

<Glass tone="deny" pad="sm" class="mt-8 flex items-center gap-4">
  <span class="text-deny font-mono">⛔ 0 satır silindi</span>
  <span class="text-muted">Mehmet, Ayşe'nin sorusunu silmeye çalıştı. RLS izin vermedi.</span>
</Glass>
