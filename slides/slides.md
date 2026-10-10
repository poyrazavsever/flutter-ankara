---
title: Flutter ile Uçtan Uca Uygulama
info: Flutter Ankara — Auth, Database ve Realtime
layout: cover
image: /img/cover-a.jpg
aspectRatio: 16/9
canvasWidth: 1280
colorSchema: light
fonts:
  sans: Geist
  mono: Geist Mono
  provider: google
transition: fade
highlighter: shiki
lineNumbers: false
presenter: dev
drawings:
  persist: false
htmlAttrs:
  lang: tr
  translate: 'no'
---

# Flutter ile Uçtan Uca Uygulama

Auth, Database ve Realtime

<template #meta>
  <div class="flex items-center justify-between">
    <div class="flex items-center gap-3">
      <span class="pill"><span class="dot dot--flutter"></span> Flutter</span>
      <span class="pill"><span class="dot dot--accent"></span> Supabase</span>
    </div>
    <span class="text-dim font-mono text-sm tracking-widest">POYRAZ AVSEVER</span>
  </div>
</template>

<!--
(20 sn) Herkese iyi akşamlar, hoş geldiniz.

Bugün Flutter ile yaptığımız bir uygulamaya kullanıcı, veri ve gerçek zamanlı güncelleme kazandırmayı konuşacağız. Bunu Supabase üzerinden yapacağız.
-->

---
layout: cover
image: /img/sections/linkedin.jpg
---

<div class="intro">
  <div class="intro__eyebrow">Merhaba, ben</div>
  <h1>Poyraz Avsever</h1>
  <p class="intro__lead">Sunumdan sonra da konuşalım: LinkedIn'den bağlantı kuralım, TMUG topluluğunda buluşalım.</p>
  <div class="intro__cards">
    <div class="intro__card glass">
      <img src="/img/qr-linkedin.svg" alt="LinkedIn QR kodu">
      <div>
        <div class="intro__label">LinkedIn</div>
        <div class="intro__url">linkedin.com/in/<br>poyrazavsever</div>
      </div>
    </div>
    <div class="intro__card intro__card--tmug glass">
      <img src="/img/qr-tmug.svg" alt="TMUG QR kodu">
      <div>
        <img class="intro__logo" src="/img/icons/tmug.png" alt="TMUG">
        <div class="intro__url">tmug.com.tr</div>
      </div>
    </div>
  </div>
</div>

<style>
.intro { --li: #0A66C2; --tmug: #6D3FD9; width: 860px; }
.intro__eyebrow { font-family: var(--font-mono); font-size: 16px; letter-spacing: .12em; text-transform: uppercase; color: var(--li); margin-bottom: 14px; }
.intro h1 { font-size: 76px !important; }
.intro__lead { font-size: 26px !important; margin-top: 20px !important; max-width: 620px; }
.intro__cards { display: flex; gap: 20px; margin-top: 44px; }
.intro__card { display: flex; align-items: center; gap: 22px; padding: 18px 26px 18px 18px; width: fit-content; border-color: color-mix(in srgb, var(--li) 22%, transparent) !important; }
.intro__card--tmug { --li: var(--tmug); background: color-mix(in srgb, var(--tmug) 7%, var(--glass)) !important; }
.intro__logo { width: 104px !important; height: 104px !important; padding: 0 !important; background: none !important; margin: -12px 0 2px -14px; }
.intro__card > img { width: 148px; height: 148px; display: block; background: #fff; padding: 12px; border-radius: 14px; }
.intro__label { font-family: var(--font-mono); font-size: 14px; color: var(--li); margin-bottom: 8px; }
.intro__url { font-size: 21px; line-height: 1.25; font-weight: 600; color: var(--text); letter-spacing: -0.01em; }
</style>

<!--
(40 sn) Kısaca kendimi tanıtayım. (Ne yaptığın, Flutter ile ilişkin; 2–3 cümle.)

Sunumdan sonra soru sormak ya da sadece tanışmak isterseniz LinkedIn'den bağlantı kurabiliriz. Yanındaki mor QR da TMUG'un sitesi: topluluğa oradan katılabilirsiniz. QR'lar ekranda; sunum boyunca da sonunda da paylaşacağım.
-->

---

<div class="h-full flex flex-col justify-center">
  <div class="grid grid-cols-[1fr_auto] gap-10 items-center">
    <h1 class="thesis"><span class="text-accent">Supabase</span>'i ne kadar iyi tanırsan, sınırlarını ne kadar iyi bilirsen projeni o kadar iyi kurarsın.</h1>
    <img src="/img/icons/supabase.png" class="w-60 h-60" alt="Supabase">
  </div>
  <div class="grid grid-cols-4 gap-4 mt-12">
    <Glass pad="sm"><div class="text-dim font-mono text-sm mb-2">1</div><h3 class="text-xl">Ne yapar?</h3></Glass>
    <Glass pad="sm"><div class="text-dim font-mono text-sm mb-2">2</div><h3 class="text-xl">Nasıl çalışır?</h3></Glass>
    <Glass pad="sm"><div class="text-dim font-mono text-sm mb-2">3</div><h3 class="text-xl">Panelde nerede?</h3></Glass>
    <Glass pad="sm" tone="deny"><div class="text-deny font-mono text-sm mb-2">4</div><h3 class="text-xl">Sınırı ne?</h3></Glass>
  </div>
</div>

<style>
.thesis { font-size: 52px !important; line-height: 1.12 !important; letter-spacing: -0.035em !important; }
</style>

<!--
(40 sn) Bugünün tezi bu.

Supabase'in birçok servisi var ve hepsini kullanmak çok kolay. Ama projede sizi zorlayacak şey kolay kısım değil, sınırlar: e-posta limiti, dosya boyutu, bağlantı sayısı, hangi anahtarın nereye konduğu.

Her servisi bu dört soruyla geçeceğiz: ne yapar, nasıl çalışır, Supabase panelinde nerede duruyor ve sınırı ne. Dördüncü soru her bölümün sonunda aynı görünümde karşınıza çıkacak.
-->

---
layout: section
image: /img/sections/supabase.jpg
time: 02:00
---

# Supabase nedir?

Bir veritabanı ve etrafındaki servisler.

<!--
(5 sn) Önce büyük resme bakalım.
-->

---

## Merkezde Postgres var

<div class="map">
  <Glass class="map__api" pad="sm">
    <span class="font-mono text-sm text-accent">Data API</span>
    <span class="text-muted text-base">Tablo açtığın an Flutter'dan erişilebilir</span>
  </Glass>
  <div class="map__col">
    <Glass pad="sm" class="map__svc"><img src="/img/icons/auth.png" alt=""><div><h3>Auth</h3><p>Kullanıcılar ve oturum</p></div></Glass>
    <Glass pad="sm" class="map__svc"><img src="/img/icons/storage.png" alt=""><div><h3>Storage</h3><p>Dosyalar</p></div></Glass>
  </div>
  <Glass tone="accent" pad="lg" class="map__core">
    <img src="/img/icons/database.png" alt="">
    <h3>Postgres</h3>
    <p>Gerçek, tam bir veritabanı. Her projenin kendi örneği.</p>
  </Glass>
  <div class="map__col">
    <Glass pad="sm" class="map__svc"><img src="/img/icons/realtime.png" alt=""><div><h3>Realtime</h3><p>Anlık güncellemeler</p></div></Glass>
    <Glass pad="sm" class="map__svc"><img src="/img/icons/functions.png" alt=""><div><h3>Edge Functions</h3><p>Sunucu tarafı kod</p></div></Glass>
  </div>
</div>

<p class="mt-6 text-base">Açık kaynak. İstersen kendi sunucunda da çalıştırabilirsin.</p>

<style>
.map { display: grid; grid-template-columns: 1fr 1.1fr 1fr; grid-template-rows: auto 1fr; gap: 18px; }
.map__api { grid-column: 1 / -1; display: flex; gap: 18px; align-items: center; justify-content: center; }
.map__col { display: flex; flex-direction: column; gap: 18px; }
.map__svc { display: flex; align-items: center; gap: 14px; }
.map__svc img { width: 64px; height: 64px; }
.map__svc h3 { font-size: 22px; }
.map__svc p { font-size: 16px; }
.map__core { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; }
.map__core img { width: 110px; height: 110px; margin-bottom: 8px; }
.map__core p { font-size: 17px; margin-top: 8px; }
</style>

<!--
(1 dk 30 sn) Supabase'i "Firebase alternatifi" diye duymuş olabilirsiniz ama mimarisi farklı.

- Merkezde gerçek bir Postgres veritabanı var. Her projenin kendine ait.
- Tablo oluşturduğunuz an önünde otomatik bir API hazır oluyor. Flutter bu API ile konuşuyor, ayrı bir backend yazmıyorsunuz.
- Etrafında dört servis var: kullanıcılar için Auth, dosyalar için Storage, anlık güncellemeler için Realtime, sunucu tarafı kod için Edge Functions.

Önemli nokta: bu servislerin çoğu yine Postgres'e dayanıyor. Kullanıcılar da, dosya kayıtları da, erişim kuralları da veritabanında. O yüzden Postgres'i ve RLS'yi anlamak her şeyi anlamanın anahtarı.

Açık kaynak olduğu için istenirse kendi sunucunuzda da çalıştırılabiliyor.
-->

---
layout: section
image: /img/sections/connect.jpg
time: 04:00
---

# Flutter'a bağlanmak

Üç adım ve iki anahtar.

---

## Üç adımda bağlantı

<div class="grid grid-cols-3 gap-6">
  <Glass>
    <div class="step">1</div>
    <h3>Paketi ekle</h3>
    <p class="mt-3 text-lg"><code>supabase_flutter</code> paketi Auth, Database, Storage ve Realtime'ı tek istemcide toplar.</p>
  </Glass>
  <Glass>
    <div class="step">2</div>
    <h3>Adresi ve anahtarı al</h3>
    <p class="mt-3 text-lg">Supabase panelinden proje URL'si ve publishable key.</p>
  </Glass>
  <Glass>
    <div class="step">3</div>
    <h3>Başlat</h3>
    <p class="mt-3 text-lg">Uygulama açılırken bir kez. Sonra her yerden aynı istemci.</p>
  </Glass>
</div>

<div class="mt-8">

```dart
await Supabase.initialize(
  url: 'https://<proje>.supabase.co',
  publishableKey: 'sb_publishable_...',
);
```

</div>

<style>
.step { font-family: var(--font-mono); font-size: 14px; color: var(--accent-ink); margin-bottom: 28px; }
</style>

<!--
(1 dk) Flutter tarafı gerçekten bu kadar.

1. supabase_flutter paketini ekliyorsunuz. Auth, veritabanı, dosyalar, realtime hepsi bu paketin içinde.
2. Supabase panelinden iki şey alıyorsunuz: proje adresi ve publishable key.
3. Uygulama açılırken bir kez initialize ediyorsunuz. Sonra uygulamanın her yerinden aynı istemciyi kullanıyorsunuz.

Asıl soru şu: bu anahtar ne? Uygulamanın içine koyuyoruz, yani herkes görebilir. Bu güvenli mi?
-->

---

## Adres ve anahtar nerede?

<div class="grid grid-cols-[0.62fr_1.38fr] gap-8 items-start">
  <Shot src="/img/panel/home-url.jpg" :path="['Proje', 'Ana sayfa']" :hand="[41.9, 77]" :h="400" />
  <Shot src="/img/panel/api-keys.jpg" :path="['Project Settings', 'API Keys']" :hand="[35.2, 33.9]" :h="400" />
</div>

<!--
(40 sn) İkinci adımdaki iki değeri panelde nereden alıyorsunuz?

- Proje adresi, projenin ana sayfasında en üstte. Yanında kopyala butonu var.
- Anahtarlar Project Settings altında, API Keys sayfasında. Publishable key'i buradan kopyalıyorsunuz.

Aynı sayfada aşağıda secret key'ler duruyor ve varsayılan olarak gizli. Bir sonraki slaytta bu iki anahtarın farkını konuşacağız.
-->

---

## Anahtarlar ne işe yarar?

<div class="grid grid-cols-3 gap-6">
  <Glass>
    <div class="font-mono text-sm text-dim mb-6">URL</div>
    <h3>Projenin adresi</h3>
    <p class="mt-3 text-lg">İsteklerin gideceği yer. Gizli değil.</p>
  </Glass>
  <Glass tone="accent">
    <div class="font-mono text-sm text-accent mb-6">sb_publishable_…</div>
    <h3>Publishable key</h3>
    <p class="mt-3 text-lg">Uygulamaya gömülür, herkes görebilir. <strong>Kimseyi yetkilendirmez.</strong> Neyin görüleceğine RLS karar verir.</p>
  </Glass>
  <Glass tone="deny">
    <div class="font-mono text-sm text-deny mb-6">sb_secret_…</div>
    <h3>Secret key</h3>
    <p class="mt-3 text-lg"><strong>RLS'yi atlar.</strong> Yalnızca sunucuda ve Edge Functions'ta. Flutter uygulamasına asla.</p>
  </Glass>
</div>

<Glass pad="sm" class="mt-8 flex items-center gap-4">
  <span class="font-mono text-sm text-dim">Eski adları</span>
  <span class="text-muted text-lg"><code>anon</code> = publishable · <code>service_role</code> = secret</span>
</Glass>

<!--
(1 dk) Üç değer var, üçünün de görevi farklı.

- URL sadece adres, gizli bir şey değil.
- Publishable key uygulamanın içine gömülüyor. APK'yı açan herkes bunu görebilir ve bu sorun değil. Çünkü bu anahtar kimseyi yetkilendirmiyor, sadece "bu proje için gelen bir istek" diyor. Kimin neyi görebileceğine veritabanındaki kurallar, yani RLS karar veriyor.
- Secret key ise tam yetkili. RLS'yi atlıyor. Bu yüzden sadece sunucuda ya da Edge Functions içinde durur. Flutter uygulamasına konursa uygulamayı indiren herkes veritabanınızın tamamına erişir.

Eski projelerde ve eğitimlerde anon ve service_role adlarını göreceksiniz. Aynı roller, yeni adları bunlar.
-->

---
layout: section
image: /img/sections/database.jpg
time: 06:00
---

# Database

Gerçek Postgres, otomatik API, kurallar veritabanında.

---

## Tablo aç, API hazır

<div class="grid grid-cols-3 gap-5">
  <Glass pad="sm"><h3 class="text-xl">Gerçek Postgres</h3><p class="mt-2 text-lg">İlişkiler, indeksler, fonksiyonlar, eklentiler. Bildiğin SQL.</p></Glass>
  <Glass pad="sm"><h3 class="text-xl">Otomatik Data API</h3><p class="mt-2 text-lg">Tablo oluşturduğun an Flutter'dan okunup yazılabilir.</p></Glass>
  <Glass pad="sm"><h3 class="text-xl">Table Editor</h3><p class="mt-2 text-lg">Tabloları tarayıcıdan, tablo düzenler gibi yönet.</p></Glass>
</div>

<div class="mt-6">
  <Shot src="/img/panel/editor.jpg" :path="['Table Editor', 'questions']" :hand="[74.5, 20.5]" :h="270" />
</div>

<!--
(1 dk) Supabase'in veritabanı gerçek bir Postgres. Bildiğiniz her şey geçerli: ilişkiler, indeksler, fonksiyonlar, pgvector gibi eklentiler.

Fark şurada: tabloyu oluşturduğunuz anda önünde bir API hazır. Flutter'dan "questions tablosuna şunu ekle", "son 50 soruyu getir" diyebiliyorsunuz. Ayrı bir sunucu yazmıyorsunuz.

Örnek tablomuz basit: kim sordu, ne sordu, ne zaman sordu. Uzunluk kontrolü bile veritabanında: 280 karakterden uzun soru kaydedilmiyor.

Ama burada bir soru doğuyor: API herkese açıksa, birinin başkasının sorusunu silmesini ne engelliyor?
-->

---

## RLS: kapı veritabanında

<div class="grid grid-cols-[1fr_1.15fr] gap-10 items-start">
  <div class="flex flex-col gap-4">
    <Glass pad="sm" class="rule"><span class="rule__n">1</span><span>Giriş yapan herkes soruları <strong>okuyabilir</strong></span></Glass>
    <Glass pad="sm" class="rule"><span class="rule__n">2</span><span>Yalnızca <strong>kendi adına</strong> soru ekleyebilir</span></Glass>
    <Glass pad="sm" class="rule" tone="accent"><span class="rule__n">3</span><span>Yalnızca <strong>kendi sorusunu</strong> silebilir</span></Glass>
  </div>
  <div>

```sql
create policy "Kendi sorusunu silebilir"
on questions for delete
to authenticated
using ( auth.uid() = user_id );
```

  <p class="mt-6 text-lg">Sil butonunu gizlemek <strong>arayüz davranışıdır</strong>.<br>Silme isteğini reddetmek <strong>erişim kontrolüdür</strong>.</p>
  </div>
</div>

<Glass tone="deny" pad="sm" class="mt-8 flex items-center gap-4">
  <span class="text-deny font-mono">0 satır silindi</span>
  <span class="text-muted text-lg">Başkasının sorusunu silmeye çalışınca <strong>hata gelmez</strong>, işlem sessizce boşa düşer. Sonucu kontrol et.</span>
</Glass>

<style>
.rule { display: flex; align-items: center; gap: 16px; font-size: 20px; color: var(--text-muted); }
.rule__n { font-family: var(--font-mono); font-size: 14px; color: var(--accent-ink); }
</style>

<!--
(1 dk 30 sn) Cevap: Row Level Security, kısaca RLS. Satır bazında erişim kuralları ve bu kurallar veritabanında çalışıyor.

Örnek bir soru tablosu için üç kural: giriş yapan herkes okuyabilir, herkes sadece kendi adına soru ekleyebilir, herkes sadece kendi sorusunu silebilir.

Üçüncü kural SQL'de böyle görünüyor. "Silmek isteyen kullanıcının kimliği, satırdaki user_id ile aynıysa izin ver." auth.uid() o anki kullanıcıyı veriyor. Bunu birazdan Auth'ta tekrar göreceğiz.

Buradaki ana mesaj: Flutter'da Sil butonunu sadece kendi sorunuzda göstermek güzel bir arayüz davranışı ama güvenlik değil. Biri isteği kendisi gönderebilir. Asıl kapı veritabanında.

Bir de tuzak var. Başkasının sorusunu silmeye çalıştığınızda hata almıyorsunuz. Kural o satırı görünmez yapıyor ve işlem 0 satırı etkiliyor. Bunu bu projede gerçek istekle denedim. Yani "hata gelmedi, demek ki silindi" diye düşünmeyin; dönen sonucu kontrol edin.
-->

---

## Kurallar panelde

<Shot src="/img/panel/policies.jpg" :path="['Database', 'Policies', 'questions']" :hand="[13.3, 74.4]" :h="440" />

<!--
(40 sn) Yazdığımız üç kural panelde Database altında, Policies sayfasında tablo tablo listeleniyor. Kuralı buradan arayüzle de oluşturabilirsiniz; Supabase hazır şablonlar da sunuyor.

Tablonun yanındaki "Disable RLS" butonuna dikkat: RLS bir tık uzakta. Kapatırsanız tablo publishable key'i bilen herkese açılır.
-->

---
layout: limits
service: Database
icon: database
---

<Limit value="RLS kapalı">Kural yazılmamış tablo, publishable key'i bilen herkese açık bir kapıdır. <strong>Security Advisor</strong> uyarır; her tabloda RLS açık olsun.</Limit>
<Limit value="500 MB">Ücretsiz planda veritabanı boyutu. <strong>Otomatik yedekleme yok.</strong></Limit>
<Limit value="1 hafta">Hareketsiz kalan ücretsiz proje <strong>duraklatılır</strong>. Aynı anda en fazla 2 aktif ücretsiz proje.</Limit>

<!--
(30 sn) İlk "sınırlar" slaydımız. Her serviste bu görünümle karşılaşacaksınız.

- En önemlisi: RLS'si kapalı bir tablo, publishable key'i bilen herkese açık. Supabase panelindeki Security Advisor bunu yakalar, düzenli çalıştırın.
- Ücretsiz planda 500 MB veritabanı var ve otomatik yedek yok.
- Bir hafta kullanılmayan ücretsiz proje duraklatılıyor. Demo projeniz sunumdan önce uyumuş olabilir, buna dikkat edin.
-->

---
layout: section
image: /img/sections/auth.jpg
time: 09:00
---

# Auth

Bu kullanıcı kim?

---

## Giriş yöntemleri ve oturum

<div class="grid grid-cols-[1.1fr_1fr] gap-10 items-start">
  <div>
    <div class="grid grid-cols-2 gap-3">
      <div class="pill auth-pill">E-posta + şifre</div>
      <div class="pill auth-pill">Magic link</div>
      <div class="pill auth-pill">Tek kullanımlık kod (OTP)</div>
      <div class="pill auth-pill">Google, Apple, GitHub…</div>
      <div class="pill auth-pill">Anonim giriş</div>
      <div class="pill auth-pill">İki adımlı doğrulama (MFA)</div>
    </div>
    <p class="mt-8 text-lg">Kullanıcılar <code>auth.users</code> tablosunda durur. Profil gibi ek bilgiler için kendi tablonu bağlarsın.</p>
  </div>
  <Glass tone="accent" pad="lg">
    <div class="flow">
      <div class="flow__step"><span class="font-mono text-sm text-dim">giriş</span><span>Kullanıcı giriş yapar</span></div>
      <div class="flow__arrow">↓</div>
      <div class="flow__step"><span class="font-mono text-sm text-dim">oturum</span><span>İstemci bir <strong>JWT</strong> taşır</span></div>
      <div class="flow__arrow">↓</div>
      <div class="flow__step"><span class="font-mono text-sm text-accent">RLS</span><span><code>auth.uid()</code> = bu kullanıcı</span></div>
    </div>
  </Glass>
</div>

<style>
.auth-pill { font-family: var(--font-sans); font-size: 17px; padding: 12px 18px; border-radius: 14px; justify-content: flex-start; }
.flow { display: flex; flex-direction: column; gap: 6px; }
.flow__step { display: flex; flex-direction: column; gap: 4px; font-size: 20px; color: var(--text-muted); }
.flow__arrow { color: var(--text-dim); padding-left: 4px; }
</style>

<!--
(1 dk 30 sn) Authentication sorusu: bu kullanıcı kim? Authorization sorusu ise: bu kullanıcı ne yapabilir? İkincisine RLS cevap veriyordu, birincisine Auth.

Supabase'te hazır gelen giriş yöntemleri: e-posta ve şifre, e-postaya gelen link, tek kullanımlık kod, Google, Apple, GitHub gibi sağlayıcılar, anonim giriş ve iki adımlı doğrulama.

Bağlantı şöyle: kullanıcı giriş yapınca istemci bir oturum alıyor. Bu oturum bir JWT. Sonraki her istekte bu token gidiyor ve veritabanındaki auth.uid() bu kullanıcıyı gösteriyor. Yani az önceki RLS kuralı ile Auth burada birleşiyor.

Flutter tarafında oturumu paket yönetiyor; token yenileme, saklama gibi işleri siz yazmıyorsunuz.
-->

---

## Giriş yöntemleri panelde

<Shot src="/img/panel/providers.jpg" :path="['Authentication', 'Sign In / Providers']" :hand="[90.7, 24.5]" :h="440" />

<!--
(40 sn) Giriş yöntemleri Authentication altında, Sign In / Providers sayfasında. E-posta varsayılan olarak açık; Apple, Google, GitHub gibi sağlayıcıları buradan açıp anahtarlarını giriyorsunuz.

Her sağlayıcının yanında "Enabled / Disabled" durumu var; tıklayınca o sağlayıcının anahtarlarını girdiğiniz ayar penceresi açılıyor.
-->

---

## E-posta limiti panelde

<Shot src="/img/panel/rate-limits.jpg" :path="['Authentication', 'Rate Limits']" :hand="[60.9, 47.1]" :h="330" />

<!--
(30 sn) Aynı bölümde Rate Limits sayfası. İlk satıra dikkat: saatte 2 e-posta. Bu değeri hazır e-posta sağlayıcısıyla değiştiremiyorsunuz; kendi SMTP sağlayıcınızı bağlayınca yükseltebiliyorsunuz. Birazdan sınırlar slaytında neden önemli olduğunu konuşacağız.
-->

---
layout: limits
service: Auth
icon: auth
---

<Limit value="2 e-posta/saat">Hazır e-posta sağlayıcısı yalnızca deneme içindir. Gerçek projede <strong>kendi SMTP'ni bağla</strong> (Resend, SES, Postmark…).</Limit>
<Limit value="Deep link">Mobilde OAuth ve e-posta doğrulaması uygulamaya geri dönmek için <strong>redirect URL ve deep link</strong> ayarı ister.</Limit>
<Limit value="50.000" tone="neutral">Ücretsiz planda aylık aktif kullanıcı. Toplam kullanıcı sayısı sınırsız.</Limit>

<!--
(1 dk) Auth'un en çok can yakan sınırı ilki: Supabase'in hazır e-posta sağlayıcısı saatte sadece 2 e-posta gönderiyor. Kayıt onayı, şifre sıfırlama, magic link, hepsi buna dahil. Lansman günü 50 kişi kayıt olursa 48'i e-posta alamaz. Gerçek projede mutlaka kendi SMTP sağlayıcınızı bağlayın.

İkincisi mobil özel: Google ile giriş ya da e-postadaki link, kullanıcıyı uygulamaya geri getirmeli. Bunun için redirect URL ve deep link ayarı gerekiyor. Unutulursa link tarayıcıda açılıp kalıyor.

Ücretsiz planda aylık 50 bin aktif kullanıcı var; çoğu proje için fazlasıyla yeterli.
-->

---
layout: section
image: /img/sections/storage.jpg
time: 12:00
---

# Storage

Dosyalar ve onlara kimin erişeceği.

---

## Bucket'lar ve erişim

<div class="grid grid-cols-2 gap-8">
  <Glass pad="lg">
    <div class="font-mono text-sm text-dim mb-6">Public bucket</div>
    <h3>Herkes URL ile görür</h3>
    <p class="mt-4 text-lg">Profil fotoğrafı, etkinlik afişi gibi zaten herkese açık dosyalar.</p>
  </Glass>
  <Glass tone="accent" pad="lg">
    <div class="font-mono text-sm text-accent mb-6">Private bucket</div>
    <h3>Erişimi yine RLS belirler</h3>
    <p class="mt-4 text-lg">Dosya kayıtları da Postgres'te. Paylaşmak için süreli <strong>imzalı URL</strong> üretilir.</p>
  </Glass>
</div>

<Glass pad="sm" class="mt-8 flex items-center gap-4">
  <img src="/img/icons/storage.png" class="w-12 h-12" alt="">
  <span class="text-muted text-lg">Örnek kural: "Kullanıcı yalnızca <strong>kendi klasörüne</strong> dosya yükleyebilir." Az önceki RLS mantığının aynısı.</span>
</Glass>

<!--
(1 dk 15 sn) Diyelim ki kullanıcılar sorularına ekran görüntüsü eklemek istiyor. Burada Storage devreye giriyor.

Dosyalar bucket denen klasörlerde duruyor. İki tür var:
- Public bucket: URL'yi bilen herkes görür. Profil fotoğrafı, afiş gibi zaten açık dosyalar için.
- Private bucket: erişimi yine RLS kuralları belirliyor. Çünkü dosyaların kayıtları da Postgres'te bir tabloda tutuluyor. Yani "kullanıcı sadece kendi klasörüne yükleyebilir" kuralını az önceki SQL mantığıyla yazıyorsunuz.

Private dosyayı birine göstermek için süreli, imzalı bir URL üretiyorsunuz. Süre dolunca link çalışmıyor.
-->

---

## Bucket'lar panelde

<Shot src="/img/panel/storage.jpg" :path="['Storage', 'Files', 'Buckets']" :hand="[18.5, 80.5]" :h="430" />

<!--
(30 sn) Storage sayfasında bucket'lar listeleniyor. Örnek projede iki tane var: private attachments ve PUBLIC etiketli public-assets. Yeni bucket oluştururken public olup olmayacağını, dosya boyutu sınırını ve izin verilen dosya türlerini seçiyorsunuz. Erişim kuralları da yine Policies sekmesinde.
-->

---
layout: limits
service: Storage
icon: storage
---

<Limit value="50 MB">Ücretsiz planda dosya başına üst sınır. Büyük dosyalar için parçalı (resumable) yükleme var.</Limit>
<Limit value="1 GB · 5 GB">Ücretsiz planda <strong>depolama</strong> ve <strong>trafik</strong>. Videolar ve büyük görseller trafiği çabuk tüketir.</Limit>
<Limit value="Ücretli">Görselleri anında boyutlandırma (image transformations) <strong>ücretsiz planda yok</strong>. Küçük resmi istemcide üretmeyi düşün.</Limit>

<!--
(1 dk 15 sn) Storage'ın sınırları:

- Ücretsiz planda dosya başına 50 MB. Telefondan çekilen bir video bunu kolayca aşar.
- Toplam 1 GB depolama ve 5 GB trafik var. Trafik daha çabuk biter: 2 MB'lık bir görseli 2500 kez göstermek 5 GB demek.
- Görselleri sunucuda küçültme özelliği ücretli planlarda. Ücretsiz planda yüklemeden önce Flutter tarafında sıkıştırmak iyi bir alışkanlık.
-->

---
layout: section
image: /img/sections/realtime.jpg
time: 14:30
---

# Realtime

Ekranı yenilemeden güncellemek.

---

## Üç mod, üç ihtiyaç

<div class="grid grid-cols-3 gap-6">
  <Glass tone="accent" class="mode">
    <img src="/img/icons/changes.png" alt="">
    <div class="font-mono text-sm text-accent">Postgres Changes</div>
    <h3>Tablodaki değişikliği dinle</h3>
    <p>Kalıcı veri. Yeni mesaj, sipariş durumu, güncellenen skor.</p>
  </Glass>
  <Glass class="mode">
    <img src="/img/icons/broadcast.png" alt="">
    <div class="font-mono text-sm text-dim">Broadcast</div>
    <h3>İstemciler arası mesaj</h3>
    <p>Anlık sinyal, veritabanına yazılmaz. "Yazıyor…", imleç konumu, oyun hamlesi.</p>
  </Glass>
  <Glass class="mode">
    <img src="/img/icons/presence.png" alt="">
    <div class="font-mono text-sm text-dim">Presence</div>
    <h3>Kim çevrimiçi?</h3>
    <p>Paylaşılan durum. Çevrimiçi kullanıcılar, odadaki kişi sayısı.</p>
  </Glass>
</div>

<style>
.mode { display: flex; flex-direction: column; gap: 10px; }
.mode img { width: 104px; height: 104px; margin: -10px 0 4px -12px; }
.mode p { font-size: 18px; margin-top: 4px; }
</style>

<!--
(1 dk 30 sn) Realtime üç farklı şey yapıyor ve hangisini seçtiğiniz önemli.

- Postgres Changes: tablodaki değişikliği dinliyorsunuz. Kalıcı olması gereken veri için: yeni bir mesaj, siparişin durumu, güncellenen skor. Flutter'da stream ile tek satır.
- Broadcast: istemciler arasında hızlı mesaj, veritabanına uğramadan. "Yazıyor…" göstergesi, ortak bir dokümanda imleç konumu, oyundaki hamle. Kaydetmeye gerek yok, anlık olsun yeter.
- Presence: paylaşılan durum. Kim çevrimiçi, odada kaç kişi var.

Sık yapılan hata her şeyi Postgres Changes ile yapmak. "Yazıyor…" bilgisini tabloya yazıp dinlerseniz veritabanını gereksiz yere yorarsınız.
-->

---

## Realtime'ı tabloya açmak

<Shot src="/img/panel/publications.jpg" :path="['Database', 'Publications', 'supabase_realtime']" :hand="[42.8, 63.7]" :h="300" />

<p class="mt-6 text-lg">Flutter tarafında tek satır: <code>.stream(primaryKey: ['id'])</code> listeyi canlı tutar.</p>

<!--
(40 sn) Postgres Changes'in çalışması için tablonun supabase_realtime yayınına eklenmesi gerekiyor. Panelde Database altında Publications sayfası. Hangi olayların (ekleme, güncelleme, silme) yayınlanacağını ve hangi tabloların dahil olduğunu buradan görüyorsunuz.

Flutter tarafı ise tek satır: stream ile listeyi dinliyorsunuz, değişiklik gelince widget kendiliğinden yeniden çiziliyor.
-->

---
layout: limits
service: Realtime
icon: realtime
---

<Limit value="Yayına ekle">Tablo <strong>Realtime yayınına eklenmezse</strong> hiçbir değişiklik gelmez, hata da gelmez.</Limit>
<Limit value="Ölçek">Postgres Changes RLS'ye uyar ama her değişiklik her abone için kontrol edilir. Çok kalabalık odalarda <strong>Broadcast</strong>'i düşün.</Limit>
<Limit value="200 · 2M">Ücretsiz planda <strong>eşzamanlı bağlantı</strong> ve <strong>aylık mesaj</strong>. Mesaj başına en fazla 256 KB.</Limit>

<!--
(1 dk) Realtime'ın sınırları:

- En sık yaşanan: tabloyu Realtime yayınına eklemeyi unutmak. Kod doğru, ama hiçbir şey gelmiyor ve hata da yok. Bizim migration dosyamızda bu tek bir satır.
- Postgres Changes güvenli: RLS'ye uyuyor, kullanıcı göremeyeceği satırın değişikliğini almıyor. Ama bunun bedeli var; her değişiklik her abone için kontrol ediliyor. Bin kişilik bir odada Broadcast daha uygun.
- Ücretsiz planda aynı anda 200 bağlantı. Bu salondaki herkes panoyu açsa sınıra yaklaşırız.
-->

---
layout: section
image: /img/sections/functions.jpg
time: 17:00
---

# Edge Functions

Sunucu gerektiğinde.

---

## Gizli anahtar gereken her iş

<div class="grid grid-cols-[1fr_1.1fr] gap-10 items-center">
  <div class="flex flex-col gap-4">
    <Glass pad="sm" class="rule"><span>Yapay zekâ servisi çağırmak</span></Glass>
    <Glass pad="sm" class="rule"><span>Ödeme almak</span></Glass>
    <Glass pad="sm" class="rule"><span>E-posta veya bildirim göndermek</span></Glass>
    <Glass pad="sm" class="rule"><span>Dış servislerden webhook almak</span></Glass>
  </div>
  <Glass tone="accent" pad="lg">
    <img src="/img/icons/functions.png" class="w-20 h-20 mb-4" alt="">
    <h3>TypeScript ile yazılır, kullanıcıya yakın çalışır</h3>
    <p class="mt-4 text-lg">Flutter fonksiyonu çağırır. Gizli anahtar fonksiyonun içinde kalır, uygulamaya hiç inmez.</p>
    <p class="mt-6 text-lg"><strong>Örnek:</strong> Kullanıcının yazdığı metni bir yapay zekâ servisiyle özetlemek.</p>
  </Glass>
</div>

<style>
.rule { display: flex; align-items: center; gap: 16px; font-size: 20px; color: var(--text); }
</style>

<!--
(1 dk) Şimdiye kadar her şeyi Flutter'dan doğrudan yaptık. Peki ne zaman bir sunucu gerekir? Cevap basit: gizli bir anahtar gerektiğinde.

Yapay zekâ servisi, ödeme, e-posta, bildirim, dış servislerden gelen webhook'lar. Bunların hepsinin bir gizli anahtarı var ve o anahtar Flutter uygulamasına giremez.

Edge Functions burada devreye giriyor. TypeScript ile küçük fonksiyonlar yazıyorsunuz, kullanıcıya yakın sunucularda çalışıyor. Flutter fonksiyonu çağırıyor, anahtar fonksiyonun içinde kalıyor.

Örnek: kullanıcının yazdığı metni bir yapay zekâ servisine gönderip özet çıkarmak. Anahtar Edge Function'da, Flutter sadece "özetle" diyor.
-->

---

## Fonksiyonlar panelde

<Shot src="/img/panel/functions.jpg" :path="['Edge Functions', 'Functions']" :hand="[87.8, 14.6]" :h="430" />

<!--
(30 sn) Edge Functions sayfasından üç yolla fonksiyon oluşturabiliyorsunuz: tarayıcıdaki editörle, yapay zekâ asistanıyla ya da CLI ile. Gizli anahtarlar ise soldaki Secrets sekmesinde; fonksiyon kodunda ortam değişkeni olarak okunuyor, uygulamaya hiç inmiyor.
-->

---
layout: limits
service: Edge Functions
icon: functions
---

<Limit value="2 sn CPU">İstek başına işlemci süresi. Bekleme (ağ, veritabanı) buna dahil değil. Ağır hesaplama için uygun değil.</Limit>
<Limit value="150 sn">Ücretsiz planda bir fonksiyonun en uzun çalışma süresi (ücretli planda 400 sn). <strong>Uzun işler için kuyruk</strong> düşün.</Limit>
<Limit value="500.000" tone="neutral">Ücretsiz planda aylık çağrı. 256 MB bellek.</Limit>

<!--
(1 dk) Edge Functions kısa ve hızlı işler için.

- İstek başına 2 saniye işlemci süresi var. Dikkat: bir yapay zekâ servisinden cevap beklemek buna sayılmıyor, çünkü o sırada işlemci boşta. Ama video işlemek gibi ağır hesaplama uygun değil.
- Ücretsiz planda bir fonksiyon en fazla 150 saniye çalışabiliyor. Daha uzun işler için bir kuyruk sistemi düşünmek gerekiyor.
- Ayda 500 bin çağrı ücretsiz.
-->

---
layout: section
image: /img/sections/mcp.jpg
time: 19:00
---

# Supabase MCP

Projeyi yapay zekâ asistanıyla yönetmek.

---

## Asistan neler yapabilir?

<div class="grid grid-cols-[1fr_1.2fr] gap-10 items-center">
  <Glass tone="accent" pad="lg" class="text-center">
    <img src="/img/icons/mcp.png" class="w-24 h-24 mx-auto mb-4" alt="">
    <h3>Model Context Protocol</h3>
    <p class="mt-3 text-lg">Claude, Cursor gibi asistanları Supabase projene bağlayan standart.</p>
  </Glass>
  <div class="grid grid-cols-2 gap-3">
    <Glass pad="sm" class="cap">Tabloları listele</Glass>
    <Glass pad="sm" class="cap">Migration uygula</Glass>
    <Glass pad="sm" class="cap">SQL çalıştır</Glass>
    <Glass pad="sm" class="cap">Güvenlik denetimi</Glass>
    <Glass pad="sm" class="cap">Log sorgula</Glass>
    <Glass pad="sm" class="cap">Edge Function yayınla</Glass>
    <Glass pad="sm" class="cap">Tip üret</Glass>
    <Glass pad="sm" class="cap">Dokümanda ara</Glass>
  </div>
</div>

<style>
.cap { font-size: 19px; color: var(--text); }
</style>

<!--
(1 dk 30 sn) Son servis aslında bir servis değil, bir çalışma şekli.

MCP, yapay zekâ asistanlarını dış sistemlere bağlayan bir standart. Supabase'in resmi bir MCP sunucusu var. Claude, Cursor gibi bir asistana bağladığınızda ona doğal dille "questions tablosu oluştur, RLS kurallarını yaz, güvenlik denetimini çalıştır" diyebiliyorsunuz.

Asistan tabloları listeleyebiliyor, migration uygulayabiliyor, SQL çalıştırabiliyor, Security Advisor'ı çalıştırabiliyor, logları sorgulayabiliyor, Edge Function yayınlayabiliyor ve Supabase dokümanında arama yapabiliyor.

Bu sunumun Supabase projesi de bir asistanla kuruldu: tablo, kurallar, demo hesapları ve kuralların gerçek isteklerle testi.
-->

---

## Asistanı panelden bağla

<Shot src="/img/panel/home-mcp.jpg" :path="['Proje', 'Ana sayfa', 'Get connected', 'MCP']" :hand="[74.6, 66.7]" :h="200" />

<div class="grid grid-cols-3 gap-5 mt-8">
  <Glass pad="sm"><div class="font-mono text-sm text-accent mb-2">adres</div><p class="text-lg">mcp.supabase.com/mcp</p></Glass>
  <Glass pad="sm"><div class="font-mono text-sm text-accent mb-2">giriş</div><p class="text-lg">Tarayıcıda Supabase hesabınla onaylarsın</p></Glass>
  <Glass pad="sm"><div class="font-mono text-sm text-accent mb-2">ayarlar</div><p class="text-lg">Salt okuma, tek proje, araç grupları</p></Glass>
</div>

<!--
(40 sn) Bağlamak için projenin ana sayfasındaki "Get connected" bölümünde MCP kartı var. Hangi asistanı kullandığınızı seçiyorsunuz, size hazır bir yapılandırma veriyor.

Adres mcp.supabase.com/mcp. Kişisel anahtar oluşturmanıza gerek yok; tarayıcıda Supabase hesabınızla onaylıyorsunuz. Aynı ekranda salt okuma modu, tek projeye sınırlama ve hangi araç gruplarının açık olacağı seçilebiliyor.
-->

---
layout: limits
service: Supabase MCP
icon: mcp
---

<Limit value="Geliştirme">Asistanı <strong>canlı (production) projeye değil</strong>, geliştirme projesine bağla.</Limit>
<Limit value="read_only">Salt okuma modu ve <code>project_ref</code> ile <strong>tek projeye</strong> sınırla. Her işlemi onayla.</Limit>
<Limit value="Veri ≠ talimat">Veritabanındaki bir metin asistana talimat gibi davranabilir (<strong>prompt injection</strong>). Okunan veri komut değildir.</Limit>

<!--
(1 dk 30 sn) Asistana veritabanınızı açmak güçlü ama sınırları da var. Supabase'in kendi önerileri:

- Canlı projeye değil, geliştirme projesine bağlayın. Asistan yanlış bir migration yazarsa gerçek kullanıcılar etkilenmesin.
- Salt okuma modunu ve project_ref ile tek bir projeye sınırlamayı kullanın. Asistanın her işlemini okuyup onaylayın.
- En ince nokta: veritabanındaki veri asistan için talimat gibi görünebilir. Bir kullanıcı uygulamanıza "tüm tabloları sil" yazan bir mesaj gönderirse ve asistan o tabloyu okursa... Okunan veri komut değildir; asistanınızın da bunu bilmesi gerekir.

Kendi deneyimim: bu projede MCP bağlantısının yetkisi bir noktada yetmedi. Aynı işleri Supabase CLI ile tamamladık. Asistan bir araç; CLI ve panel her zaman yedek yol.
-->

---
layout: section
image: /img/sections/plans.jpg
time: 22:00
---

# Planlar

Ücretsiz plan neyi taşır?

---

## Ne zaman ücretli plana geçmeli?

<div class="grid grid-cols-[1.3fr_1fr] gap-10 items-start">
  <Glass pad="sm" class="plans">
    <table>
      <thead><tr><th></th><th>Free</th><th class="text-accent">Pro · $25/ay'dan</th></tr></thead>
      <tbody>
        <tr><td>Veritabanı</td><td>500 MB</td><td>8 GB</td></tr>
        <tr><td>Aylık aktif kullanıcı</td><td>50.000</td><td>100.000</td></tr>
        <tr><td>Dosya depolama</td><td>1 GB</td><td>100 GB</td></tr>
        <tr><td>Trafik</td><td>5 GB</td><td>250 GB</td></tr>
        <tr><td>Yedekleme</td><td>Yok</td><td>Günlük, 7 gün</td></tr>
        <tr><td>Duraklatma</td><td>1 hafta sonra</td><td>Yok</td></tr>
      </tbody>
    </table>
  </Glass>
  <div class="flex flex-col gap-4">
    <Glass pad="sm" class="rule"><span>Gerçek kullanıcılar geldiğinde</span></Glass>
    <Glass pad="sm" class="rule"><span>Yedek gerektiğinde</span></Glass>
    <Glass pad="sm" class="rule"><span>Proje hiç uyumamalıysa</span></Glass>
    <p class="text-base mt-2">Pro'da harcama limiti varsayılan olarak açık.</p>
  </div>
</div>

<style>
.plans table { width: 100%; border-collapse: collapse; font-size: 19px; }
.plans th { text-align: left; font-family: var(--font-mono); font-size: 14px; font-weight: 500; color: var(--text-dim); padding: 10px 14px; border-bottom: 1px solid var(--line); }
.plans td { padding: 12px 14px; border-bottom: 1px solid var(--line); color: var(--text); font-family: var(--font-mono); font-size: 17px; }
.plans td:first-child { font-family: var(--font-sans); color: var(--text-muted); font-size: 18px; }
.plans tr:last-child td { border-bottom: 0; }
.rule { font-size: 19px; color: var(--text); }
</style>

<!--
(1 dk 30 sn) Kısaca fiyatlar. Ücretsiz plan öğrenmek ve küçük projeler için gerçekten cömert: 500 MB veritabanı, 50 bin aylık kullanıcı, 1 GB dosya.

Pro ayda 25 dolardan başlıyor. Ne zaman geçmeli?
- Gerçek kullanıcılar geldiğinde, çünkü ücretsiz planda yedek yok.
- Projenin uyumaması gerektiğinde; ücretsiz proje bir hafta hareketsizlikte duraklatılıyor.

İçiniz rahat olsun: Pro'da harcama limiti varsayılan olarak açık, sürpriz fatura gelmiyor.

Bu rakamları Supabase'in fiyat sayfasından Ekim 2026'da kontrol ettim; değişebilir, kendi projeniz için tekrar bakın.
-->

---

## Kendi projene başlarken

<div class="checklist">
  <Glass pad="sm"><span class="n">01</span>Veri modelini tasarla</Glass>
  <Glass pad="sm"><span class="n">02</span>Giriş yöntemini seç, SMTP'yi bağla</Glass>
  <Glass pad="sm" tone="accent"><span class="n">03</span>Her tabloda RLS ve kurallar</Glass>
  <Glass pad="sm"><span class="n">04</span>Publishable key uygulamaya, secret key sunucuya</Glass>
  <Glass pad="sm"><span class="n">05</span>Gerekiyorsa Realtime ve Storage</Glass>
  <Glass pad="sm"><span class="n">06</span>Gizli işler Edge Function'a</Glass>
  <Glass pad="sm"><span class="n">07</span>İki farklı kullanıcıyla dene</Glass>
  <Glass pad="sm" tone="accent"><span class="n">08</span>Security Advisor'ı çalıştır</Glass>
</div>

<style>
.checklist { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.checklist .glass { display: flex; align-items: center; gap: 18px; font-size: 21px; color: var(--text); }
.checklist .n { font-family: var(--font-mono); font-size: 14px; color: var(--accent-ink); }
</style>

<!--
(1 dk) Kendi projenizde izleyebileceğiniz sıra bu. Özellikle üç ve sekiz: her tabloda RLS ve en sonda Security Advisor. Yedinci madde de önemli: izin verilen işlemleri değil, reddedilmesi gerekenleri de iki farklı kullanıcıyla deneyin. Bizim "0 satır silindi" bulgumuz böyle çıktı.
-->

---

## Örnek proje

<div class="grid grid-cols-2 gap-8">
  <Glass tone="accent" pad="lg" class="link">
    <img src="/img/qr-demo.svg" alt="Canlı demo QR kodu">
    <div>
      <div class="link__label text-accent">Canlı demo · soru sor</div>
      <h3>Soru Panosu</h3>
      <p class="link__url">flutter-demo.poyrazavsever.com</p>
      <p class="mt-3 text-base">Adını yaz, katıl, sorunu gönder. Herkesin ekranına anında düşer.</p>
    </div>
  </Glass>
  <Glass pad="lg" class="link">
    <img src="/img/qr-repo.svg" alt="GitHub QR kodu">
    <div>
      <div class="link__label text-dim">Kaynak kod</div>
      <h3>GitHub</h3>
      <p class="link__url">github.com/poyrazavsever/flutter-ankara</p>
      <p class="mt-3 text-base">Flutter uygulaması, Supabase migration'ı ve bu sunum. README ile 5 dakikada çalıştır.</p>
    </div>
  </Glass>
</div>

<style>
.link { display: flex; flex-direction: column; gap: 24px; }
.link img { width: 220px; height: 220px; display: block; background: #fff; padding: 14px; border-radius: 16px; }
.link__label { font-family: var(--font-mono); font-size: 14px; margin-bottom: 8px; }
.link h3 { font-size: 28px; }
.link__url { font-family: var(--font-mono); font-size: 17px !important; color: var(--text) !important; margin-top: 6px; word-break: break-all; }
</style>

<!--
(2 dk 30 sn) Bütün anlattıklarımın çalışan hali burada.

Soldaki QR canlı demo: telefonunuzdan okutun, adınızı yazın ve bana sorunuzu gönderin. Soru-cevapta buradan okuyacağım.

Sağdaki QR repo: Flutter uygulaması, Supabase migration'ı ve bu sunum aynı yerde. README'deki adımlarla kendi ücretsiz projenizde birkaç dakikada çalışıyor.

Şimdi iki dakikalık hızlı bir tur:
1. İki pencere yan yana (biri gizli pencere): Ayşe soru gönderiyor, Mehmet'in ekranına yenilemeden düşüyor. (Realtime)
2. Geliştirici modunu açıyorum, Mehmet Ayşe'nin sorusunu silmeye çalışıyor: "0 satır silindi". (RLS)
3. Kodda nerede? Bağlantı main.dart'ta, sorgular tek dosyada, kurallar migration'da.

İnternet sorun çıkarırsa yedek ekran kaydını açıyorum.
-->

---
layout: cover
image: /img/cover-a.jpg
---

# Teşekkürler

Sorular?

<div class="thanks">
  <div class="thanks__item glass"><img src="/img/qr-demo.svg" alt=""><span class="text-accent">Soru sor</span></div>
  <div class="thanks__item glass"><img src="/img/qr-repo.svg" alt=""><span class="text-dim">GitHub</span></div>
  <div class="thanks__item glass"><img src="/img/qr-linkedin.svg" alt=""><span style="color:#0A66C2">LinkedIn</span></div>
</div>

<template #meta>
  <div class="flex items-center justify-between">
    <span class="font-mono text-sm text-muted">flutter-demo.poyrazavsever.com · github.com/poyrazavsever/flutter-ankara</span>
    <span class="text-dim font-mono text-sm tracking-widest">POYRAZ AVSEVER</span>
  </div>
</template>

<style>
.thanks { display: flex; gap: 18px; margin-top: 40px; }
.thanks__item { display: flex; flex-direction: column; align-items: center; gap: 10px; padding: 14px 14px 12px; }
.thanks__item img { width: 128px; height: 128px; display: block; background: #fff; padding: 8px; border-radius: 10px; }
.thanks__item span { font-family: var(--font-mono); font-size: 14px; }
</style>

<!--
(3 dk) Teşekkür ederim. Sorularınızı alayım. Demo panosuna gelen soruları da buradan okuyorum; LinkedIn QR'ı da ekranda.

Olası sorular için notlar:
- "Firebase'den farkı ne?" → İlişkisel Postgres, SQL ve RLS; açık kaynak, kendi sunucuna kurulabilir.
- "Offline çalışır mı?" → supabase_flutter offline-first değil; yerel önbellek (Drift, Hive vb.) ile birlikte kurulur. PowerSync gibi çözümler var.
- "State management?" → Supabase herhangi biriyle çalışır; stream'ler Riverpod, Bloc vb. ile doğal bağlanır.
- "Kendi sunucuma kurabilir miyim?" → Evet, Docker ile self-host mümkün; bakım sizde.
-->
