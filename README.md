# LGS Ödül Avı

LGS'ye hazırlanan öğrenciler için **ebeveyn kontrollü, oyunlaştırılmış görev ve
ödül uygulaması**. Akış: görev → tamamla → puan kazan → ödül seç → ebeveyn onaylar.

Flutter · paket `lgs_reward_hunt` · uygulama kimliği `com.lgsrewardhunt.app`

## Özellikler

- **Harita** — her gün bir durak; görevler tamamlandıkça ilerleyen yol ve sınav geri sayımı.
- **Görevler** — derslere göre günlük çalışma planı, süre ve puan.
- **Ödüller** — toplanan puanlarla ailece belirlenen ödülleri isteme; istek ebeveyn onayına düşer.
- **İlerleme** — seri, haftalık grafik, aylık şerit ve rozetler.
- **Profil** — avatar, tema ve renk seçimi, sınav tarihi, bağlı ebeveyn.
- **Ebeveyn modu** — PIN ile girilen ebeveyn sayfası: ödül isteklerini onaylama, görev planı ve ödül havuzu.
- **Giriş** — e-posta, Google ve Apple ile giriş (Firebase Auth).

## Gereksinimler

| Araç | Sürüm |
|---|---|
| Flutter | 3.47 (stable) |
| Dart SDK | ^3.13.2 |
| Xcode | iOS için, güncel sürüm + CocoaPods |
| Android Studio / SDK | Android için |

## Kurulum

```bash
git clone <repo-url> && cd lgs_reward_hunt
flutter pub get
git config core.hooksPath .githooks   # commit öncesi kontrolleri açar (bir kez)
```

### Firebase yapılandırma dosyaları

Repo herkese açık olduğu için Firebase istemci dosyaları **repoda yoktur**
(`.gitignore`). Uygulama bunlar olmadan derlenmez. Altı dosyayı proje
sahibinden alıp yerlerine koyun:

```
android/app/src/dev/google-services.json
android/app/src/prod/google-services.json
ios/config/dev/GoogleService-Info.plist
ios/config/prod/GoogleService-Info.plist
lib/infrastructure/config/firebase/firebase_options_dev.dart
lib/infrastructure/config/firebase/firebase_options_prod.dart
```

Firebase projesine erişiminiz varsa `flutterfire configure` ile de
üretilebilirler. CI bu dosyaları `FIREBASE_CONFIG_ARCHIVE` secret'ından açar
(bkz. [WORKFLOW.md](WORKFLOW.md)).

## Çalıştırma

İki flavor var ve aynı cihaza yan yana kurulabilir:

| Flavor | Uygulama kimliği | Ad |
|---|---|---|
| `dev` | `com.lgsrewardhunt.app.dev` | LGS Ödül Avı Dev |
| `prod` | `com.lgsrewardhunt.app` | LGS Ödül Avı |

```bash
flutter run --flavor dev     # geliştirme
flutter run --flavor prod
```

### Test verisi (mock backend)

Henüz gerçek bir sunucu yok: uygulama bellek içi bir mock backend ile çalışır
(`lib/infrastructure/network/mock/`, içerik `assets/mock/*.json`). Veriler
cihazda saklanır, uygulama silinene kadar kalır.

Hazır demo hesabı:

| | Değer |
|---|---|
| Ebeveyn e-posta | `ayse@ornek.com` |
| Şifre | `lgs12345` |
| Ebeveyn PIN | `1234` |
| Bağlantı kodu | `LGS274` |

Dev sürümünde her ekranda yarı saydam bir test düğmesi bu bilgileri gösterir;
satıra dokunmak değeri kopyalar.

## Geliştirme

Bir değişiklik, aşağıdaki üç adım da yeşil olmadan bitmiş sayılmaz (CI aynısını çalıştırır):

```bash
flutter analyze
dart run tool/check_structure.dart
flutter test
```

Sık kullanılan komutlar:

```bash
dart run build_runner build --delete-conflicting-outputs  # @injectable / @JsonSerializable sonrası
flutter gen-l10n                                          # app_tr.arb değişince
dart run tool/generate_project_map.dart                   # dosya ekleyip taşıdıktan sonra
```

### Mimari

Clean Architecture + DDD, katman → özellik klasörleri:

```
lib/
  core/            ortak tabanlar, sabitler, Failure, doğrulayıcılar
  domain/          entity, value object, read model, kurallar, arayüzler
  application/     use case'ler, sayfa başına bir Cubit, DI
  infrastructure/  repository'ler, servisler, DTO'lar, mock backend
  presentation/    sayfalar, router, ortak UI bileşenleri
```

Bağımlılık yönü: `core ← domain ← application ← infrastructure`;
`presentation` infrastructure'a hiç bağlanmaz. Hatalar istisna değil değerdir
(`Either<Failure, T>`). Tüm metinler `AppL10n` üzerinden Türkçedir.

Ayrıntılar:

- [CLAUDE.md](CLAUDE.md) — kurallar
- [architecture.md](architecture.md) — kuralların gerekçesi
- [PROJECT-MAP.md](PROJECT-MAP.md) — dosya haritası (otomatik üretilir)
- [BUILD-PLAN.md](BUILD-PLAN.md) — açık işler
- [docs/regressions.md](docs/regressions.md) — geçmiş hata sınıfları ve korumaları

## Yayın

Akış [WORKFLOW.md](WORKFLOW.md)'de: `dev`'den dal → kontroller → PR `dev`'e →
squash merge. `dev`'e merge, dev sürümünü Firebase App Distribution ve
TestFlight'a gönderir; `dev` → `main` bir sürümdür ve prod'u Firebase, Google
Play dahili test ve TestFlight'a gönderir. Her derleme obfuscate edilir. Sürüm
notları [CHANGELOG.md](CHANGELOG.md)'dedir.

```bash
flutter build appbundle --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android
```
