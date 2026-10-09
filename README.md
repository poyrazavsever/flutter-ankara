# Flutter Ankara — Soru Panosu

**Flutter ile Uçtan Uca Uygulama: Auth, Database ve Realtime** sunumunun örnek projesi.

**Uygulama:** https://flutter-demo.poyrazavsever.com · **Sunum:** https://flutter-sunum.poyrazavsever.com

Kullanıcı adını yazıp katılır, konuşmacıya soru gönderir; sorular herkesin ekranına yenilemeden düşer. Herkes yalnızca kendi sorusunu silebilir ve bu kuralı arayüz değil, veritabanı uygular.

| Klasör | İçerik |
|---|---|
| `app/` | Flutter web uygulaması |
| `supabase/` | Tablo, RLS kuralları ve Realtime tek migration'da |
| `slides/` | Sunum (Slidev) |
| `docs/` | Plan ve konuşma metni |

## Kodda nerede?

| Konu | Dosya |
|---|---|
| Supabase'e bağlanmak | [`app/lib/main.dart`](app/lib/main.dart) |
| Bütün sorgular (giriş, canlı liste, ekleme, silme) | [`app/lib/questions_repo.dart`](app/lib/questions_repo.dart) |
| Erişim kuralları (RLS) ve Realtime | [`supabase/migrations/20261006000000_questions.sql`](supabase/migrations/20261006000000_questions.sql) |

## Kendi projende 5 dakikada çalıştır

1. [supabase.com](https://supabase.com) üzerinde ücretsiz bir proje aç.
2. Panelde **SQL Editor**'ü aç, [migration dosyasının](supabase/migrations/20261006000000_questions.sql) içeriğini yapıştırıp çalıştır.
3. **Authentication → Sign In / Providers** altında **Allow anonymous sign-ins** seçeneğini aç.
4. **Project Settings → API Keys** sayfasından publishable key'i, proje ana sayfasından URL'yi kopyala.
5. Çalıştır:

```bash
cd app
flutter pub get
flutter run -d chrome --dart-define=SUPABASE_URL=https://<proje>.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
```

`--dart-define` vermezsen uygulama sunumdaki projeye bağlanır.

## İki dakikalık tur

1. İki pencere aç (biri gizli pencere), iki farklı isimle katıl. Birinden soru gönder; diğerinde yenilemeden belirir. **(Realtime)**
2. Sağ üstten **Geliştirici modu**nu aç: Sil butonu başkasının sorularında da görünür. Sil'e bas: **"0 satır silindi: RLS izin vermedi."** Buton göründü, ama veritabanı izin vermedi. **(RLS)**

## Yayına alma

İkisi de Cloudflare Workers'ta statik site olarak durur (`wrangler.jsonc`); önce `npx wrangler login`.

```bash
# Uygulama → flutter-demo.poyrazavsever.com
cd app
flutter build web --release
npx wrangler deploy

# Sunum → flutter-sunum.poyrazavsever.com
cd slides
npm run deploy
```

> Windows'ta proje yolunda Türkçe karakter varsa (`Yazılım` gibi) Dart analiz aracı çökebilir. Projeyi ASCII bir yola taşı ya da `subst W: "<proje yolu>"` ile geçici bir sürücüden çalış.
