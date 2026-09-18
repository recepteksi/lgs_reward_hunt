# Changelog

What changed in each version, newest first, in the words a tester would use.
The `## [Unreleased]` section collects notes as work lands on `dev`;
`dart run tool/bump_version.dart <part>` stamps it with the new version and the
date. CI reads the top section: it becomes the release notes on Firebase App
Distribution and the "what's new" text on Google Play, so this file is what
testers actually read.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) ·
Versions: [semantic](https://semver.org/lang/tr/).

## [Unreleased]

### Eklendi

- Ebeveyn sayfasında "Hesaptan çıkış yap" düğmesi. Sayfa yüklenemese bile görünür.

### Düzeltildi

- Yeni hesap açıp uygulamayı kapatınca veriler kayboluyordu ve her sayfa hata veriyordu. Test verileri artık cihazda saklanıyor.
- Profil yüklenemediğinde tema ayarı ve ebeveyn modu da kayboluyordu. Artık hata olsa da görünüyorlar.

## [1.1.0] - 2026-09-18

### Eklendi

- Dev sürümünde her ekranda yarı saydam bir test düğmesi: basınca test hesaplarının e-posta, şifre, PIN ve bağlantı kodları görünür; satıra dokunmak değeri kopyalar.
- Sürüm notları bu dosyadan geliyor: Firebase ve Play'de testçilerin okuduğu metin `CHANGELOG.md`'nin en üst sürümü.

## [1.0.0] - 2026-09-18

İlk dahili test sürümü.

### Eklendi

- Harita: her gün bir durak, görevleri tamamladıkça ilerleyen yol ve sınav geri sayımı.
- Ödüller: toplanan puanlarla ailece belirlenen ödüllerin istenmesi, ebeveyn onayına düşmesi.
- İlerleme: seri, haftalık grafik, aylık şerit ve rozetler.
- Profil: tema ve renk seçimi, sınav tarihi, bağlı ebeveyn.
- Ebeveyn modu: PIN'li giriş, görev planı, ödül havuzu, istek onayları ve görev düzenleme.
- Kurulum akışı: tanıtım, hesap, şifre, ebeveyn PIN'i, çocuk, görev ve ödül kurulumu, cihaz seçimi.
- Google ve Apple ile giriş (Firebase Auth).

### Notlar

- Veriler bu sürümde yalnızca cihazda tutulur ve uygulama kapanınca sıfırlanır; gerçek sunucu henüz yok.
