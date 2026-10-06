# Flutter Ankara — Sunum ve Demo Planı

**Başlık:** Flutter ile Uçtan Uca Uygulama: Auth, Database ve Realtime
**Süre:** 30 dk (27 dk anlatım + demo, 3 dk soru-cevap)
**Kitle:** Flutter temellerini bilen, Supabase'e yeni başlayanlar
**Omurga:** "Flutter ile arayüzü geliştirdik; şimdi bu uygulamaya kullanıcı, veri ve gerçek zamanlı güncellemeler kazandıralım."

Katılımcı sunum sonunda şu soruları cevaplayabilmeli:
1. Flutter'ı Supabase'e nasıl bağlarım?
2. Kullanıcıların erişimini nasıl kontrol ederim?
3. Veriler değiştiğinde ekranı nasıl güncellerim?

---

## 1. Akış

| Süre | Bölüm | Slayt |
|---|---|---|
| 00:00–02:00 | Açılış: önce sonucu göster | 1 Kapak, 2 Canlı pano |
| 02:00–05:00 | Supabase ne sağlıyor? | 3 Problem, 4 Beş parça |
| 05:00–08:00 | Flutter nasıl bağlanıyor? | 5 Mimari, 6 `Supabase.initialize()` |
| 08:00–11:00 | Auth ve RLS | 7 Kimlik ≠ Yetki, 8 RLS politikası |
| 11:00–21:00 | Uygulamalı demo (10 dk) | 9 Demo bölüm slaytı |
| 21:00–24:00 | Uygulama büyüdüğünde (3 dk) | 10 Storage + Edge Functions, 11 Anahtarlar |
| 24:00–27:00 | Gerçek projeye taşıma, kapanış | 12 Altı adım, 13 QR + teşekkür |
| 27:00–30:00 | Soru-cevap | 13 açık kalır |

Prova hedefi: anlatım + demo 25 dk, 2 dk geçiş payı.

### Demo adımları (10 dk)
| Adım | Süre | Gösterilen |
|---|---|---|
| Tablo ve politikalar (Supabase Studio) | 1 dk | `questions` kolonları, RLS açık |
| Flutter bağlantısı (IDE) | 1 dk | `Supabase.initialize()` |
| Ayşe ile giriş | 1 dk | Oturum, `auth.uid()` |
| Soru ekle ve listele | 2 dk | `insert` / `stream` |
| Mehmet'in penceresi | 2.5 dk | Realtime ile sorunun düşmesi |
| Erişim kontrolü | 2.5 dk | Kendi sorusunu sil ✓, Geliştirici modunda başkasınınkini sil → "0 satır silindi: RLS izin vermedi" |

İki güçlü an: **sorunun diğer ekrana düşmesi** ve **yetkisiz silmenin reddedilmesi**.

## 2. Teknik notlar

- **RLS reddi hata fırlatmaz.** Başkasının satırına `delete` atınca 0 satır etkilenir. Bu yüzden `.delete().eq('id', id).select()` kullanılır, dönen liste boşsa ret mesajı gösterilir.
- **Geliştirici modu:** Arayüzdeki bir anahtar, Sil butonunu herkesin sorusunda gösterir. Mesaj: *"Sil butonunu gizlemek arayüz davranışıdır; silme isteğini reddetmek erişim kontrolüdür."*
- **Tablo:** `questions(id uuid pk, user_id uuid default auth.uid() → auth.users, author_name text, content text check 1–280, created_at timestamptz default now())`
- **RLS:** select → `authenticated`; insert → `with check (auth.uid() = user_id)`; delete → `using (auth.uid() = user_id)`
- **Realtime:** tablo `supabase_realtime` yayınına eklenir; Flutter'da `.stream(primaryKey: ['id'])`
- **Auth:** e-posta + şifre, onaylı iki hazır hesap (Ayşe, Mehmet), şifreler `supabase/seed` / `.env.example`'da
- **İstemci anahtarı:** sadece publishable key. Secret/service-role anahtarı istemciye asla konmaz.
- **State management:** bilinçli olarak minimal (StatefulWidget + StreamBuilder)
- **Platform:** Flutter web, sahnede iki tarayıcı penceresi yan yana (sol: Ayşe, sağ: Mehmet)
- **Dil:** arayüz ve slaytlar Türkçe; kod, tablo ve kolon adları İngilizce

## 3. Repo yapısı

```
app/        Flutter demo: Soru Panosu
supabase/   migrations (tablo, RLS, realtime), seed
slides/     Slidev sunumu
assets/     Higgsfield çıktıları + prompts.md (tekrar üretilebilirlik)
docs/       plan, konuşmacı notları, yedek plan, prova kontrol listesi
README.md   QR'ın açtığı sayfa: örneği 5 dakikada çalıştır
```

## 4. Tasarım sistemi (taslak)

**Tarz:** Koyu zümrüt zemin üzerinde liquid glass. Sade, modern, bol boşluk. Her slaytta tek fikir.

### Renkler
| Token | Değer | Kullanım |
|---|---|---|
| `--bg-0` | `#050D0A` | En derin zemin |
| `--bg-1` | `#07120E` | Ana zemin |
| `--glass` | `rgba(255,255,255,0.06)` | Cam panel dolgusu |
| `--glass-border` | `rgba(255,255,255,0.12)` | Cam panel kenarı |
| `--glass-blur` | `24px` | backdrop-filter |
| `--text` | `#E8F5EE` | Ana metin |
| `--text-muted` | `#8FA89B` | İkincil metin |
| `--accent` | `#3ECF8E` | Supabase yeşili, ana vurgu |
| `--accent-deep` | `#24B47E` | Hover, koyu vurgu |
| `--accent-glow` | `rgba(62,207,142,0.35)` | Işıma |
| `--flutter` | `#54C5F8` | Yalnızca Flutter tarafını işaret ederken |
| `--deny` | `#F87171` | Yalnızca "RLS reddetti" anında |

**Format:** 16:9 (1920×1080)

### Tipografi
- Başlık: **Geist 600**
- Metin: **Geist 400**
- Kod: **Geist Mono**
- Türkçe karakter kontrolü: ğ ş ı İ ç ö ü

### Higgsfield ile üretilecekler
Hepsi tek bir ortak stil anahtarıyla (koyu zümrüt, buzlu cam, yumuşak yeşil ışıma) üretilecek.
- Kapak hero görseli
- Bölüm geçiş görselleri (5–6 adet)
- Kavram ikonları, 3D cam: Database, Auth, Realtime, Storage, Edge Functions, RLS/kalkan, publishable/secret anahtar
- Slayt arka plan dokuları
- Açılış loop videosu (5–10 sn, salon dolarken ve kapakta)
- Demo uygulamanın arka planı ve logosu

## 5. Çalışma sırası
1. ✅ Plan
2. Tasarım sistemi: tokenlar, cam bileşenleri, slayt şablonları
3. Higgsfield: stil anahtarı → kapak → ikonlar → geçişler → loop video
4. Supabase + Flutter demo (aynı tasarım dili)
5. Slayt içeriği + konuşmacı notları
6. Prova paketi: yedek demo kaydı, QR, README, kontrol listesi
