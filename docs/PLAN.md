# Flutter Ankara — Sunum ve Örnek Proje Planı

**Başlık:** Flutter ile Uçtan Uca Uygulama: Auth, Database ve Realtime
**Süre:** 30 dk (27 dk anlatım + kısa örnek proje turu, 3 dk soru-cevap)
**Format:** 16:9, Slidev
**Kitle:** Flutter temellerini bilen, Supabase'e yeni başlayanlar
**Omurga:** "Flutter ile arayüzü geliştirdik; şimdi bu uygulamaya kullanıcı, veri ve gerçek zamanlı güncellemeler kazandıralım."

Katılımcı sunum sonunda şu soruları cevaplayabilmeli:
1. Flutter'ı Supabase'e nasıl bağlarım?
2. Kullanıcıların erişimini nasıl kontrol ederim?
3. Veriler değiştiğinde ekranı nasıl güncellerim?

Ek kazanım: Supabase'i bir yapay zekâ asistanından (MCP) nasıl yönetebileceğini ve bunun sınırlarını bilir.

## Yaklaşım

- **Canlı demo yok.** Sunum "ne, nasıl yapılır" anlatımıyla ilerler: her adım bir kavram + kısa kod parçası + Soru Panosu'ndaki karşılığı.
- **Tek hikâye:** Bütün örnekler aynı uygulamadan gelir: Flutter Ankara Soru Panosu.
- **Örnek proje sonda:** QR ile repo paylaşılır, 2–4 dakikalık hızlı tur yapılır. İnternet sorununa karşı aynı turun ekran kaydı hazır tutulur.
- **Supabase MCP:** Asistanla şema kurma, migration, güvenlik denetimi. Bu projenin kendisi de bu şekilde kuruldu; gerçek deneyim anlatılır.

---

## 1. Akış

| Süre | Bölüm | Slaytlar | Amaç |
|---|---|---|---|
| 00:00–02:00 | Açılış | Kapak, Soru Panosu ekran görüntüsü, problem | Varış noktasını göstermek |
| 02:00–04:30 | Supabase ne sağlıyor? | Bölüm, beş parça | Parçaları panodaki karşılıklarıyla tanıtmak |
| 04:30–07:00 | Flutter nasıl bağlanıyor? | Bölüm, mimari, `Supabase.initialize()` | İsteğin yolunu göstermek |
| 07:00–09:00 | Veri: tablo ve sorgu | `questions` tablosu, insert/select | Flutter'dan veri yazma ve okuma |
| 09:00–12:30 | Auth ve RLS | Bölüm, kimlik ≠ yetki, giriş kodu, politika, "0 satır" | Kimlik doğrulama ile yetkilendirmeyi ayırmak |
| 12:30–14:30 | Realtime | `.stream()`, yayına ekleme | Ekranı yenilemeden güncellemek |
| 14:30–18:30 | Supabase MCP ile geliştirme | Bölüm, MCP nedir, ne yapabilir, güvenli kullanım | Asistanla backend kurmanın yolu ve sınırları |
| 18:30–20:30 | Uygulama büyüdüğünde | Bölüm, Storage + Edge Functions, anahtarlar | İleri parçaları konumlandırmak |
| 20:30–22:00 | Kendi projene taşı | Altı adım | Uygulanabilir sıra vermek |
| 22:00–26:00 | Örnek proje | QR, hızlı tur | Katılımcının eve götüreceği şey |
| 26:00–27:00 | Kapanış | Teşekkür, bağlantılar | |
| 27:00–30:00 | Soru-cevap | QR açık kalır | |

Prova hedefi: 26 dakika. Toplam yaklaşık 18 slayt.

### Slayt listesi

1. **Kapak**
2. **Soru Panosu:** iki ekran yan yana (ekran görüntüsü). "Bunun arkasındaki sistemi inceleyeceğiz."
3. **Problem:** Ekranlar hazır; eksik olan kullanıcı, veri, kural ve güncelleme.
4. **Bölüm:** Supabase ne sağlıyor?
5. **Beş parça:** Database, Auth, Realtime, Storage, Edge Functions (ikonlu kartlar)
6. **Bölüm:** Flutter nasıl bağlanıyor?
7. **Mimari:** Flutter → `supabase_flutter` → Data API → Postgres + RLS
8. **Bağlantı kodu:** `Supabase.initialize()`, url, publishable key, secret key uyarısı
9. **Tablo:** `questions` kolonları ve SQL
10. **Sorgu:** `insert` ve `select`, Flutter kodu
11. **Bölüm:** Auth ve RLS
12. **Kimlik ≠ yetki** ve giriş kodu (`signInWithPassword`)
13. **RLS politikaları:** üç kural. "Butonu gizlemek arayüz davranışıdır; isteği reddetmek erişim kontrolüdür."
14. **Tuzak:** Başkasının satırını silmek hata vermez, 0 satır döner. `.select()` ile kontrol.
15. **Realtime:** `.stream(primaryKey: ['id'])` ve `supabase_realtime` yayını
16. **Bölüm:** Supabase MCP
17. **MCP nedir:** Asistan ↔ MCP sunucusu ↔ Supabase projesi
18. **Asistan neler yapabilir:** proje açma, tablo listeleme, migration, SQL, güvenlik/performans denetimi, tip üretme, doküman arama
19. **Güvenli kullanım:** geliştirme projesine bağla, `read_only`, `project_ref` ile tek projeye sınırla, her aracı onayla, verideki talimatlara dikkat (prompt injection). Gerçek not: bağlantı yetkisi yetmediğinde CLI ile devam edilebilir.
20. **Bölüm:** Uygulama büyüdüğünde
21. **Storage ve Edge Functions:** "Sorulara görsel ekleyelim", "Soruları yapay zekâyla özetleyelim"
22. **Anahtarlar:** publishable key istemcide, secret/service-role key asla istemcide değil
23. **Kendi projene taşı:** Veri modeli → giriş → erişim kuralları → okuma/yazma → Realtime → farklı kullanıcılarla dene
24. **Örnek proje:** QR + repo + "5 dakikada çalıştır"
25. **Teşekkürler / Soru-cevap**

(Bölüm slaytları kısa geçilir; içerik slaytı sayısı ~18.)

### Örnek proje turu (22:00–26:00)

| Adım | Süre | Gösterilen |
|---|---|---|
| QR ve repo | 30 sn | README, kurulum adımları |
| İki pencere | 1.5 dk | Ayşe soru gönderir, Mehmet'in ekranına düşer |
| Ret anı | 1 dk | Geliştirici modunda Mehmet, Ayşe'nin sorusunu silmeye çalışır → "0 satır silindi" |
| Kodda nerede? | 1 dk | Üç dosya: bağlantı, sorgular, migration |

Yedek: aynı turun 2 dakikalık ekran kaydı.

## 2. Teknik notlar

- **RLS reddi hata fırlatmaz.** Başkasının satırına `delete` atınca 0 satır etkilenir. `.delete().eq('id', id).select()` ile dönen liste kontrol edilir. (Gerçek istekle doğrulandı.)
- **Geliştirici modu:** Arayüzdeki bir anahtar, Sil butonunu herkesin sorusunda gösterir.
- **Tablo:** `questions(id uuid pk, user_id uuid default auth.uid() → auth.users, author_name text, content text check 1–280, created_at timestamptz default now())`
- **RLS:** select → `authenticated`; insert → `with check (auth.uid() = user_id)`; delete → `using (auth.uid() = user_id)`; update politikası yok
- **Realtime:** tablo `supabase_realtime` yayınında; Flutter'da `.stream(primaryKey: ['id'])`
- **Auth:** e-posta + şifre, onaylı iki demo hesabı (Ayşe, Mehmet), şifreler `.secrets/demo-users.env` (git dışı)
- **İstemci anahtarı:** yalnızca publishable key
- **State management:** bilinçli olarak minimal (StatefulWidget + StreamBuilder)
- **Platform:** Flutter web
- **Dil:** arayüz ve slaytlar Türkçe; kod, tablo ve kolon adları İngilizce

## 3. Repo yapısı

```
app/        Flutter örnek proje: Soru Panosu
supabase/   migrations (tablo, RLS, realtime), config
slides/     Slidev sunumu
assets/     Higgsfield çıktıları + prompts.md
docs/       plan, konuşmacı notları, prova kontrol listesi
README.md   QR'ın açtığı sayfa: örneği 5 dakikada çalıştır
```

## 4. Tasarım sistemi

**Tarz:** Açık, sade liquid glass. Gradyan yok, ışıma yok. Derinlik yalnızca cam, ince kenar ve gölgeden gelir. Başlıkların üstünde etiket yok. Her slaytta tek fikir.

| Token | Değer | Kullanım |
|---|---|---|
| `--bg` | `#F3F6F4` | Düz zemin |
| `--glass` | `rgba(255,255,255,0.62)` | Cam panel |
| `--glass-border` | `rgba(11,31,23,0.08)` | Cam kenarı |
| `--text` | `#0B1F17` | Ana metin |
| `--text-muted` | `#4F665A` | İkincil metin |
| `--accent` / `--accent-ink` | `#3ECF8E` / `#13804C` | Supabase yeşili: dolgu / metin |
| `--flutter` / `--flutter-ink` | `#54C5F8` / `#0175C2` | Yalnızca Flutter tarafı |
| `--deny` / `--deny-ink` | `#DC4A4A` / `#B42E2E` | Yalnızca "RLS reddetti" anı |

**Tipografi:** Geist 600 (başlık), Geist 400 (metin), Geist Mono (kod)

### Görseller (Higgsfield, `assets/prompts.md`)
- ✅ Kapak (A: üst üste cam paneller)
- ✅ Yedi cam ikon: database, auth, realtime, storage, functions, rls, key
- ✅ Bölüm görselleri: supabase, connect, auth, demo, grow
- ⬜ MCP bölüm görseli ve MCP ikonu
- ⬜ (İsteğe bağlı) Kapak loop videosu

## 5. Çalışma sırası
1. ✅ Plan
2. ✅ Supabase projesi, tablo, RLS, demo hesapları
3. ✅ Tasarım sistemi ve Slidev iskeleti
4. ✅ Kapak, ikonlar, bölüm görselleri
5. ⬜ MCP görselleri
6. ⬜ Bütün slaytların içeriği ve konuşmacı notları
7. ⬜ Flutter örnek proje (Soru Panosu) + ekran görüntüleri
8. ⬜ README, QR, yedek ekran kaydı, prova kontrol listesi
