# LGS Ödül Avı — Mobil Uygulama Tasarım Brief'i

> claude.ai/design'da yeni projeye yapıştırmak için. Tüm sayısal değerler
> `lib/presentation/theme/` altındaki gerçek token'lardan ve
> `ColorScheme.fromSeed`'in gerçek çıktısından alındı — tahmin yok.

---

## 1. Ürün

**LGS Ödül Avı** — LGS'ye hazırlanan öğrenciler için ebeveyn kontrollü,
oyunlaştırılmış görev-ödül uygulaması.

Döngü: **görev → tamamla → puan kazan → ödül seç → ebeveyn onaylar.**
Ebeveyn günlük görev oluşturur (ad, ders, saat, süre, puan); çocuk tamamlayarak
puan kazanır ve ikisinin birlikte belirlediği ödül dükkânında harcar; her
harcama ebeveyn onayını bekler. Ana ekran her yıl değişen sınav tarihine geri
sayar.

Flutter · Material 3 · iOS + Android · Türkçe (İngilizce çeviri mevcut).

## 2. Kitle ve ton

- **Birincil:** 8. sınıf öğrencisi, **13-14 yaş**. Kendi telefonunu kullanıyor.
- **İkincil:** ebeveyn — görevi kurar, ödülü onaylar. Aynı uygulamada.

Tasarımın gerilimi tam burada: **çocuksu olursa 14 yaşındaki uygulamayı siler,
kurumsal olursa sınav kaygısını büyütür.** Aradaki bant: enerjik ama ciddi.
Oyun estetiğinin ritmi (ilerleme, rozet, seri) evet — karikatür, maskot, pastel
şeker paleti hayır. Ebeveyn tarafında güven veren, çocuk tarafında ödüllendirici.

## 3. Değiştirilemez kısıtlar (koddan geliyor)

| Ne | Değer | Neden |
|---|---|---|
| Tohum rengi | `#2D6BE4` | Markanın mavisi |
| Ödül rengi | `#F2A03D` | Puan/ödül ekonomisinin rengi |
| Boşluk merdiveni | 4 · 8 · 12 · 16 · 24 · 32 · 48 | `AppSpacing` |
| Yarıçap | 8 · 12 · 16 · 24 · 999 | `AppRadii` — kart 16, düğme 12, rozet 999 |
| Tip ölçeği | 48/700 · 28/700 · 20/600 · 15/400 · 13/600 · 12/400 | `AppTypography` |
| Düğme yüksekliği | 48 px | `FilledButton` teması |
| Kart yükseltisi | 0 (gölge yok) | Ayrım yüzey tonu veya ince sınır ile |

**Turuncu ve kırmızı geri sayımda kullanılmaz.** Sınava geri sayımda sıcak renk
alarm gibi okunuyor; geri sayım her zaman mavi. Amber **yalnızca** ödül
ekonomisinde: puan rozeti, ödül kartı, kazanım. Bu kural kodda yazılı, korunmalı.

## 4. Renk — gerçek değerler

**Önemli bulgu:** bugünkü `ColorScheme.fromSeed(seedColor: #2D6BE4)`
`primary`'yi **`#485D92`** yapıyor — donuk bir arduvaz mavisi, tohumun kendisi
değil. Material 3'ün tonal paleti kromayı düşürüyor. 13-14 yaş için fazla soluk.

Aşağıdaki tüm değerler `dynamicSchemeVariant: DynamicSchemeVariant.vibrant` ile
alındı: tohum korunuyor, `primary` **`#0056D0`** oluyor, değişiklik
`AppTheme._build` içinde tek satır. **Tasarımı bu palet üzerine kur.**

### Açık tema

| Rol | Hex | Rol | Hex |
|---|---|---|---|
| primary | `#0056D0` | onPrimary | `#FFFFFF` |
| primaryContainer | `#DAE2FF` | onPrimaryContainer | `#00409F` |
| secondaryContainer | `#E1DFFF` | reward | `#F2A03D` |
| surface | `#FAF8FF` | onSurface | `#181B25` |
| surfaceContainerLow | `#F2F3FF` | surfaceContainer | `#ECEDFB` |
| surfaceContainerHigh | `#E6E7F5` | onSurfaceVariant | `#424654` |
| outline | `#737785` | outlineVariant | `#C3C6D6` |
| error | `#BA1A1A` | errorContainer | `#FFDAD6` |

### Koyu tema

| Rol | Hex | Rol | Hex |
|---|---|---|---|
| primary | `#B1C5FF` | onPrimary | `#002C71` |
| primaryContainer | `#00409F` | onPrimaryContainer | `#DAE2FF` |
| secondaryContainer | `#434465` | reward (metin) | `#FFC180` |
| surface | `#10131C` | onSurface | `#E0E2EF` |
| surfaceContainerLow | `#181B25` | surfaceContainer | `#1C1F29` |
| surfaceContainerHigh | `#272A34` | onSurfaceVariant | `#C3C6D6` |
| outline | `#8D909F` | outlineVariant | `#424654` |
| error | `#FFB4AB` | errorContainer | `#93000A` |

### Ödül rengi eşleşmeleri

`#F2A03D` üzerine yazı **`#643B00`** (kontrast 4.55) — beyaz **kullanma**,
kontrast 2.13 ile okunmuyor. Koyu temada ödül metni `#FFC180`, zemin
`surfaceContainer`.

### Doğrulanmış kontrast oranları (WCAG)

| Çift | Oran |
|---|---|
| onPrimary `#FFFFFF` / primary `#0056D0` | 6.48 |
| primary `#0056D0` / surface `#FAF8FF` | 6.15 |
| onPrimaryContainer `#00409F` / primaryContainer `#DAE2FF` | 7.30 |
| onReward `#643B00` / reward `#F2A03D` | 4.55 |
| onSurface `#181B25` / surface `#FAF8FF` | 16.31 |
| onSurfaceVariant `#424654` / surface `#FAF8FF` | 8.92 |
| onSurface `#E0E2EF` / surface `#10131C` (koyu) | 14.39 |
| primary `#B1C5FF` / surface `#10131C` (koyu) | 10.87 |
| reward `#FFC180` / surfaceContainer `#1C1F29` (koyu) | 10.33 |

## 5. Tipografi

**Başlık ve rakam:** Bricolage Grotesque (600/700/800)
**Gövde ve etiket:** Plus Jakarta Sans (400/500/600/700)

İkisi de tam Türkçe diyakritik taşıyor: **ı İ ğ Ğ ş Ş ç Ç ö Ö ü Ü**.
Inter, Roboto, Arial kullanma. Geri sayım rakamı Bricolage Grotesque'in
karakterinden faydalanır; gövde metni Plus Jakarta Sans'ta 15 px'te rahat okunur.

| Rol | Boyut | Ağırlık | Yüz | Örnek |
|---|---|---|---|---|
| display | 48 | 700 | Bricolage | `283 gün` |
| headline | 28 | 700 | Bricolage | `Bugünün görevleri` |
| title | 20 | 600 | Jakarta | `LGS'ye kalan` |
| body | 15 | 400 | Jakarta | `Ödülü seçtin — onay bekliyor.` |
| label | 13 | 600 | Jakarta | `Tekrar dene` |
| caption | 12 | 400 | Jakarta | `Sınav tarihi: 13 Haziran 2027` |

## 6. Logo

### Konsept — "Hedef Halkası"

Açık bir ilerleme halkası, ağzında bir yıldız. **Halka = geri sayım/ilerleme,
yıldız = ödül.** Uygulamanın tek cümlesi, iki şekilde. İki eleman, iki marka
rengi; 16 pikselde bile okunur (halka bir "C", yıldız bir nokta olur).

### Geometri (64×64 kutu)

```
Halka:  merkez (32,32), r=22, kalınlık 8, yuvarlak uç
        yay 0°'den 270°'ye (saat yönü) — ağız üst sağda, 90°
        SVG: <path d="M54 32 A22 22 0 1 1 32 10" stroke-width="8"
                    stroke-linecap="round" fill="none"/>
Yıldız: 5 uçlu, merkez (48,16), dış r=11, iç r=4.2, dolu
        halkanın ağzına oturur, çizgiye değmez
Renk:   halka primary, yıldız reward
Boşluk: her yönde en az 16 birim
20 px altında: halka kalınlığı 8→9, yıldız bir tık büyür
```

### Kilitler

- **Yatay:** işaret + iki satır — "LGS" primary renginde, "Ödül Avı" onSurface
- **Dikey:** işaret üstte, tek satır altta, ortalanmış
- **Uygulama simgesi:** primary zemin, **beyaz** halka, amber yıldız

### İstersen 2 alternatif yön de çiz (düşük çözünürlük, karşılaştırma için)

- **B — Flama:** üçgen bir flama, negatif alanında onay işareti. "Görev tamam."
- **C — Monogram:** "Ö" harfi, iki noktası küçük bir yıldız çifti. Tipografik.

## 7. Ekranlar — 390 × 844, açık + koyu

**Sahte kabuk çizme:** iOS durum çubuğu (9:41 · pil · wifi) ve sanal klavye
**çizilmeyecek** — gerçek cihazda üstte kendisi geliyor, çizileni ikiye
katlanmış gösteriyor. Dokunma hedefleri **en az 44 px**, alt navigasyon 56 px.

### 7.1 Açılış (Splash)

Tek renk zemin (`#0056D0` açık / `#10131C` koyu), ortada 128 px işaret, altında
Bricolage 40/800 "Ödül Avı", en altta 132×4 ince yükleniyor çizgisi (dolu kısım
amber) ve 12 px "LGS'ye hazırlanıyoruz".

> Not: Android 12+ / iOS sistem açılış ekranı sadece **tek renk zemin + ortada
> işaret** gösterebiliyor. Yazı ve çizgi uygulamanın kendi ilk karesi olacak;
> zemin ve işaret aynı yerde durduğu için geçiş görünmez olur.

### 7.2 Ana ekran

- **Üst bar:** solda küçük işaret + "LGS Ödül Avı", sağda puan rozeti
  (amber yıldız + `1.240`, pill, `round` yarıçap)
- **Geri sayım kartı** (birincil, `primaryContainer` zemin, yarıçap 16):
  - üstte `title` — "LGS'ye kalan"
  - ortada `display` 48/700 — **"283 gün"** (sınav günü metin "Bugün!" olur)
  - altta `caption` — "Sınav tarihi: 13 Haziran 2027"
  - arka planda çok soluk bir ilerleme halkası (logonun formu, dekoratif)
- **"Bugünün görevleri"** başlığı (`headline`) + gün ilerlemesi "2/5 tamam"
- 3 görev satırı (aşağıda), altında "Tümünü gör" metin düğmesi
- **Alt navigasyon** 4 sekme: Ana sayfa · Görevler · Ödüller · Profil

### 7.3 Görevler

Gün seçici (yatay, bugün seçili) + saate göre sıralı görev listesi.
Bölüm başlıkları: "Sabah" / "Öğleden sonra" / "Akşam".

Örnek görevler (gerçekçi LGS içeriği):

| Ders | Konu | Saat | Süre | Puan | Durum |
|---|---|---|---|---|---|
| Matematik | Çarpanlar ve Katlar | 19:00 | 40 dk | 30 | bekliyor |
| Türkçe | Paragrafta anlam | 20:00 | 30 dk | 25 | bekliyor |
| Fen Bilimleri | Basınç — deneme testi | 17:30 | 25 dk | 20 | tamamlandı |
| İnkılap Tarihi | Millî Uyanış | 16:00 | 20 dk | 15 | kaçırıldı |

### 7.4 Ödül dükkânı

Puan bakiyesi üstte büyük (amber). Kartlar 2'li ızgara, yarıçap 16.
Puanı yetmeyen kartlar soluk + kilit ikonu + "480 puan daha".

| Ödül | Puan |
|---|---|
| 1 saat ekstra oyun | 200 |
| Hafta sonu geç yatma | 350 |
| Sinema bileti | 800 |
| Kablosuz kulaklık | 5.000 |

### 7.5 Ödül talebi — onay bekliyor

Seçilen ödül büyük kartta, altında amber "Onay bekliyor" rozeti ve
"Annen onayladığında haber vereceğiz" açıklaması. Birincil eylem yok — bekleme
durumu. "Talebi geri al" ikincil metin düğmesi.

### 7.6 Ebeveyn onayı

Ebeveynin gördüğü ekran. Talep kartı: çocuğun adı (örnek veri: **Elif**),
istenen ödül, harcanacak puan, kalan bakiye, o hafta tamamlanan görev sayısı
(karar için bağlam). İki eylem: **"Onayla"** (dolu, primary, 48 px) ve
**"Reddet"** (kenarlıklı). Reddederken kısa not alanı.

### 7.7 Durumlar

- **Yükleniyor:** ortada dairesel gösterge, başka hiçbir şey yok
- **Boş:** "Bugün için görev yok." + ebeveyne "Görev ekle" düğmesi
- **Hata:** metin + "Tekrar dene" düğmesi. Gerçek metinler:
  - "İnternet bağlantısı kurulamadı."
  - "Sınav tarihi henüz belirlenmedi."
  - "Bir şeyler ters gitti."

## 8. Bileşenler (ayrı bir sayfada topla)

- **Düğmeler:** dolu (primary, 48 px, yarıçap 12) · tonal · kenarlıklı · metin.
  Her biri için normal / basılı / devre dışı.
- **Görev satırı:** solda ders rengi noktası, ortada başlık + "19:00 · 40 dk",
  sağda puan rozeti ve durum. Üç durum: **bekliyor** (nötr), **tamamlandı**
  (yeşil onay, başlık üzeri çizili değil — soluk), **kaçırıldı** (kenarlık soluk,
  puan gri).
- **Ödül kartı:** görsel alanı, ad, puan (amber), durum. Dört durum:
  **alınabilir** / **puan yetersiz** (kilit) / **onay bekliyor** (amber rozet) /
  **onaylandı** (yeşil onay).
- **Puan rozeti:** pill, amber yıldız + rakam. Küçük (üst bar) ve büyük (dükkân).
- **Geri sayım kartı:** normal · "Bugün!" · hata varyantı.
- **Seri göstergesi:** alev ikonu + "7 gün" — amber, sadece 2+ günde görünür.
- **Alt navigasyon:** 4 sekme, seçili sekme primary + dolgulu ikon.

## 9. İkonografi

Çizgi (stroke) ikonlar, **1.8 px kalınlık, 24 px ızgara, yuvarlak uç ve köşe**.
Emoji kullanma. Gereken set: ana sayfa, görev listesi, hediye, profil, yıldız
(dolu), saat, onay, kilit, alev (seri), uyarı, boş kutu, yenile, sağ ok, artı,
çarpı.

## 10. Kaçınılacaklar

- Emoji, maskot, karikatür illüstrasyon
- Geri sayımda turuncu/kırmızı (alarm okunuyor)
- Beyaz yazı amber üzerine (kontrast 2.13)
- Sahte durum çubuğu veya sahte klavye
- Gradyan bombardımanı, sol kenarı renkli vurgulu yuvarlak kutular
- Inter / Roboto / Arial
- 44 px altında dokunma hedefi, 12 px altında gövde metni

## 11. Teslim beklentisi

Açık ve koyu tema, 390×844 telefon çerçevelerinde:
splash · ana ekran · görevler · ödül dükkânı · ödül talebi · ebeveyn onayı ·
üç durum ekranı · logo sayfası · renk + tipografi + bileşen sayfaları.
