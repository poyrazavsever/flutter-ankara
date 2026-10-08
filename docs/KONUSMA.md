# Flutter ile Uçtan Uca Uygulama — Konu Rehberi ve Konuşma Metni

Bu doküman iki bölümden oluşur:

1. **Konuyu derinlemesine anla:** Slaytlarda kısaca geçen her şeyin arkasındaki mekanizma, "neden böyle?" soruları ve sahnede gelebilecek sorulara hazırlık. Slaytta söylenenden fazlasını bilmek, sahnede rahat olmanı sağlar.
2. **Slayt slayt konuşma metni:** 39 slaytın her biri için süre, söylenecek metin ve geçiş cümlesi.

> Rakamlar 2026-10-06 tarihinde Supabase'in resmi fiyat ve doküman sayfalarından doğrulandı. Sunumdan önce bir kez daha kontrol et.

---

# Bölüm 1 — Konuyu derinlemesine anla

## 1.1 Supabase'in zihinsel modeli: "Önce Postgres"

Supabase'i anlamanın en kısa yolu şu cümle: **Supabase, bir Postgres veritabanı ve onun etrafına dizilmiş, her biri açık kaynak olan servislerdir.**

Her projeye ayrı bir Postgres örneği verilir. Diğer servislerin neredeyse hepsi durumunu bu veritabanında tutar:

| Servis | Ne iş yapar | Verisi nerede? |
|---|---|---|
| **Data API** (PostgREST) | Tablolarından otomatik REST API üretir | Doğrudan senin tabloların |
| **Auth** (GoTrue) | Kayıt, giriş, oturum, JWT | `auth` şeması: `auth.users`, `auth.identities`… |
| **Storage** | Dosya yükleme, indirme, erişim | Dosyalar S3 uyumlu depoda; kayıtları `storage.objects` tablosunda |
| **Realtime** | Değişiklikleri ve mesajları anlık iletir | Postgres'in değişiklik günlüğünü (WAL) dinler |
| **Edge Functions** | Sunucu tarafı TypeScript kodu (Deno) | Postgres'in dışında çalışır, ama veritabanına bağlanabilir |
| **Studio** | Web paneli | Hepsini yönetir |

Bu yüzden sunumun ana fikri şu: **Postgres'i ve RLS'yi anlarsan Supabase'in yarısını anlamış olursun.** Kullanıcılar da, dosya kayıtları da, erişim kuralları da veritabanında.

**İsteğin yolculuğu** (Flutter'dan veritabanına):

1. Flutter, `supabase_flutter` istemcisiyle HTTPS isteği atar. İstekte iki şey vardır: **publishable key** (hangi proje) ve kullanıcı giriş yaptıysa **JWT** (kim).
2. İstek Supabase'in API ağ geçidinden geçer ve Data API'ye (PostgREST) ulaşır.
3. PostgREST, isteği SQL'e çevirir ve Postgres'e **kullanıcının rolüyle** bağlanır: giriş yapmamışsa `anon`, yapmışsa `authenticated`. JWT içindeki bilgiler (`auth.uid()`) bu oturumda okunabilir hale gelir.
4. Postgres sorguyu çalıştırırken **RLS kurallarını** uygular. Kullanıcının göremeyeceği satırlar sonuçta hiç yoktur.
5. Sonuç JSON olarak Flutter'a döner.

Yani güvenlik "API'de" değil, **veritabanının içinde**. Flutter'dan gelen istek ne olursa olsun, son söz Postgres'te.

## 1.2 Anahtarlar ve roller

Supabase'te iki aile anahtar var:

| Yeni ad | Eski ad | Postgres rolü | RLS | Nerede durur? |
|---|---|---|---|---|
| **Publishable key** `sb_publishable_…` | `anon` key | `anon` (giriş yoksa) / `authenticated` (JWT varsa) | **Uygulanır** | İstemci: Flutter, web, mobil |
| **Secret key** `sb_secret_…` | `service_role` key | `service_role` | **Atlanır** | Sunucu, Edge Functions, CI |

Önemli noktalar:

- **Publishable key gizli değildir.** APK'yı açan herkes görebilir, web'de tarayıcıdan okunur. Bu tasarım gereğidir: bu anahtar kimseyi yetkilendirmez, sadece hangi projeye konuşulduğunu söyler. Kullanıcının kim olduğunu **JWT** söyler, neye erişebileceğini **RLS** belirler.
- **Secret key tam yetkilidir.** RLS'yi atlar. Bu anahtar istemciye girerse veritabanının tamamı açılır. Sızarsa panelden hemen yenisi oluşturulup eskisi silinmeli.
- **Neden yeni anahtarlar?** Eski `anon` / `service_role` anahtarları uzun ömürlü JWT'lerdi ve proje JWT sırrına bağlıydı; tek tek döndürmek (rotate) zordu. Yeni anahtarlar bağımsız oluşturulup silinebiliyor. Eski projelerde ve eğitimlerde hâlâ eski adları göreceksin; roller aynı.
- Flutter'da publishable key, `Supabase.initialize()` içindeki `anonKey` parametresine verilir. (Paketin güncel sürümünde parametre adını örnek projeyi yazarken kontrol et.)

## 1.3 Database ve otomatik Data API

- **Gerçek Postgres:** İlişkiler (foreign key), indeksler, view'lar, fonksiyonlar, trigger'lar, eklentiler (ör. `pgvector` ile vektör arama, `pg_cron` ile zamanlanmış işler). Firebase'in doküman modelinden farkı burada: veri ilişkisel, sorgular SQL.
- **Data API (PostgREST):** `public` şemasındaki her tablo ve view için otomatik uç noktalar üretir. Flutter'da:
  - `supabase.from('questions').select()` → okuma
  - `.insert({...})`, `.update({...}).eq('id', id)`, `.delete().eq('id', id)`
  - İlişkili tablolar tek sorguda: `.select('*, profiles(name)')`
  - Karmaşık iş mantığı için Postgres fonksiyonu yazıp `supabase.rpc('fonksiyon_adı')` ile çağırabilirsin.
- **Şemada ne açık?** Varsayılan olarak `public` şeması API'ye açıktır. Bu yüzden `public`'teki her tabloda RLS açık olmalı.
- **Migration:** Şema değişikliklerini SQL dosyaları olarak tutmak iyi alışkanlıktır (`supabase/migrations/`). Örnek projemizde tablo, kurallar ve Realtime ayarı tek bir migration dosyasında. Supabase CLI ile `supabase db push` uygulanır.
- **Studio / Table Editor:** Tabloları elle düzenlemek, SQL çalıştırmak, kuralları görmek için. Öğrenirken çok faydalı; gerçek projede değişiklikleri migration ile yapmak daha güvenli.

## 1.4 RLS: Row Level Security derinlemesine

**Temel kural:** Bir tabloda RLS açıldığında **varsayılan cevap "hayır"dır.** Hiç kural yoksa `anon` ve `authenticated` rolleri hiçbir satırı göremez, ekleyemez, silemez. Sen kural yazdıkça izin açılır.

**Kural (policy) anatomisi:**

```sql
create policy "Kendi sorusunu silebilir"
on questions          -- hangi tablo
for delete            -- hangi işlem: select / insert / update / delete / all
to authenticated      -- hangi rol
using ( auth.uid() = user_id );   -- hangi satırlar
```

- **`using (...)`**: Mevcut satırlardan hangilerine dokunulabileceğini belirler. `select`, `update`, `delete` için geçerlidir. Satır bu koşulu sağlamıyorsa **kullanıcı için o satır yok sayılır**.
- **`with check (...)`**: Yazılan yeni veriyi kontrol eder. `insert` ve `update` için geçerlidir. Koşul sağlanmazsa istek **hata ile** reddedilir.

**"0 satır silindi" neden olur?** `delete` kuralı `using` ile çalışır; başkasının satırı kullanıcı için görünmez olduğundan silme komutu o satırı hiç bulamaz. Postgres açısından bu bir hata değil, "eşleşen satır yok" durumudur. Sonuç: hata yok, 0 satır. Bunu örnek projede gerçek istekle test ettik:

| İşlem | Sonuç |
|---|---|
| Ayşe soru ekler | 201, eklendi |
| Ayşe, başkasının `user_id`'siyle soru eklemeye çalışır | **403**, `with check` reddetti |
| Giriş yapmamış kullanıcı okur | 0 satır |
| Mehmet, Ayşe'nin sorusunu siler | **Hata yok, 0 satır** |
| Ayşe kendi sorusunu siler | 1 satır silindi |

Dikkat et: `insert` reddi **hata verir** (`with check`), `delete` reddi **sessizdir** (`using`). Flutter'da silme sonucunu kontrol etmek için `.delete().eq('id', id).select()` kullanılır; dönen liste boşsa silme gerçekleşmemiştir.

**Ek bilgiler:**

- `update` için genellikle hem `using` hem `with check` yazılır (hangi satırı güncelleyebilir + güncellenmiş hali geçerli mi).
- **Performans ipucu:** `auth.uid()` yerine `(select auth.uid())` yazmak, Postgres'in fonksiyonu satır başına değil sorgu başına bir kez çalıştırmasını sağlar. Kurallarda kullanılan kolonlara (`user_id`) indeks eklemek de önemli. Örnek projemizde ikisi de var.
- **Secret key RLS'yi atlar.** Bir kural "çalışmıyor" gibi görünüyorsa, testi secret key ile yapıp yapmadığını kontrol et.
- **Security Advisor** (panelde Advisors): RLS'si kapalı tablolar, fazla geniş kurallar gibi riskleri listeler.
- **Test yöntemi:** İzin verilen işlemleri değil, **reddedilmesi gerekenleri** de iki farklı kullanıcıyla dene.

## 1.5 Auth

- **Yöntemler:** e-posta + şifre, magic link (e-postayla gelen link), OTP (tek kullanımlık kod, e-posta veya SMS), OAuth sağlayıcıları (Google, Apple, GitHub, Azure…), anonim giriş, MFA (iki adımlı doğrulama).
- **Kullanıcılar** `auth.users` tablosunda durur. Bu tabloya doğrudan dokunmak yerine, profil bilgileri için `public.profiles` gibi bir tablo açıp `auth.users.id`'ye bağlamak yaygındır (genellikle yeni kullanıcıda otomatik satır açan bir trigger ile).
- **Oturum:** Giriş yapınca iki token gelir:
  - **Access token (JWT):** Kısa ömürlüdür (varsayılan 1 saat). Her istekte gönderilir; RLS'deki `auth.uid()` bu token'daki kullanıcı kimliğidir.
  - **Refresh token:** Access token süresi dolunca yenisini almak için.
  - `supabase_flutter` oturumu cihazda saklar ve token'ı arka planda kendisi yeniler. `onAuthStateChange` akışıyla giriş/çıkış olaylarını dinleyebilirsin.
- **Mobilde deep link:** Magic link, e-posta doğrulama ve tarayıcı tabanlı OAuth, kullanıcıyı uygulamaya geri döndürmek zorunda. Bunun için:
  1. Panelde **Authentication → URL Configuration** altında Redirect URL ekle (ör. `io.flutterankara.app://login-callback`)
  2. Android (`AndroidManifest.xml`) ve iOS'ta (`Info.plist`) bu şemayı tanımla
  3. Unutulursa link tarayıcıda açılıp kalır.
- **Yerel (native) giriş:** Google ve Apple için tarayıcıya gitmeden, platformun kendi giriş penceresiyle alınan token'ı `signInWithIdToken` ile Supabase'e verebilirsin. Daha iyi kullanıcı deneyimi.
- **E-posta limiti:** Hazır e-posta sağlayıcısı **saatte 2 e-posta** gönderir ve yalnızca deneme içindir. Kayıt onayı, şifre sıfırlama, magic link hepsi bu limite dahil. Gerçek projede **Authentication → Emails → SMTP Settings** altından kendi sağlayıcını (Resend, Amazon SES, Postmark…) bağla, ardından Rate Limits'ten limiti yükselt.
- Ücretsiz planda **50.000 aylık aktif kullanıcı**; toplam kullanıcı sayısı sınırsız.

## 1.6 Storage

- **Bucket:** Dosyaların durduğu klasör. İki tür:
  - **Public:** URL'yi bilen herkes indirir. Profil fotoğrafı, afiş gibi zaten açık içerik.
  - **Private:** Erişim **RLS kurallarıyla** belirlenir, çünkü her dosyanın kaydı `storage.objects` tablosunda bir satırdır.
- **Örnek kural:** "Kullanıcı yalnızca kendi kimliğiyle adlandırılmış klasöre yükleyebilir." Dosya yolu `user_id/dosya.png` şeklinde tutulur ve kural yolun ilk parçasının `auth.uid()` ile eşleşmesini ister. Mantık, tablolardaki RLS'nin aynısı.
- **İmzalı URL (signed URL):** Private dosyayı geçici olarak paylaşmak için süreli link. Süre dolunca çalışmaz.
- **Büyük dosyalar:** Büyük yüklemeler için parçalı, kaldığı yerden devam edebilen (resumable) yükleme var; birkaç MB'ı aşan dosyalarda önerilir.
- **Sınırlar (Free):** 1 GB depolama, 5 GB trafik (egress), dosya başına 50 MB. Görselleri sunucuda boyutlandırma (image transformations) ücretli planlarda. Ücretsiz planda görseli yüklemeden önce Flutter'da sıkıştırmak iyi bir alışkanlık.
- **Trafik hesabı:** 2 MB'lık bir görseli 2.500 kez göstermek 5 GB eder. Depolamadan çok trafik biter.

## 1.7 Realtime

Realtime ayrı bir sunucudur (Elixir ile yazılmış) ve **kanal** (channel) kavramıyla çalışır. Üç özelliği var:

1. **Postgres Changes:** Postgres her değişikliği bir günlüğe (WAL) yazar. Realtime, `supabase_realtime` adlı **yayına (publication)** eklenmiş tabloların değişikliklerini bu günlükten okur ve abone olan istemcilere iletir.
   - Tablo yayına eklenmemişse **hiçbir şey gelmez, hata da gelmez.** (Bizim migration'da: `alter publication supabase_realtime add table public.questions;`)
   - **RLS'ye uyar:** Kullanıcı göremeyeceği satırın değişikliğini almaz. Ama bunun için her değişiklik her abone için ayrı kontrol edilir; çok kalabalık senaryolarda bu maliyetlidir.
   - Flutter'daki `.stream(primaryKey: ['id'])` önce mevcut veriyi çeker, sonra Postgres Changes ile listeyi güncel tutar. `StreamBuilder` ile doğrudan kullanılır.
2. **Broadcast:** Kanal üzerinden istemciler arası hızlı mesaj; veritabanına yazılmaz. "Yazıyor…" göstergesi, ortak dokümanda imleç, oyun hamlesi. Ölçeklenmesi Postgres Changes'ten kolaydır. Veritabanı trigger'larından Broadcast mesajı göndermek de mümkün.
3. **Presence:** Kanaldaki istemcilerin paylaşılan durumu: kim çevrimiçi, kaç kişi var.

**Hangisi ne zaman?** Kalıcı olması gereken veri → Postgres Changes. Anlık ve kaybolsa da sorun olmayan sinyal → Broadcast. "Kim burada?" → Presence.

**Sınırlar (Free):** 200 eşzamanlı bağlantı, ayda 2 milyon mesaj, mesaj başına 256 KB.

## 1.8 Edge Functions

- **Ne zaman?** Gizli bir anahtar gerektiğinde ya da istemciye güvenilemeyecek bir iş olduğunda: yapay zekâ servisi çağırmak, ödeme almak, e-posta/bildirim göndermek, dış servislerden webhook almak.
- **Nasıl?** TypeScript ile yazılır, Deno çalışma ortamında, kullanıcıya yakın sunucularda çalışır. Gizli anahtarlar **Edge Functions → Secrets** altına konur, kodda ortam değişkeni olarak okunur.
- **Flutter'dan çağırma:** `supabase.functions.invoke('ozetle', body: {...})`. Kullanıcı giriş yaptıysa JWT otomatik gönderilir; fonksiyon içinde kullanıcıyı doğrulayıp ona göre davranabilirsin.
- **Oluşturma yolları:** Panelde tarayıcı editörü, yapay zekâ asistanı veya CLI (`supabase functions deploy`).
- **Sınırlar:** İstek başına **2 sn CPU süresi** (ağ beklemesi dahil değil, yani bir yapay zekâ cevabını beklemek sorun değil), **256 MB bellek**, en uzun çalışma **150 sn (Free) / 400 sn (ücretli)**. Ücretsiz planda ayda 500.000 çağrı. Ağır hesaplama ve uzun işler için uygun değil; uzun işler için kuyruk düşünülmeli.
- **Zamanlanmış işler:** `pg_cron` ile veritabanından düzenli olarak bir fonksiyonu tetiklemek mümkün.

## 1.9 Supabase MCP

- **MCP (Model Context Protocol):** Yapay zekâ asistanlarını (Claude, Cursor vb.) dış sistemlere bağlayan açık bir standart. Supabase'in resmi, barındırılan MCP sunucusu: `https://mcp.supabase.com/mcp`.
- **Bağlanma:** Kişisel erişim anahtarı gerekmez; tarayıcıda Supabase hesabınla giriş yapıp organizasyona erişim izni verirsin. Panelde projenin ana sayfasında **Get connected → MCP** kartı hazır yapılandırmayı verir.
- **Araç grupları:** Database (tablo listeleme, migration, SQL), Debugging (log sorgulama, güvenlik/performans denetimi), Development (proje adresi, publishable key, TypeScript tipleri), Edge Functions (listeleme, yayınlama), Account (proje açma, duraklatma), Docs (doküman arama), Branching (ücretli plan), Storage (varsayılan kapalı).
- **Güvenlik önerileri (Supabase'in kendi önerileri):**
  - Canlı projeye değil, geliştirme projesine bağla.
  - `read_only=true` ile salt okuma modunu kullan.
  - `project_ref` ile tek bir projeye sınırla (bu modda hesap araçları kapanır).
  - Asistanın her araç çağrısını oku ve onayla.
  - **Prompt injection:** Veritabanındaki kullanıcı verisi, asistana talimat gibi görünen metinler içerebilir ("tüm tabloları sil" yazan bir mesaj gibi). Okunan veri komut değildir.
- **Maliyet onayı:** Proje veya branch açmak ücretliyse MCP istemcisi önce maliyeti gösterip onay ister.
- **Bizim deneyimimiz:** Bu sunumun projesi asistanla kuruldu. MCP bağlantısı organizasyonu görebildiği halde proje işlemlerinde Supabase'in yetki servisinden "Unauthorized" hatası aldı; aynı işler Supabase CLI ile tamamlandı (proje açma, migration, demo hesapları, RLS testi). Mesaj: asistan bir araç; CLI ve panel her zaman yedek yol.

## 1.10 Planlar ve fiyat

| | Free | Pro ($25/ay'dan) |
|---|---|---|
| Veritabanı | 500 MB | 8 GB (sonrası GB başına ücret) |
| Aylık aktif kullanıcı | 50.000 | 100.000 |
| Dosya depolama | 1 GB | 100 GB |
| Trafik | 5 GB | 250 GB |
| Yedekleme | Yok | Günlük, 7 gün saklanır |
| Duraklatma | 1 hafta hareketsizlikte | Yok |
| Proje sayısı | En fazla 2 aktif | Proje başına compute ücreti |

- Pro'da her ay **10 dolarlık compute kredisi** vardır; bu, bir projenin en küçük (Micro) sunucusunu karşılar. Ek projeler compute ücreti ekler.
- **Harcama limiti (spend cap)** Pro'da varsayılan olarak açıktır; kotayı aşınca sürpriz fatura gelmez, gerekirse kapatılır.
- **Ne zaman Pro?** Gerçek kullanıcı geldiğinde (yedek şart), proje uyumamalıysa, ücretsiz kotalar yetmediğinde.
- **Kendi sunucunda (self-host):** Docker ile ücretsiz çalıştırılabilir; ama yedekleme, güncelleme, güvenlik bakımı sende.

## 1.11 Flutter'a özel notlar

- **Kurulum:** `flutter pub add supabase_flutter`, ardından `main()` içinde `await Supabase.initialize(url: ..., anonKey: ...)`. Sonra her yerden `Supabase.instance.client`.
- **State management:** Supabase herhangi biriyle çalışır. `stream()` ve `onAuthStateChange` akışları Riverpod, Bloc gibi çözümlere doğal olarak bağlanır. Örnek projede bilinçli olarak sade `StreamBuilder` kullanıldı.
- **Tipler:** Supabase resmi olarak TypeScript tipleri üretir; Dart için resmi kod üretimi yok, model sınıflarını kendin yazarsın (veya topluluk araçları).
- **Offline:** `supabase_flutter` offline-first değildir. Çevrimdışı çalışma için yerel veritabanı (Drift, Isar vb.) ile senkronizasyon kurulur; PowerSync gibi hazır çözümler de var.
- **Ortam değişkenleri:** URL ve publishable key'i `--dart-define` veya bir `.env` dosyasıyla vermek, farklı ortamları (geliştirme/canlı) ayırmayı kolaylaştırır.

## 1.12 Olası sorular ve kısa cevaplar

| Soru | Cevap |
|---|---|
| Firebase'den farkı ne? | İlişkisel Postgres ve SQL; güvenlik RLS ile veritabanında; açık kaynak, kendi sunucuna kurulabilir. Firebase doküman tabanlı ve kapalı. |
| Publishable key herkese açıksa biri benim API'mi kötüye kullanamaz mı? | Okuyup yazabileceği her şey RLS kurallarına bağlı. Kötüye kullanım (ör. aşırı istek) için rate limit, Auth'ta CAPTCHA ve gerekirse kritik işlemleri Edge Function arkasına almak. |
| RLS performansı düşürür mü? | Kural basitse ve kolonlar indeksliyse etkisi küçük. `(select auth.uid())` kalıbı ve indeks önemli. |
| Offline çalışır mı? | Kendiliğinden değil; yerel veritabanı + senkronizasyon (Drift, PowerSync…) gerekir. |
| Hangi state management? | Hepsiyle çalışır; stream'ler doğal olarak bağlanır. |
| Kendi sunucuma kurabilir miyim? | Evet, Docker ile. Bakım ve yedek sende. |
| Migration'ları nasıl yönetirim? | Supabase CLI: `supabase migration new`, `supabase db push`. Dosyalar repoda tutulur. |
| Birden fazla ortam (dev/prod)? | İki ayrı proje veya ücretli planda branching. MCP'yi dev projesine bağla. |
| Gerçek zamanlı ne kadar ölçeklenir? | Postgres Changes her abone için RLS kontrol eder; kalabalık odalarda Broadcast önerilir. Free'de 200 eşzamanlı bağlantı. |
| Ücretsiz proje neden durdu? | 1 hafta hareketsizlikte duraklatılır; panelden tekrar başlatılır. |
| Push bildirim var mı? | Supabase'in kendi push servisi yok; Edge Function'dan FCM/APNs çağrılır. |
| Arama (full-text / vektör)? | Postgres full-text search ve `pgvector` eklentisi. |

---

# Bölüm 2 — Slayt slayt konuşma metni

**Toplam:** yaklaşık 25 dakika anlatım + 3 dakika soru-cevap.
**İşaretler:** `[→]` sonraki slayta geç. Süreler hedeftir; bölüm geçiş slaytları birkaç saniyedir, orada durma.

---

### Slayt 1 — Kapak · 0:30

Herkese iyi akşamlar. Ben Poyraz.
*(Kendini 1–2 cümleyle tanıt: ne yaptığın, Flutter ile ilişkin.)*

Bu akşam Flutter ile geliştirdiğimiz bir uygulamaya **kullanıcı, veri ve gerçek zamanlı güncelleme** kazandırmayı konuşacağız. Bunu Supabase ile yapacağız. Ama size bir kod anlatımı değil, bir **tanışma** yapacağım: Supabase neler sunuyor, panelde nerede duruyor ve en önemlisi, sınırları neler.

`[→]`

### Slayt 2 — Tez · 0:40

Bu akşamın tek cümlesi bu: **Supabase'i ne kadar iyi tanırsanız, sınırlarını ne kadar iyi bilirseniz projenizi o kadar iyi kurarsınız.**

Supabase'te bir şeyi çalıştırmak çok kolay. Sizi projede zorlayacak şey kolay kısım değil; saatte kaç e-posta gönderebildiğiniz, kaç kişinin aynı anda bağlanabildiği, hangi anahtarın nereye konduğu.

O yüzden her servisi dört soruyla geçeceğiz: **Ne yapar? Nasıl çalışır? Panelde nerede? Sınırı ne?** Dördüncü soru her bölümün sonunda, aynı görünümde, kırmızı başlıkla karşınıza çıkacak.

`[→]`

### Slayt 3 — Bölüm: Supabase nedir? · 0:05

Önce büyük resme bakalım.

`[→]`

### Slayt 4 — Merkezde Postgres var · 1:15

Supabase'i "Firebase alternatifi" diye duymuş olabilirsiniz. Ama mimarisi çok farklı.

Merkezde **gerçek bir Postgres veritabanı** var. Her projenin kendine ait. Tablo oluşturduğunuz anda önünde **otomatik bir API** hazır oluyor; Flutter bu API ile konuşuyor ve ayrı bir backend yazmıyorsunuz.

Etrafında dört servis var: kullanıcılar için **Auth**, dosyalar için **Storage**, anlık güncellemeler için **Realtime**, sunucu tarafı kod için **Edge Functions**.

Şunu aklınızda tutun: bu servislerin çoğu verisini yine Postgres'te tutuyor. Kullanıcılar bir tabloda, dosya kayıtları bir tabloda, erişim kuralları veritabanında. Yani **Postgres'i ve birazdan anlatacağım RLS'yi anlarsanız, Supabase'in yarısını anlamış olursunuz.**

Bir de: hepsi açık kaynak. İsterseniz kendi sunucunuzda çalıştırabilirsiniz.

`[→]`

### Slayt 5 — Bölüm: Flutter'a bağlanmak · 0:05

Peki Flutter bu yapıya nasıl bağlanıyor?

`[→]`

### Slayt 6 — Üç adımda bağlantı · 0:45

Flutter tarafı gerçekten bu kadar.

Bir: `supabase_flutter` paketini ekliyorsunuz. Auth, veritabanı, dosyalar, realtime; hepsi tek istemcide.

İki: Supabase panelinden iki değer alıyorsunuz: projenin adresi ve publishable key.

Üç: Uygulama açılırken bir kez `Supabase.initialize` diyorsunuz. Sonra uygulamanın her yerinden aynı istemciyi kullanıyorsunuz.

Peki bu iki değer panelde nerede?

`[→]`

### Slayt 7 — Adres ve anahtar nerede? · 0:30

Proje adresi, projenin ana sayfasında en üstte; yanında kopyala butonu var.

Anahtar ise **Project Settings → API Keys** sayfasında. Üstte publishable key, onu kopyalıyorsunuz. Aşağıda secret key'ler var ve gördüğünüz gibi varsayılan olarak gizli.

Burada şu soru akla gelmeli: publishable key'i uygulamanın içine koyuyoruz. Yani APK'yı açan herkes görebilir. Bu güvenli mi?

`[→]`

### Slayt 8 — Anahtarlar ne işe yarar? · 1:00

Üç değerin üç farklı görevi var.

**URL** sadece adres. Gizli bir şey değil.

**Publishable key** uygulamaya gömülüyor ve herkes görebilir. Bu bir hata değil, tasarım gereği. Çünkü bu anahtar **kimseyi yetkilendirmiyor**; sadece "bu proje için gelen bir istek" diyor. Kullanıcının kim olduğunu giriş yapınca aldığı token söylüyor, neyi görebileceğine ise veritabanındaki kurallar, yani **RLS** karar veriyor.

**Secret key** ise tam yetkili ve **RLS'yi atlıyor.** Sadece sunucuda ya da Edge Functions içinde durur. Flutter uygulamasına konduğu an, uygulamayı indiren herkes veritabanınızın tamamına erişir.

Eski eğitimlerde `anon` ve `service_role` adlarını göreceksiniz. Aynı roller, yeni adları bunlar.

`[→]`

### Slayt 9 — Bölüm: Database · 0:05

İlk servisimiz, her şeyin merkezi: veritabanı.

`[→]`

### Slayt 10 — Tablo aç, API hazır · 0:50

Supabase'in veritabanı gerçek bir Postgres. İlişkiler, indeksler, fonksiyonlar, eklentiler; bildiğiniz her şey geçerli.

Fark şurada: tabloyu oluşturduğunuz an, Flutter'dan okunup yazılabilir hale geliyor. "Şu tabloya ekle", "son 50 kaydı getir" diyebiliyorsunuz.

Altta Table Editor'ü görüyorsunuz. Örnek projemizin `questions` tablosu: kim sordu, ne sordu, ne zaman sordu. Tabloları tarayıcıdan, bir tablo düzenler gibi yönetebiliyorsunuz.

Elin gösterdiği yere dikkat: **"3 RLS policies"**. Çünkü şu soru var: API herkese açıksa, birinin başkasının kaydını silmesini ne engelliyor?

`[→]`

### Slayt 11 — RLS: kapı veritabanında · 1:20

Cevap: **Row Level Security**, kısaca RLS. Satır bazında erişim kuralları ve bu kurallar veritabanında çalışıyor.

Örnek bir soru tablosu için üç kural yazdık: giriş yapan herkes okuyabilir, herkes sadece kendi adına ekleyebilir, herkes sadece kendi sorusunu silebilir.

Üçüncü kural SQL'de böyle: "Silmek isteyen kullanıcının kimliği, satırdaki `user_id` ile aynıysa izin ver." `auth.uid()` o an istek atan kullanıcı.

Buradaki ana mesaj şu: **Sil butonunu gizlemek arayüz davranışıdır. Silme isteğini reddetmek erişim kontrolüdür.** Butonu gizlemek güzel ama güvenlik değil; biri isteği kendisi gönderebilir.

Ve bir tuzak: başkasının kaydını silmeye çalıştığınızda **hata almıyorsunuz.** Kural o satırı görünmez yapıyor, işlem 0 satırı etkiliyor ve sessizce bitiyor. Bunu bu projede gerçek istekle denedim. "Hata gelmedi, demek ki silindi" diye düşünmeyin; dönen sonucu kontrol edin.

`[→]`

### Slayt 12 — Kurallar panelde · 0:25

Yazdığımız kurallar panelde **Database → Policies** altında, tablo tablo listeleniyor. İsterseniz kuralı buradan arayüzle de oluşturabiliyorsunuz.

Tablonun yanındaki **"Disable RLS"** butonuna dikkat: güvenlik bir tık uzakta.

`[→]`

### Slayt 13 — Database: sınırlar ve dikkat · 0:40

İlk "sınırlar" slaytımız.

**RLS kapalı tablo**, publishable key'i bilen herkese açık bir kapı. Panelde Security Advisor bunu uyarır; her yeni tablodan sonra bakın.

Ücretsiz planda veritabanı **500 MB** ve **otomatik yedek yok.**

Ve bir hafta kullanılmayan ücretsiz proje **duraklatılıyor.** Demo projeniz sunumdan önce uyumuş olabilir. Aynı anda en fazla iki aktif ücretsiz proje açabiliyorsunuz.

`[→]`

### Slayt 14 — Bölüm: Auth · 0:05

RLS'nin "kim" sorusunu sorduğunu gördük. O kimliği Auth veriyor.

`[→]`

### Slayt 15 — Giriş yöntemleri ve oturum · 1:10

Authentication "bu kullanıcı kim?" sorusunu, RLS ise "ne yapabilir?" sorusunu cevaplıyor.

Hazır gelen yöntemler: e-posta ve şifre, e-postaya gelen link, tek kullanımlık kod, Google, Apple, GitHub gibi sağlayıcılar, anonim giriş ve iki adımlı doğrulama.

Sağdaki akış ikisinin nasıl birleştiğini gösteriyor: kullanıcı giriş yapıyor, istemci bir **JWT** alıyor ve her istekte bu token gidiyor. Veritabanındaki `auth.uid()` işte bu token'daki kullanıcı. Az önceki RLS kuralı ile Auth burada buluşuyor.

Flutter'da oturumu paket yönetiyor: saklama, token yenileme, hepsi otomatik.

`[→]`

### Slayt 16 — Giriş yöntemleri panelde · 0:25

Panelde **Authentication → Sign In / Providers.** E-posta varsayılan olarak açık. Apple, Google, GitHub gibi sağlayıcıları buradan açıp anahtarlarını giriyorsunuz.

`[→]`

### Slayt 17 — E-posta limiti panelde · 0:20

Aynı bölümde **Rate Limits** sayfası. İlk satıra bakın: **saatte 2 e-posta.** Bu rakamı aklınızda tutun.

`[→]`

### Slayt 18 — Auth: sınırlar ve dikkat · 0:50

Neden önemli? Supabase'in hazır e-posta sağlayıcısı saatte sadece **2 e-posta** gönderiyor. Kayıt onayı, şifre sıfırlama, magic link; hepsi buna dahil. Lansman günü 50 kişi kayıt olursa 48'i e-posta alamaz. Gerçek projede mutlaka **kendi SMTP sağlayıcınızı** bağlayın.

İkincisi mobile özel: Google ile giriş ya da e-postadaki link kullanıcıyı uygulamaya geri getirmeli. Bunun için **redirect URL ve deep link** ayarı gerekiyor. Unutulursa link tarayıcıda açılıp kalıyor.

Ücretsiz planda aylık **50 bin aktif kullanıcı** var; çoğu proje için fazlasıyla yeterli.

`[→]`

### Slayt 19 — Bölüm: Storage · 0:05

Kullanıcılar ve veri tamam. Peki dosyalar?

`[→]`

### Slayt 20 — Bucket'lar ve erişim · 1:00

Dosyalar **bucket** denen klasörlerde duruyor. İki tür var.

**Public bucket:** URL'yi bilen herkes görür. Profil fotoğrafı, etkinlik afişi gibi zaten açık içerik için.

**Private bucket:** Erişimi yine **RLS** belirliyor. Çünkü her dosyanın kaydı Postgres'te bir tabloda tutuluyor. Yani "kullanıcı sadece kendi klasörüne yükleyebilir" kuralını az önceki SQL mantığıyla yazıyorsunuz.

Private bir dosyayı birine göstermek için **süreli, imzalı bir URL** üretiyorsunuz. Süre dolunca link çalışmıyor.

`[→]`

### Slayt 21 — Bucket'lar panelde · 0:20

Panelde **Storage → Files → Buckets.** Örnek projede iki tane var: private `attachments` ve PUBLIC etiketli `public-assets`. Bucket oluştururken açık olup olmayacağını ve dosya boyutu sınırını buradan seçiyorsunuz.

`[→]`

### Slayt 22 — Storage: sınırlar ve dikkat · 0:50

Ücretsiz planda **dosya başına 50 MB.** Telefondan çekilen bir video bunu kolayca aşar.

Toplam **1 GB depolama ve 5 GB trafik.** Trafik daha çabuk biter: 2 MB'lık bir görseli 2.500 kez göstermek 5 GB demek.

Görselleri sunucuda küçültme özelliği ücretli planlarda. Ücretsiz planda görseli **yüklemeden önce Flutter'da sıkıştırmak** iyi bir alışkanlık.

`[→]`

### Slayt 23 — Bölüm: Realtime · 0:05

Şimdi ekranı yenilemeden güncellemeye geçelim.

`[→]`

### Slayt 24 — Üç mod, üç ihtiyaç · 1:15

Realtime üç farklı şey yapıyor ve doğru olanı seçmek önemli.

**Postgres Changes:** Tablodaki değişikliği dinliyorsunuz. Kalıcı olması gereken veri için: yeni bir mesaj, siparişin durumu, güncellenen bir skor.

**Broadcast:** İstemciler arasında hızlı mesaj, veritabanına uğramadan. "Yazıyor…" göstergesi, ortak bir dokümanda imleç, oyundaki hamle. Kaydetmeye gerek yok, anlık olsun yeter.

**Presence:** Paylaşılan durum. Kim çevrimiçi, odada kaç kişi var.

Sık yapılan hata her şeyi Postgres Changes ile yapmak. "Yazıyor…" bilgisini tabloya yazıp dinlerseniz veritabanını gereksiz yere yorarsınız.

`[→]`

### Slayt 25 — Realtime'ı tabloya açmak · 0:30

Postgres Changes'in çalışması için tablonun **`supabase_realtime` yayınına** eklenmesi gerekiyor. Panelde **Database → Publications.** Hangi olayların yayınlanacağını ve hangi tabloların dahil olduğunu buradan görüyorsunuz.

Flutter tarafı tek satır: `.stream()` ile listeyi dinliyorsunuz; değişiklik gelince widget kendiliğinden yeniden çiziliyor.

`[→]`

### Slayt 26 — Realtime: sınırlar ve dikkat · 0:50

En sık yaşanan sorun: **tabloyu yayına eklemeyi unutmak.** Kod doğru, ama hiçbir şey gelmiyor ve hata da yok.

Postgres Changes güvenli: RLS'ye uyuyor, kullanıcı göremeyeceği satırın değişikliğini almıyor. Ama bedeli var: her değişiklik **her abone için ayrı kontrol ediliyor.** Bin kişilik bir odada Broadcast daha uygun.

Ücretsiz planda aynı anda **200 bağlantı.** Bu salondaki herkes aynı uygulamayı açsa sınıra yaklaşırız.

`[→]`

### Slayt 27 — Bölüm: Edge Functions · 0:05

Şimdiye kadar her şeyi Flutter'dan doğrudan yaptık. Peki ne zaman bir sunucu gerekir?

`[→]`

### Slayt 28 — Gizli anahtar gereken her iş · 0:50

Cevap basit: **gizli bir anahtar gerektiğinde.**

Yapay zekâ servisi çağırmak, ödeme almak, e-posta ya da bildirim göndermek, dış servislerden webhook almak. Bunların hepsinin bir gizli anahtarı var ve o anahtar Flutter uygulamasına giremez.

Edge Functions burada devreye giriyor. TypeScript ile küçük fonksiyonlar yazıyorsunuz, kullanıcıya yakın sunucularda çalışıyor. Flutter fonksiyonu çağırıyor; **anahtar fonksiyonun içinde kalıyor**, uygulamaya hiç inmiyor.

`[→]`

### Slayt 29 — Fonksiyonlar panelde · 0:20

Panelde **Edge Functions** sayfasından üç yolla fonksiyon oluşturabiliyorsunuz: tarayıcıdaki editörle, yapay zekâ asistanıyla ya da CLI ile. Gizli anahtarlar soldaki **Secrets** sekmesinde.

`[→]`

### Slayt 30 — Edge Functions: sınırlar ve dikkat · 0:40

Edge Functions kısa ve hızlı işler için.

İstek başına **2 saniye işlemci süresi.** Dikkat: bir yapay zekâ servisinden cevap beklemek buna sayılmıyor, çünkü o sırada işlemci boşta. Ama video işlemek gibi ağır hesaplama uygun değil.

Ücretsiz planda bir fonksiyon en fazla **150 saniye** çalışabiliyor. Daha uzun işler için kuyruk düşünmek gerekiyor.

Ayda **500 bin çağrı** ücretsiz.

`[→]`

### Slayt 31 — Bölüm: Supabase MCP · 0:05

Son başlık bir servis değil, bir çalışma şekli.

`[→]`

### Slayt 32 — Asistan neler yapabilir? · 1:00

**MCP**, yapay zekâ asistanlarını dış sistemlere bağlayan açık bir standart. Supabase'in resmi bir MCP sunucusu var. Claude ya da Cursor gibi bir asistana bağladığınızda doğal dille "bir tablo oluştur, RLS kurallarını yaz, güvenlik denetimini çalıştır" diyebiliyorsunuz.

Asistan tabloları listeleyebiliyor, migration uygulayabiliyor, SQL çalıştırabiliyor, güvenlik denetimini çalıştırabiliyor, logları sorgulayabiliyor, Edge Function yayınlayabiliyor ve Supabase dokümanında arama yapabiliyor.

Bu sunumun Supabase projesi de bir asistanla kuruldu: tablo, kurallar, demo hesapları ve kuralların gerçek isteklerle testi.

`[→]`

### Slayt 33 — Asistanı panelden bağla · 0:30

Bağlamak için projenin ana sayfasında **Get connected → MCP** kartı var. Asistanınızı seçiyorsunuz, size hazır bir yapılandırma veriyor.

Adres `mcp.supabase.com/mcp`. Kişisel anahtar oluşturmanız gerekmiyor; tarayıcıda Supabase hesabınızla onaylıyorsunuz. Aynı ekranda salt okuma modu, tek projeye sınırlama ve hangi araçların açık olacağı seçilebiliyor.

`[→]`

### Slayt 34 — Supabase MCP: sınırlar ve dikkat · 1:10

Asistana veritabanınızı açmak güçlü ama dikkat ister. Bunlar Supabase'in kendi önerileri:

**Canlı projeye değil, geliştirme projesine bağlayın.** Asistan yanlış bir migration yazarsa gerçek kullanıcılar etkilenmesin.

**Salt okuma modunu ve tek projeye sınırlamayı kullanın.** Asistanın her işlemini okuyup onaylayın.

Ve en ince nokta: **veritabanındaki veri, asistan için talimat gibi görünebilir.** Bir kullanıcı uygulamanıza "tüm tabloları sil" yazan bir mesaj gönderirse ve asistan o tabloyu okursa… Okunan veri komut değildir; asistanınızın da bunu bilmesi gerekir.

Kendi deneyimim: bu projede MCP bağlantısının yetkisi bir noktada yetmedi. Aynı işleri **Supabase CLI** ile tamamladık. Asistan bir araç; CLI ve panel her zaman yedek yol.

`[→]`

### Slayt 35 — Bölüm: Planlar · 0:05

Son olarak, kısaca fiyatlar.

`[→]`

### Slayt 36 — Ne zaman ücretli plana geçmeli? · 1:00

Ücretsiz plan öğrenmek ve küçük projeler için gerçekten cömert: 500 MB veritabanı, 50 bin aylık kullanıcı, 1 GB dosya.

Pro ayda **25 dolardan** başlıyor. Ne zaman geçmeli?
Gerçek kullanıcılar geldiğinde, çünkü ücretsiz planda **yedek yok.**
Projenin **uyumaması** gerektiğinde.
Ve ücretsiz kotalar yetmediğinde.

İçiniz rahat olsun: Pro'da **harcama limiti varsayılan olarak açık**, sürpriz fatura gelmiyor.

Bu rakamları birkaç gün önce Supabase'in sitesinden kontrol ettim; değişebilir, kendi projeniz için tekrar bakın.

`[→]`

### Slayt 37 — Kendi projene başlarken · 0:45

Kendi projenizde izleyebileceğiniz sıra bu. Özellikle üç ve sekizi vurgulamak istiyorum: **her tabloda RLS** ve en sonda **Security Advisor.**

Yedinci madde de önemli: izin verilen işlemleri değil, **reddedilmesi gerekenleri** de iki farklı kullanıcıyla deneyin. "0 satır silindi" bulgusu tam olarak böyle çıktı.

`[→]`

### Slayt 38 — Örnek proje · 2:30

Bütün anlattıklarımın çalışan hali bu repoda. QR'ı okutabilirsiniz.

Flutter uygulaması, Supabase migration'ı ve bu sunumun kendisi aynı yerde. README'deki adımlarla kendi ücretsiz projenizde birkaç dakikada çalıştırabilirsiniz.

*(Uygulamaya geç. İki tarayıcı penceresi yan yana: solda Ayşe, sağda Mehmet.)*

Şimdi iki dakikalık hızlı bir tur:

1. **Realtime:** Ayşe bir soru gönderiyor… ve Mehmet'in ekranına yenilemeden düşüyor. Az önce anlattığımız `stream`.
2. **RLS:** Geliştirici modunu açıyorum; artık Mehmet, Ayşe'nin sorusunda da Sil butonunu görüyor. Siliyor… **"0 satır silindi."** Buton göründü ama veritabanı izin vermedi.
3. **Kodda nerede?** Bağlantı `main.dart`'ta, sorgular tek dosyada, kurallar migration dosyasında.

*(İnternet sorun çıkarırsa: "Yedek kaydı açıyorum" de ve ekran kaydını oynat.)*

`[→]`

### Slayt 39 — Teşekkürler · Soru-cevap (3:00)

Teşekkür ederim. Sorularınızı alayım.

*(Sorular için Bölüm 1.12'deki tabloya bak. Bilmediğin bir şey sorulursa: "Kontrol edip repoya not olarak ekleyeyim" demek tamamen yeterli.)*

---

## Prova kontrol listesi

- [ ] Supabase projesi aktif mi? (Ücretsiz proje 1 hafta hareketsizlikte duraklatılır; etkinlikten bir gün önce panele gir.)
- [ ] Demo hesaplarının şifreleri `.secrets/demo-users.env` içinde, iki tarayıcı penceresinde önceden giriş yapılmış.
- [ ] Yedek ekran kaydı masaüstünde.
- [ ] QR kodu telefonla okutulup test edildi.
- [ ] Sunum `npm run dev` ile açık, konuşmacı notları için `/presenter` görünümü ikinci ekranda.
- [ ] Rakamlar (fiyat, limit) son bir kez supabase.com/pricing'den kontrol edildi.
- [ ] Prova süresi 25–26 dakika.
