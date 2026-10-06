# Flutter Ankara — Sunum ve Örnek Proje Planı

**Başlık:** Flutter ile Uçtan Uca Uygulama: Auth, Database ve Realtime
**Süre:** 30 dk (27 dk anlatım + kısa örnek proje turu, 3 dk soru-cevap)
**Format:** 16:9, Slidev, 30 slayt (8 bölüm geçişi + 22 içerik)
**Kitle:** Flutter temellerini bilen, Supabase'e yeni başlayanlar

## Tez

> **Supabase'i ne kadar iyi tanırsan, sınırlarını ne kadar iyi bilirsen projeni o kadar iyi kurarsın.**

Sunum bir kod anlatımı değil, bir **tanışma ve harita** sunumu. Her servis aynı dört soruyla anlatılır:

1. **Ne yapar?**
2. **Nasıl çalışır?** (bir cümle, gerekirse tek bir küçük kod/diyagram)
3. **Soru Panosu'nda karşılığı ne?**
4. **Sınırı ve dikkat edilecek nokta ne?**

Kod minimumda: yalnızca bağlantı (3 satır) ve bir RLS kuralı gösterilir. Gerisi kavram, diyagram ve sayı.

Katılımcı sunum sonunda şunları bilir:
- Flutter'ı Supabase'e bağlamak için ne gerekir, anahtarlar ne işe yarar
- Her servisin ne zaman kullanılacağı ve nerede sınıra takılacağı
- Erişimin neden veritabanında (RLS) kontrol edildiği
- Ücretsiz planda neler var, ne zaman ücretli plana geçmek gerekir
- Supabase'i bir yapay zekâ asistanından (MCP) güvenle nasıl yönetebileceği

## Ortak örnek: Flutter Ankara Soru Panosu

Kullanıcı giriş yapar, konuşmacıya soru gönderir, sorular ortak panoda anında görünür, kullanıcı yalnızca kendi sorusunu silebilir. Her servis bu uygulama üzerinden anlatılır. Örnek proje en sonda QR ile paylaşılır.

---

## 1. Akış

| Süre | Bölüm | Slaytlar |
|---|---|---|
| 00:00–02:00 | **Açılış** | Kapak · Soru Panosu (ekran görüntüsü) · Tez |
| 02:00–04:00 | **Supabase nedir?** | Bölüm · Harita: Postgres ve etrafındaki servisler |
| 04:00–06:00 | **Flutter'a bağlanmak** | Üç adım · Anahtarlar ne işe yarar |
| 06:00–09:00 | **Database** | Bölüm · Gerçek Postgres + otomatik API · RLS · Sınırlar |
| 09:00–12:00 | **Auth** | Bölüm · Giriş yöntemleri ve oturum · Sınırlar |
| 12:00–14:30 | **Storage** | Bölüm · Bucket ve erişim · Sınırlar |
| 14:30–17:00 | **Realtime** | Bölüm · Üç mod · Sınırlar |
| 17:00–19:00 | **Edge Functions** | Bölüm · Ne zaman sunucu gerekir · Sınırlar |
| 19:00–22:00 | **Supabase MCP** | Bölüm · Asistan ne yapabilir · Güvenli kullanım |
| 22:00–23:30 | **Planlar** | Free ve Pro karşılaştırması · Ne zaman geçmeli |
| 23:30–24:30 | **Kendi projene** | Kontrol listesi |
| 24:30–27:00 | **Örnek proje** | QR · 2 dakikalık tur |
| 27:00–30:00 | **Soru-cevap** | QR açık kalır |

Prova hedefi: 26 dakika.

## 2. Slayt slayt içerik

### Açılış
1. **Kapak**
2. **Soru Panosu:** iki ekran yan yana. "Bu uygulamanın arkasında beş Supabase servisi var."
3. **Tez:** "Bir aracı ne kadar iyi tanırsan, sınırlarını ne kadar iyi bilirsen o kadar iyi kurarsın." Her servis için dört soru: ne yapar, nasıl çalışır, panoda karşılığı, sınırı.

### Supabase nedir?
4. **Bölüm**
5. **Harita:** Merkezde Postgres. Etrafında Auth, Storage, Realtime, Edge Functions. Önünde otomatik Data API. Açık kaynak, kendi sunucunda da çalıştırılabilir.

### Flutter'a bağlanmak
6. **Üç adım:** `supabase_flutter` paketini ekle → proje URL'si ve publishable key → `Supabase.initialize()`. (Tek kod parçası.)
7. **Anahtarlar:**
   - **URL:** projenin adresi
   - **Publishable key** (`sb_publishable_…`): uygulamaya gömülür, herkes görebilir. Kimseyi yetkilendirmez; yalnızca "bu proje için gelen istek" der. Ne görülebileceğine **RLS** karar verir.
   - **Secret key** (`sb_secret_…`): RLS'yi atlar. Yalnızca sunucuda ve Edge Functions'ta. Flutter uygulamasına asla konmaz.

### Database
8. **Bölüm**
9. **Gerçek Postgres + otomatik API:** Tablo oluşturduğun an Flutter'dan erişilebilir bir API hazır. Panoda: `questions` tablosu (id, kullanıcı, metin, zaman).
10. **RLS: kapı veritabanında:** Üç kural (okuma, kendi adına ekleme, kendi sorusunu silme) tek bir SQL kuralı örneğiyle. Mesaj: "Sil butonunu gizlemek arayüz davranışıdır; isteği reddetmek erişim kontrolüdür." Tuzak: başkasının satırını silmek hata vermez, **0 satır** döner.
11. **Sınırlar ve dikkat:**
    - RLS kapalı tablo herkese açık bir kapıdır; Supabase uyarır, Security Advisor ile kontrol et
    - Ücretsiz planda 500 MB veritabanı, yedekleme yok
    - Ücretsiz projeler 1 hafta hareketsiz kalırsa duraklatılır, en fazla 2 aktif proje

### Auth
12. **Bölüm**
13. **Giriş yöntemleri ve oturum:** E-posta/şifre, magic link, OTP, Google/Apple gibi OAuth sağlayıcıları, anonim giriş, MFA. Oturum bir JWT'dir; RLS kuralındaki `auth.uid()` buradan gelir. Panoda: soruyu kimin gönderdiği.
14. **Sınırlar ve dikkat:**
    - Hazır e-posta sağlayıcısı **saatte 2 e-posta** gönderir; gerçek projede kendi SMTP'ni bağla
    - Mobilde OAuth ve e-posta doğrulama için deep link / redirect URL ayarı gerekir
    - Ücretsiz planda 50.000 aylık aktif kullanıcı

### Storage
15. **Bölüm**
16. **Bucket ve erişim:** Dosyalar bucket'larda durur. Public bucket: herkes URL ile görür. Private bucket: erişimi yine **RLS kuralları** belirler, geçici imzalı URL (signed URL) ile paylaşılır. Panoda: soruya ekran görüntüsü eklemek.
17. **Sınırlar ve dikkat:**
    - Ücretsiz planda 1 GB depolama, dosya başına 50 MB
    - Görsel dönüştürme (boyutlandırma) yalnızca ücretli planda
    - Trafik (egress) ücretsiz planda 5 GB; büyük dosyalar çabuk tüketir

### Realtime
18. **Bölüm**
19. **Üç mod:**
    - **Postgres Changes:** tablodaki değişikliği dinle. Panoda: yeni soru ekrana düşer.
    - **Broadcast:** istemciler arası hızlı mesaj. Panoda: "konuşmacı bu soruyu seçti" bildirimi.
    - **Presence:** kim çevrimiçi. Panoda: "şu an 42 kişi bakıyor".
20. **Sınırlar ve dikkat:**
    - Tabloyu Realtime yayınına eklemeyi unutma; yoksa hiçbir şey gelmez
    - Postgres Changes RLS'ye uyar ama her değişiklik her abone için kontrol edilir; çok kalabalık senaryoda Broadcast'i düşün
    - Ücretsiz planda 200 eşzamanlı bağlantı, ayda 2 milyon mesaj, mesaj başına 256 KB

### Edge Functions
21. **Bölüm**
22. **Ne zaman sunucu gerekir:** Gizli anahtar gereken her iş: yapay zekâ servisi, ödeme, e-posta, webhook. TypeScript (Deno) ile yazılır, kullanıcıya yakın çalışır. Panoda: "soruları yapay zekâyla özetle".
23. **Sınırlar ve dikkat:**
    - İstek başına 2 sn CPU süresi, 256 MB bellek, ücretsiz planda en fazla 150 sn çalışma
    - Uzun süren işler için uygun değil
    - Ücretsiz planda ayda 500.000 çağrı

### Supabase MCP
24. **Bölüm**
25. **Asistan ne yapabilir:** MCP, yapay zekâ asistanını (Claude, Cursor vb.) Supabase projene bağlar. Tablo listeleme, migration uygulama, SQL çalıştırma, güvenlik ve performans denetimi, log sorgulama, Edge Function yayınlama, doküman arama.
26. **Güvenli kullanım:**
    - Canlı (production) projeye değil, geliştirme projesine bağla
    - `read_only` modu ve `project_ref` ile tek projeye sınırlama
    - Asistanın her işlemini onayla
    - Veritabanındaki veride asistana yönelik talimatlar olabilir (prompt injection)
    - Gerçek deneyim: bu sunumun projesi asistanla kuruldu. MCP yetkisi yetmediğinde Supabase CLI ile devam edildi.

### Planlar
27. **Free ve Pro:**

| | Free | Pro ($25/ay'dan) |
|---|---|---|
| Veritabanı | 500 MB | 8 GB |
| Aylık aktif kullanıcı | 50.000 | 100.000 |
| Dosya depolama | 1 GB | 100 GB |
| Trafik | 5 GB | 250 GB |
| Yedekleme | Yok | Günlük, 7 gün |
| Duraklatma | 1 hafta hareketsizlikte | Yok |

    Ne zaman geçmeli: gerçek kullanıcı geldiğinde, yedek gerektiğinde, proje uyumamalıysa. Pro'da harcama limiti varsayılan açık.

### Kapanış
28. **Kendi projene kontrol listesi:** Veri modeli → giriş yöntemi → her tablo için RLS → anahtarları doğru yere koy → gerekiyorsa Realtime/Storage → gizli işler Edge Function'a → farklı kullanıcılarla dene → Security Advisor'ı çalıştır.
29. **Örnek proje:** QR + repo + "5 dakikada çalıştır". 2 dakikalık tur: iki pencerede soru düşmesi ve "0 satır silindi" anı. Yedek: ekran kaydı.
30. **Teşekkürler / Soru-cevap**

(Bölüm slaytları birkaç saniyelik geçişlerdir.)

## 3. Doğrulanmış bilgiler (2026-10-06)

| Bilgi | Kaynak |
|---|---|
| Free: 500 MB DB, 50k MAU, 1 GB storage, 5 GB egress, 2 aktif proje, 1 haftada duraklatma | supabase.com/pricing |
| Pro: $25/ay'dan; 8 GB, 100k MAU, 100 GB storage, 250 GB egress, günlük yedek 7 gün, harcama limiti varsayılan açık | supabase.com/pricing |
| Storage: free dosya başına 50 MB, görsel dönüştürme free'de yok | supabase.com/pricing |
| Realtime free: 200 eşzamanlı bağlantı, 2M mesaj/ay, 256 KB mesaj | supabase.com/pricing |
| Edge Functions free: 500k çağrı/ay; 2 sn CPU, 256 MB, 150 sn (free) / 400 sn (paid) | supabase.com/pricing, docs/guides/functions/limits |
| Auth: hazır e-posta sağlayıcısı saatte 2 e-posta | docs/guides/auth/rate-limits |
| MCP: araç grupları, `read_only`, `project_ref`, güvenlik uyarıları | docs/guides/ai-tools/mcp |
| RLS silme reddi 0 satır döner | Bu projede gerçek istekle test edildi |

## 4. Teknik notlar (örnek proje)

- **Tablo:** `questions(id, user_id default auth.uid(), author_name, content check 1–280, created_at)`
- **RLS:** select → authenticated; insert → `auth.uid() = user_id`; delete → `auth.uid() = user_id`; update yok
- **Realtime:** tablo `supabase_realtime` yayınında; Flutter'da `.stream(primaryKey: ['id'])`
- **Silme reddi:** `.delete().eq('id', id).select()` boş dönerse "0 satır silindi: RLS izin vermedi"
- **Geliştirici modu:** Sil butonunu herkesin sorusunda gösterir
- **Auth:** iki onaylı demo hesabı (Ayşe, Mehmet), şifreler `.secrets/demo-users.env` (git dışı)
- **Platform:** Flutter web; state management minimal

## 5. Repo yapısı

```
app/        Flutter örnek proje: Soru Panosu
supabase/   migrations, config
slides/     Slidev sunumu
assets/     Higgsfield çıktıları + prompts.md
docs/       plan, konuşmacı notları, prova kontrol listesi
README.md   QR'ın açtığı sayfa
```

## 6. Tasarım sistemi

**Tarz:** Açık, sade liquid glass. Gradyan ve ışıma yok. Başlık üstünde etiket yok. Her slaytta tek fikir.

| Token | Değer | Kullanım |
|---|---|---|
| `--bg` | `#F3F6F4` | Düz zemin |
| `--glass` | `rgba(255,255,255,0.62)` | Cam panel |
| `--text` / `--text-muted` | `#0B1F17` / `#4F665A` | Metin |
| `--accent` / `--accent-ink` | `#3ECF8E` / `#13804C` | Supabase yeşili |
| `--flutter` / `--flutter-ink` | `#54C5F8` / `#0175C2` | Yalnızca Flutter tarafı |
| `--deny` / `--deny-ink` | `#DC4A4A` / `#B42E2E` | Yalnızca ret ve sınır uyarıları |

**Tipografi:** Geist 600 / Geist 400 / Geist Mono

**Tekrarlayan kalıp: "Sınırlar ve dikkat" slaytı.** Her serviste aynı görünüm; sol tarafta servis ikonu, sağda 3 madde, sayılar Geist Mono ile vurgulu. İzleyici bu kalıbı tanıyıp beklemeye başlar.

### Görseller (Higgsfield, `assets/prompts.md`)
- ✅ Kapak, yedi cam ikon, beş bölüm görseli (supabase, connect, auth, demo, grow)
- ⬜ Yeni bölüm görselleri: database, storage, realtime, functions, mcp, plans
- ⬜ MCP ikonu

## 7. Çalışma sırası
1. ✅ Plan · Supabase projesi · tasarım sistemi · kapak, ikonlar, ilk bölüm görselleri
2. ⬜ Eksik bölüm görselleri ve MCP ikonu
3. ⬜ Bütün slaytların içeriği ve konuşmacı notları
4. ⬜ Flutter örnek proje + ekran görüntüleri
5. ⬜ README, QR, yedek ekran kaydı, prova kontrol listesi
