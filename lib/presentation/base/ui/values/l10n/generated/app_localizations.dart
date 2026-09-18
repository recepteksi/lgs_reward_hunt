import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// Uygulamanın adı.
  ///
  /// In tr, this message translates to:
  /// **'LGS Ödül Avı'**
  String get appTitle;

  /// Seri göstergesi. Yalnızca 2 ve üzeri gün için gösterilir; Türkçede tek çoğul biçim var.
  ///
  /// In tr, this message translates to:
  /// **'{days, plural, other{{days} gün}}'**
  String streakDays(int days);

  /// Görev satırındaki kazanılacak puan. P harfi 'puan' kısaltması.
  ///
  /// In tr, this message translates to:
  /// **'+{points}P'**
  String taskPointsAward(int points);

  /// Henüz açılmamış görevin puanı; artı işareti yok çünkü kazanılmış değil.
  ///
  /// In tr, this message translates to:
  /// **'{points}P'**
  String taskPointsLocked(int points);

  /// Tema cihazın ayarını izler.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeModeSystem;

  /// Açık tema.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeModeLight;

  /// Koyu tema.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeModeDark;

  /// Renk yolu adı.
  ///
  /// In tr, this message translates to:
  /// **'Mavi'**
  String get accentBlue;

  /// Renk yolu adı.
  ///
  /// In tr, this message translates to:
  /// **'Pembe'**
  String get accentPink;

  /// Renk yolu adı.
  ///
  /// In tr, this message translates to:
  /// **'Yeşil'**
  String get accentGreen;

  /// Renk yolu adı.
  ///
  /// In tr, this message translates to:
  /// **'Sarı'**
  String get accentYellow;

  /// Renk yolu adı.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı'**
  String get accentRed;

  /// Gün halkasının ortasındaki oran: tamamlanan / toplam görev.
  ///
  /// In tr, this message translates to:
  /// **'{completed}/{total}'**
  String progressRatio(int completed, int total);

  /// Ödül kartındaki rakamın altındaki birim.
  ///
  /// In tr, this message translates to:
  /// **'puan'**
  String get pointsUnit;

  /// Alt navigasyon: harita sekmesi.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get navHome;

  /// Alt navigasyon: ödül dükkânı.
  ///
  /// In tr, this message translates to:
  /// **'Ödüller'**
  String get navRewards;

  /// Alt navigasyon: istatistikler.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get navProgress;

  /// Alt navigasyon: profil ve ayarlar.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Alt navigasyonun ortasındaki ebeveyn modu düğmesi.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn'**
  String get navParent;

  /// Yükleme göstergesinin altındaki söz.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get commonLoading;

  /// Tanıtımı atla.
  ///
  /// In tr, this message translates to:
  /// **'Geç'**
  String get introSkip;

  /// Tanıtımda sonraki slayt.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get introContinue;

  /// İlk tanıtım slaytının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Görevleri bitir,\nhazineyi aç.'**
  String get introTitleOne;

  /// İlk tanıtım slaytının metni.
  ///
  /// In tr, this message translates to:
  /// **'Her gün haritada bir durak. Ailenle birlikte belirlediğiniz görevleri tamamla, puan topla, ödül havuzundan istediğini seç.'**
  String get introBodyOne;

  /// İkinci tanıtım slaytının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Her gün bir durak,\nbirkaç görev.'**
  String get introTitleTwo;

  /// İkinci tanıtım slaytının metni.
  ///
  /// In tr, this message translates to:
  /// **'Ailenle belirlediğiniz görevler her sabah haritada karşına çıkar. Bitirdikçe puan kazanır, patikada bir durak ilerlersin.'**
  String get introBodyTwo;

  /// Üçüncü tanıtım slaytının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Puanlar ödüle\ndönüşür.'**
  String get introTitleThree;

  /// Üçüncü tanıtım slaytının metni.
  ///
  /// In tr, this message translates to:
  /// **'Biriken puanla ödül havuzundan seçim yaparsın. Her talep ebeveyn onayından geçer, böylece ödül ikinizin kararı olur.'**
  String get introBodyThree;

  /// Tanıtımın sonundaki birincil eylem.
  ///
  /// In tr, this message translates to:
  /// **'Hesap oluştur'**
  String get introCreateAccount;

  /// İlk tanıtım slaytındaki amblemin üzerindeki yazı.
  ///
  /// In tr, this message translates to:
  /// **'LGS'**
  String get introEmblemMark;

  /// Amblemin köşesindeki puan rozeti; P harfi 'puan' kısaltması.
  ///
  /// In tr, this message translates to:
  /// **'P'**
  String get introEmblemPoints;

  /// İkinci tanıtım slaytındaki örnek günün başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün görevleri'**
  String get introTasksTitle;

  /// Örnek günün hangi durak olduğu ve toplam puanı.
  ///
  /// In tr, this message translates to:
  /// **'{stop}. durak · {points}P'**
  String introTasksMeta(int stop, int points);

  /// Tanıtımdaki örnek görev: ders.
  ///
  /// In tr, this message translates to:
  /// **'Matematik'**
  String get introSampleMathTitle;

  /// Tanıtımdaki örnek görev: konu ve süre.
  ///
  /// In tr, this message translates to:
  /// **'Çarpanlar ve katlar · 30 dk'**
  String get introSampleMathMeta;

  /// Tanıtımdaki örnek görev: ders.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get introSampleTurkishTitle;

  /// Tanıtımdaki örnek görev: konu ve süre.
  ///
  /// In tr, this message translates to:
  /// **'Paragrafta anlam · 25 dk'**
  String get introSampleTurkishMeta;

  /// Tanıtımdaki örnek görev: ders.
  ///
  /// In tr, this message translates to:
  /// **'Fen Bilimleri'**
  String get introSampleScienceTitle;

  /// Tanıtımdaki örnek görev: konu ve süre.
  ///
  /// In tr, this message translates to:
  /// **'Basınç · 25 dk'**
  String get introSampleScienceMeta;

  /// Tanıtımdaki örnek görev: ders.
  ///
  /// In tr, this message translates to:
  /// **'Okuma'**
  String get introSampleReadingTitle;

  /// Tanıtımdaki örnek görev: konu ve süre.
  ///
  /// In tr, this message translates to:
  /// **'20 sayfa kitap · 20 dk'**
  String get introSampleReadingMeta;

  /// Üçüncü tanıtım slaytındaki bakiye kartının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Puan hesabın'**
  String get introBalanceTitle;

  /// Üçüncü tanıtım slaytındaki örnek bakiye.
  ///
  /// In tr, this message translates to:
  /// **'{points} puan birikti'**
  String introBalanceMeta(int points);

  /// Üçüncü tanıtım slaytındaki örnek ödül.
  ///
  /// In tr, this message translates to:
  /// **'Sinema bileti'**
  String get introRewardName;

  /// Örnek ödülün bedeli.
  ///
  /// In tr, this message translates to:
  /// **'{points} puan'**
  String introRewardCost(int points);

  /// Örnek talebin durumu.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get introRewardPending;

  /// Örnek talebin altındaki not.
  ///
  /// In tr, this message translates to:
  /// **'Annen onayladığında haber vereceğiz.'**
  String get introRewardNote;

  /// Kayıt/giriş ekranının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn hesabı'**
  String get authTitle;

  /// Kayıt/giriş ekranının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Görevleri ve ödül havuzunu sen kuruyorsun. Çocuğunun hesabını da bu hesaptan açacaksın.'**
  String get authBody;

  /// Yeni hesap sekmesi.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ol'**
  String get authTabSignUp;

  /// Mevcut hesap sekmesi.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get authTabSignIn;

  /// Sosyal giriş ile form arasındaki ayırıcı.
  ///
  /// In tr, this message translates to:
  /// **'veya e-posta ile'**
  String get authOrEmail;

  /// Kayıt formunun altındaki yasal not.
  ///
  /// In tr, this message translates to:
  /// **'Devam ederek Kullanım Koşulları ve Gizlilik Politikası\'nı kabul ediyorsun.'**
  String get authTerms;

  /// Ad soyad alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'AD SOYAD'**
  String get fieldFullName;

  /// Ad soyad alanının ipucu.
  ///
  /// In tr, this message translates to:
  /// **'Adın ve soyadın'**
  String get fieldFullNameHint;

  /// E-posta alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'E-POSTA'**
  String get fieldEmail;

  /// E-posta alanının ipucu.
  ///
  /// In tr, this message translates to:
  /// **'ornek@eposta.com'**
  String get fieldEmailHint;

  /// Şifre alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'ŞİFRE'**
  String get fieldPassword;

  /// Giriş ekranındaki şifre ipucu.
  ///
  /// In tr, this message translates to:
  /// **'Hesap şifren'**
  String get fieldPasswordHint;

  /// Şifre tekrar alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'ŞİFRE TEKRAR'**
  String get fieldPasswordRepeat;

  /// Şifre belirleme ekranının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Şifre belirle'**
  String get passwordTitle;

  /// Şifre belirleme ekranının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Ödül onaylarına ve ebeveyn paneline girerken bu şifreyi kullanacaksın. Çocuğunla paylaşma.'**
  String get passwordBody;

  /// Şifreyi açık göster.
  ///
  /// In tr, this message translates to:
  /// **'Göster'**
  String get passwordShow;

  /// Şifreyi gizle.
  ///
  /// In tr, this message translates to:
  /// **'Gizle'**
  String get passwordHide;

  /// İki şifre alanı uyuşmuyor.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler aynı değil.'**
  String get passwordMismatch;

  /// Şifre kuralı: uzunluk.
  ///
  /// In tr, this message translates to:
  /// **'En az 8 karakter'**
  String get passwordRuleLength;

  /// Şifre kuralı: rakam.
  ///
  /// In tr, this message translates to:
  /// **'Bir rakam'**
  String get passwordRuleDigit;

  /// Şifre kuralı: büyük harf.
  ///
  /// In tr, this message translates to:
  /// **'Bir büyük harf'**
  String get passwordRuleUppercase;

  /// PIN'in ilk aşaması.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn PIN\'i belirle'**
  String get pinTitleSet;

  /// PIN'in ikinci aşaması.
  ///
  /// In tr, this message translates to:
  /// **'PIN\'i tekrar gir'**
  String get pinTitleRepeat;

  /// PIN'in ilk aşamasının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn moduna geçişte 4 haneli bu kod sorulur. Şifreden ayrı, hızlı giriş için.'**
  String get pinBodySet;

  /// PIN'in ikinci aşamasının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Aynı 4 haneyi bir daha gir; yanlış yazarsan baştan başlayacağız.'**
  String get pinBodyRepeat;

  /// PIN ekranının altındaki not.
  ///
  /// In tr, this message translates to:
  /// **'PIN\'i çocuğunla paylaşma; ebeveyn moduna her geçişte sorulacak.'**
  String get pinNote;

  /// Kurulum adımı adı.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt'**
  String get setupStepAccount;

  /// Kurulum adımı adı.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get setupStepPassword;

  /// Kurulum adımı adı.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn PIN\'i'**
  String get setupStepPin;

  /// Kurulum adımı adı.
  ///
  /// In tr, this message translates to:
  /// **'Çocuk'**
  String get setupStepChild;

  /// Kurulum adımı adı.
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get setupStepTasks;

  /// Kurulum adımı adı.
  ///
  /// In tr, this message translates to:
  /// **'Ödüller'**
  String get setupStepRewards;

  /// Kurulumda kaçıncı adımda olduğumuz.
  ///
  /// In tr, this message translates to:
  /// **'{index}/{total}'**
  String setupStepCount(int index, int total);

  /// Bir adım geri.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get commonBack;

  /// Bir adım ileri.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get commonContinue;

  /// E-posta biçimi hatalı.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi geçerli görünmüyor.'**
  String get failureEmailInvalid;

  /// Şifre kısa.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 8 karakter olmalı.'**
  String get failurePasswordTooShort;

  /// Şifre kuralları eksik.
  ///
  /// In tr, this message translates to:
  /// **'Şifrede bir rakam ve bir büyük harf olmalı.'**
  String get failurePasswordTooWeak;

  /// Giriş başarısız.
  ///
  /// In tr, this message translates to:
  /// **'E-posta ya da şifre hatalı.'**
  String get failureCredentialsInvalid;

  /// E-posta kayıtlı.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile bir hesap zaten var.'**
  String get failureEmailInUse;

  /// PIN biçimi hatalı.
  ///
  /// In tr, this message translates to:
  /// **'PIN 4 haneli olmalı.'**
  String get failurePinInvalid;

  /// İki PIN girişi uyuşmadı.
  ///
  /// In tr, this message translates to:
  /// **'Kodlar aynı değil, baştan deneyelim.'**
  String get failurePinMismatch;

  /// Oturum yok.
  ///
  /// In tr, this message translates to:
  /// **'Önce giriş yapman gerekiyor.'**
  String get failureNotSignedIn;

  /// Hata durumunda yeniden deneme düğmesi.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get commonRetry;

  /// Çocuk kurulumu ekranının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğunu ekle'**
  String get childSetupTitle;

  /// Çocuk kurulumu ekranının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Her çocuğun kendi görev haritası ve puan hesabı olur. Şimdilik en fazla {max} çocuk ekleyebilirsin.'**
  String childSetupBody(int max);

  /// Ebeveyn kartındaki giriş yöntemi rozeti.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get childSetupParentVia;

  /// Yeni çocuk formunu açan düğme.
  ///
  /// In tr, this message translates to:
  /// **'Çocuk ekle'**
  String get childSetupAdd;

  /// Çocuk sınırına ulaşıldığında gösterilen not.
  ///
  /// In tr, this message translates to:
  /// **'{max} çocuk sınırına ulaştın. Daha fazlası için ebeveyn panelinden talep gönderebilirsin.'**
  String childSetupLimit(int max);

  /// Hiç çocuk yokken devam düğmesinin yazısı.
  ///
  /// In tr, this message translates to:
  /// **'En az bir çocuk ekle'**
  String get childSetupNeedOne;

  /// Çocuk satırındaki sınıf ve avatar bilgisi.
  ///
  /// In tr, this message translates to:
  /// **'{grade}. sınıf · {avatar} avatarı'**
  String childSetupRowMeta(int grade, String avatar);

  /// Avatarı olmayan çocuğun satırındaki bilgi.
  ///
  /// In tr, this message translates to:
  /// **'{grade}. sınıf'**
  String childSetupRowMetaNoAvatar(int grade);

  /// Çocuk satırındaki kaldırma düğmesinin ekran okuyucu etiketi.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğu kaldır'**
  String get childSetupRemove;

  /// Çocuk formunun başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Çocuk bilgileri'**
  String get childFormTitle;

  /// Çocuğun adı alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'ADI'**
  String get childFormName;

  /// Çocuğun adı alanının ipucu.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğunun adı'**
  String get childFormNameHint;

  /// Sınıf seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'SINIFI'**
  String get childFormGrade;

  /// Sınıf seçeneği.
  ///
  /// In tr, this message translates to:
  /// **'{grade}. sınıf'**
  String childFormGradeOption(int grade);

  /// Avatar seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'AVATARI'**
  String get childFormAvatar;

  /// Avatar kataloğunun kız sekmesi.
  ///
  /// In tr, this message translates to:
  /// **'Kız'**
  String get childFormGirl;

  /// Avatar kataloğunun erkek sekmesi.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get childFormBoy;

  /// Avatarlar yüklenirken gösterilen not.
  ///
  /// In tr, this message translates to:
  /// **'Avatar kataloğu sunucudan yükleniyor…'**
  String get childFormAvatarsLoading;

  /// Avatar kataloğu yüklenemediğinde gösterilen cümle.
  ///
  /// In tr, this message translates to:
  /// **'Avatarlar yüklenemedi.'**
  String get childFormAvatarsFailed;

  /// Henüz avatar seçilmemişken gösterilen not.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğun için bir avatar seç.'**
  String get childFormAvatarPick;

  /// Seçilen avatarın adı.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen avatar: {name}'**
  String childFormAvatarPicked(String name);

  /// Çocuk formunu kaydeden düğme.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğu ekle'**
  String get childFormSave;

  /// Çocuk adı boş.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğunun adını yaz.'**
  String get failureChildNameEmpty;

  /// Geçersiz sınıf.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf 7 ya da 8 olmalı.'**
  String get failureChildGradeInvalid;

  /// Avatar seçilmemiş.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğun için bir avatar seç.'**
  String get failureChildAvatarMissing;

  /// Çocuk sınırı dolu.
  ///
  /// In tr, this message translates to:
  /// **'Bu hesaba daha fazla çocuk eklenemez.'**
  String get failureChildLimitReached;

  /// Görev kurulumu sayfasının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Günlük görevler'**
  String get taskSetupTitle;

  /// Görev kurulumu sayfasının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Standart bir çalışma günü hazırladık. Silebilir, düzenleyebilir, yenilerini ekleyebilirsin — sonra ebeveyn panelinden de değişir.'**
  String get taskSetupBody;

  /// Görev listesinin üstündeki özet.
  ///
  /// In tr, this message translates to:
  /// **'{lessons} ders · {chores} sorumluluk · bugün {points}P'**
  String taskSetupSummary(int lessons, int chores, int points);

  /// Plan boşken özet satırı.
  ///
  /// In tr, this message translates to:
  /// **'Henüz görev yok'**
  String get taskSetupEmpty;

  /// Görev satırındaki konu, saat ve süre.
  ///
  /// In tr, this message translates to:
  /// **'{topic} · {time} · {minutes} dk'**
  String taskMeta(String topic, String time, int minutes);

  /// Plana yeni görev ekleyen düğme.
  ///
  /// In tr, this message translates to:
  /// **'Görev ekle'**
  String get taskSetupAdd;

  /// Plan boşken devam düğmesinin yazısı.
  ///
  /// In tr, this message translates to:
  /// **'En az bir görev ekle'**
  String get taskSetupNeedOne;

  /// Görev satırındaki silme düğmesinin ekran okuyucu etiketi.
  ///
  /// In tr, this message translates to:
  /// **'Görevi sil'**
  String get taskSetupRemove;

  /// Görev türü seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'TÜR'**
  String get taskSetupKind;

  /// Ders seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'DERS'**
  String get taskSetupCategoryLesson;

  /// Sorumluluk seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'SORUMLULUK'**
  String get taskSetupCategoryChore;

  /// Dersin konu alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'KONU'**
  String get taskSetupTopicLesson;

  /// Sorumluluğun açıklama alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'AÇIKLAMA'**
  String get taskSetupTopicChore;

  /// Konu alanının ipucu.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Çarpanlar ve katlar'**
  String get taskSetupTopicHintLesson;

  /// Açıklama alanının ipucu.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Masa ve yatak'**
  String get taskSetupTopicHintChore;

  /// Saat seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'SAAT'**
  String get taskSetupTime;

  /// Süre seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'SÜRE'**
  String get taskSetupDuration;

  /// Süre seçeneği.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk'**
  String taskSetupMinutes(int minutes);

  /// Puan sayacının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'PUAN'**
  String get taskSetupPoints;

  /// Tekrar seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'SIKLIK'**
  String get taskSetupRepeat;

  /// Görev türü: ders.
  ///
  /// In tr, this message translates to:
  /// **'Ders'**
  String get taskKindLesson;

  /// Görev türü: ev sorumluluğu.
  ///
  /// In tr, this message translates to:
  /// **'Sorumluluk'**
  String get taskKindChore;

  /// Ders.
  ///
  /// In tr, this message translates to:
  /// **'Matematik'**
  String get taskCategoryMath;

  /// Ders.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get taskCategoryTurkish;

  /// Ders.
  ///
  /// In tr, this message translates to:
  /// **'Fen Bilimleri'**
  String get taskCategoryScience;

  /// Ders.
  ///
  /// In tr, this message translates to:
  /// **'İnkılap Tarihi'**
  String get taskCategoryHistory;

  /// Ders.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get taskCategoryEnglish;

  /// Ders.
  ///
  /// In tr, this message translates to:
  /// **'Okuma'**
  String get taskCategoryReading;

  /// Ders.
  ///
  /// In tr, this message translates to:
  /// **'Deneme sınavı'**
  String get taskCategoryPracticeExam;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Diş fırçalama'**
  String get taskCategoryBrushTeeth;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Oda toplama'**
  String get taskCategoryTidyRoom;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Bulaşık'**
  String get taskCategoryDishes;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Çöp atma'**
  String get taskCategoryTrash;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır'**
  String get taskCategoryLaundry;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Su içme'**
  String get taskCategoryDrinkWater;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Spor'**
  String get taskCategoryExercise;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Erken yatma'**
  String get taskCategoryEarlyBed;

  /// Sorumluluk.
  ///
  /// In tr, this message translates to:
  /// **'Ekransız saat'**
  String get taskCategoryScreenFree;

  /// Tekrar: yalnızca bir gün.
  ///
  /// In tr, this message translates to:
  /// **'Bir kez'**
  String get taskRepeatOnce;

  /// Tekrar.
  ///
  /// In tr, this message translates to:
  /// **'Her gün'**
  String get taskRepeatDaily;

  /// Tekrar.
  ///
  /// In tr, this message translates to:
  /// **'Hafta içi'**
  String get taskRepeatWeekdays;

  /// Tekrar.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu'**
  String get taskRepeatWeekend;

  /// Tekrar.
  ///
  /// In tr, this message translates to:
  /// **'Haftada bir'**
  String get taskRepeatWeekly;

  /// Boş plan.
  ///
  /// In tr, this message translates to:
  /// **'En az bir görev ekle.'**
  String get failureTaskPlanEmpty;

  /// Konusu boş görev.
  ///
  /// In tr, this message translates to:
  /// **'Her görevin bir konusu ya da açıklaması olmalı.'**
  String get failureTaskTitleEmpty;

  /// Geçersiz puan.
  ///
  /// In tr, this message translates to:
  /// **'Görev puanı izin verilen aralığın dışında.'**
  String get failureTaskPointsInvalid;

  /// Geçersiz süre.
  ///
  /// In tr, this message translates to:
  /// **'Görev süresi izin verilen aralığın dışında.'**
  String get failureTaskDurationInvalid;

  /// Tür ile kategori uyuşmazlığı.
  ///
  /// In tr, this message translates to:
  /// **'Görevin türü ile konusu uyuşmuyor.'**
  String get failureTaskCategoryInvalid;

  /// Geçersiz saat.
  ///
  /// In tr, this message translates to:
  /// **'Görev saati geçerli değil.'**
  String get failureTaskTimeInvalid;

  /// Ödül kurulumu sayfasının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Ödül havuzu'**
  String get rewardSetupTitle;

  /// Ödül kurulumu sayfasının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Puanların harcanacağı ödüller. Bunlar da bir başlangıç; çocuğunla birlikte değiştirin.'**
  String get rewardSetupBody;

  /// Ödül listesinin üstündeki özet: sayı ve fiyat aralığı.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, other{{count} ödül}} · {cheapest}P–{dearest}P'**
  String rewardSetupSummary(int count, int cheapest, int dearest);

  /// Havuz boşken özet satırı.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ödül yok'**
  String get rewardSetupEmpty;

  /// Havuza yeni ödül ekleyen düğme.
  ///
  /// In tr, this message translates to:
  /// **'Ödül ekle'**
  String get rewardSetupAdd;

  /// Ödül satırındaki silme düğmesinin ekran okuyucu etiketi.
  ///
  /// In tr, this message translates to:
  /// **'Ödülü sil'**
  String get rewardSetupRemove;

  /// Ödül adı alanının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'ÖDÜL'**
  String get rewardSetupName;

  /// Ödül adı alanının ipucu.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Sinema bileti'**
  String get rewardSetupNameHint;

  /// Ödül kategorisi seçiminin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'KATEGORİ'**
  String get rewardSetupCategory;

  /// Ödül fiyatı sayacının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'PUAN'**
  String get rewardSetupCost;

  /// Kurulumu bitiren birincil eylem.
  ///
  /// In tr, this message translates to:
  /// **'Kurulumu bitir'**
  String get rewardSetupFinish;

  /// Havuz boşken birincil düğmenin yazısı.
  ///
  /// In tr, this message translates to:
  /// **'En az bir ödül ekle'**
  String get rewardSetupNeedOne;

  /// Açık bir satırı ya da paneli kapatan onay.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get commonDone;

  /// Puan sayacının eksi düğmesi.
  ///
  /// In tr, this message translates to:
  /// **'Puan azalt'**
  String get commonPointsDown;

  /// Puan sayacının artı düğmesi.
  ///
  /// In tr, this message translates to:
  /// **'Puan artır'**
  String get commonPointsUp;

  /// Ödül kategorisi.
  ///
  /// In tr, this message translates to:
  /// **'Ekran'**
  String get rewardCategoryScreen;

  /// Ödül kategorisi.
  ///
  /// In tr, this message translates to:
  /// **'Eğlence'**
  String get rewardCategoryFun;

  /// Ödül kategorisi.
  ///
  /// In tr, this message translates to:
  /// **'Lezzet'**
  String get rewardCategoryTreat;

  /// Ödül kategorisi.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal'**
  String get rewardCategorySocial;

  /// Ödül kategorisi.
  ///
  /// In tr, this message translates to:
  /// **'Serbest'**
  String get rewardCategoryFree;

  /// Boş ödül havuzu.
  ///
  /// In tr, this message translates to:
  /// **'En az bir ödül ekle.'**
  String get failureRewardPoolEmpty;

  /// Adı boş ödül.
  ///
  /// In tr, this message translates to:
  /// **'Her ödülün bir adı olmalı.'**
  String get failureRewardNameEmpty;

  /// Geçersiz ödül fiyatı.
  ///
  /// In tr, this message translates to:
  /// **'Ödül puanı izin verilen aralığın dışında.'**
  String get failureRewardCostInvalid;

  /// Yetersiz bakiye.
  ///
  /// In tr, this message translates to:
  /// **'Bu ödül için puanın yetmiyor.'**
  String get failureInsufficientPoints;

  /// Karara bağlanmış talep.
  ///
  /// In tr, this message translates to:
  /// **'Bu talep zaten yanıtlandı.'**
  String get failureRedemptionNotPending;

  /// Cihaz adımının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazı kim kullanıyor?'**
  String get deviceChildTitle;

  /// Cihaz adımının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama seçtiğin çocuğun haritasını açar. Ebeveyn modundan her zaman diğerine geçebilirsin.'**
  String get deviceChildBody;

  /// Çocuk satırındaki sınıf ve bakiye.
  ///
  /// In tr, this message translates to:
  /// **'{grade}. sınıf · {points} puan'**
  String deviceChildRowMeta(int grade, int points);

  /// Cihaz adımının altındaki not.
  ///
  /// In tr, this message translates to:
  /// **'İki çocuğunun verileri ayrı tutulur; ebeveyn modunda hangisinin seçili olduğunu değiştirebilirsin.'**
  String get deviceChildNote;

  /// Haritanın üst çubuğunda çocuğun adının altındaki satır.
  ///
  /// In tr, this message translates to:
  /// **'{zone}. etap · {month}'**
  String mapLeg(int zone, String month);

  /// Haritanın tepesindeki sınav bayrağı.
  ///
  /// In tr, this message translates to:
  /// **'Sınav günü'**
  String get mapExamDay;

  /// Sınav bayrağındaki yazı.
  ///
  /// In tr, this message translates to:
  /// **'LGS'**
  String get mapExamMark;

  /// Patikanın çizilmeyen kısmındaki kalan gün sayısı.
  ///
  /// In tr, this message translates to:
  /// **'{count} durak ilerde'**
  String mapStopsAhead(int count);

  /// Harita bölüm ayracı.
  ///
  /// In tr, this message translates to:
  /// **'{number}. BÖLÜM'**
  String mapZone(int number);

  /// Bugünün durağı.
  ///
  /// In tr, this message translates to:
  /// **'Bugün · {done}/{total}'**
  String mapStopToday(int done, int total);

  /// Tamamlanmış bugünün durağı.
  ///
  /// In tr, this message translates to:
  /// **'Bugün · tamam · +{points}P'**
  String mapStopTodayDone(int points);

  /// Tamamlanmış geçmiş gün.
  ///
  /// In tr, this message translates to:
  /// **'+{points}P'**
  String mapStopEarned(int points);

  /// Yarım kalmış geçmiş gün.
  ///
  /// In tr, this message translates to:
  /// **'{done}/{total}'**
  String mapStopProgress(int done, int total);

  /// Deneme sınavı olan gün.
  ///
  /// In tr, this message translates to:
  /// **'Özel görev · {points}P'**
  String mapStopSpecial(int points);

  /// Gelecek gün.
  ///
  /// In tr, this message translates to:
  /// **'{count} görev · {points}P'**
  String mapStopTasks(int count, int points);

  /// Gün sayfası başlığı: bugün.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün görevleri'**
  String get mapSheetToday;

  /// Gün sayfası başlığı: bugün bitti.
  ///
  /// In tr, this message translates to:
  /// **'Bugün tamamlandı'**
  String get mapSheetTodayDone;

  /// Gün sayfası başlığı: deneme günü.
  ///
  /// In tr, this message translates to:
  /// **'Özel görev · {date}'**
  String mapSheetSpecial(String date);

  /// Gün sayfası başlığı: başka bir gün.
  ///
  /// In tr, this message translates to:
  /// **'{date}'**
  String mapSheetDay(String date);

  /// Gün sayfası alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'{done}/{total} görev · toplam {points}P'**
  String mapSheetProgress(int done, int total, int points);

  /// Gelecek günün alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'Sırası gelince açılacak'**
  String get mapSheetUpcoming;

  /// Görevi olmayan gün.
  ///
  /// In tr, this message translates to:
  /// **'Bu gün için görev yok.'**
  String get mapSheetEmpty;

  /// Kilitli gün kartı.
  ///
  /// In tr, this message translates to:
  /// **'Bu durak henüz kilitli'**
  String get mapLockedTitle;

  /// Kilitli gün kartındaki özet.
  ///
  /// In tr, this message translates to:
  /// **'{count} görev, {points}P'**
  String mapLockedHint(int count, int points);

  /// Gün bittiğinde gösterilen kutlama.
  ///
  /// In tr, this message translates to:
  /// **'Gün tamam! Yol bir durak ilerledi.'**
  String get mapDayCompleteTitle;

  /// Gün bittiğinde gösterilen kutlama metni.
  ///
  /// In tr, this message translates to:
  /// **'Kazandığın {points}P ödül havuzunda kullanılabilir.'**
  String mapDayCompleteBody(int points);

  /// Ödül sekmesindeki bakiye kartının etiketi.
  ///
  /// In tr, this message translates to:
  /// **'ÖDÜL HAVUZU'**
  String get rewardsPoolLabel;

  /// Bakiye kartındaki özet.
  ///
  /// In tr, this message translates to:
  /// **'{count} ödül açık · en yakını {cheapest}P'**
  String rewardsSummary(int count, int cheapest);

  /// Açık ödül yokken bakiye kartındaki özet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz açık ödül yok'**
  String get rewardsSummaryEmpty;

  /// Tüm kategorileri gösteren filtre.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get rewardCategoryAll;

  /// İstenebilir ödül kartının alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'Hazır · dokun ve iste'**
  String get rewardsReady;

  /// Kilitli ödül kartının alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'%{percent} biriktin'**
  String rewardsSaved(int percent);

  /// Onay bekleyen ödül kartının alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get rewardsPending;

  /// Seçili kategoride ödül yokken.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoride ödül yok.'**
  String get rewardsEmptyCategory;

  /// Çocuğun ödül isteklerinin başlığı.
  ///
  /// In tr, this message translates to:
  /// **'İsteklerim'**
  String get rewardsRequestsTitle;

  /// İstek satırının tarihi ve bedeli.
  ///
  /// In tr, this message translates to:
  /// **'{date} · {cost}P'**
  String rewardsRequestMeta(String date, int cost);

  /// İstek durumu.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get redemptionPending;

  /// İstek durumu.
  ///
  /// In tr, this message translates to:
  /// **'Onaylandı'**
  String get redemptionApproved;

  /// İstek durumu.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi olmaz'**
  String get redemptionRejected;

  /// Kurulum bitince gösterilen bildirim.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum tamam · {tasks} görev, {rewards} ödül hazır'**
  String setupDoneToast(int tasks, int rewards);

  /// Kurulum bitince, görev sayısı okunamadığında gösterilen bildirim.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum tamam · {rewards} ödül hazır'**
  String setupDoneRewardsToast(int rewards);

  /// İstek gönderilince gösterilen bildirim.
  ///
  /// In tr, this message translates to:
  /// **'{reward} isteği gönderildi.'**
  String rewardsRequestSent(String reward);

  /// Çocuğun sınıfı.
  ///
  /// In tr, this message translates to:
  /// **'{grade}. sınıf'**
  String childGrade(int grade);

  /// İlerleme sekmesinin başlığı.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get progressTitle;

  /// Seviye kutusunun etiketi.
  ///
  /// In tr, this message translates to:
  /// **'SEVİYE'**
  String get progressLevelLabel;

  /// Seviye kartındaki kalan puan.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki seviyeye {points} puan'**
  String progressLevelGap(int points);

  /// Seviye adı.
  ///
  /// In tr, this message translates to:
  /// **'Çaylak Avcı'**
  String get levelRankRookie;

  /// Seviye adı.
  ///
  /// In tr, this message translates to:
  /// **'İz Sürücü'**
  String get levelRankTracker;

  /// Seviye adı.
  ///
  /// In tr, this message translates to:
  /// **'Harita Ustası'**
  String get levelRankMapMaster;

  /// Seviye adı.
  ///
  /// In tr, this message translates to:
  /// **'Hazine Avcısı'**
  String get levelRankTreasureHunter;

  /// Seri kutusunun etiketi.
  ///
  /// In tr, this message translates to:
  /// **'SERİ'**
  String get progressStreakLabel;

  /// Seri kutusunun alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'gün üst üste'**
  String get progressStreakCaption;

  /// Toplam kutusunun etiketi.
  ///
  /// In tr, this message translates to:
  /// **'TOPLAM'**
  String get progressTotalLabel;

  /// Toplam kutusunun alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'tamamlanan görev'**
  String get progressTotalCaption;

  /// Haftalık grafiğin başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta'**
  String get progressWeekTitle;

  /// Aylık takvimin sağ üstündeki not.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan günler'**
  String get progressMonthCaption;

  /// Başarımlar kartının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Başarımlar'**
  String get progressAchievementsTitle;

  /// Başarım.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün seri'**
  String achievementWeekStreakTitle(int days);

  /// Başarım açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Bir hafta hiç kaçırmadın'**
  String get achievementWeekStreakBody;

  /// Başarım.
  ///
  /// In tr, this message translates to:
  /// **'İlk deneme sınavı'**
  String get achievementFirstPracticeTitle;

  /// Başarım açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'İlk deneme sınavını bitirdin'**
  String get achievementFirstPracticeBody;

  /// Başarım.
  ///
  /// In tr, this message translates to:
  /// **'Deneme ustası'**
  String get achievementPracticeMasterTitle;

  /// Başarım açıklaması ve ilerlemesi.
  ///
  /// In tr, this message translates to:
  /// **'{target} deneme çöz · {done}/{target}'**
  String achievementPracticeMasterBody(int target, int done);

  /// Profil sekmesinin başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// Profil kartındaki alt satır.
  ///
  /// In tr, this message translates to:
  /// **'{grade}. sınıf · Seviye {level} · {rank}'**
  String profileChildLine(int grade, int level, String rank);

  /// Profil istatistiği.
  ///
  /// In tr, this message translates to:
  /// **'puan'**
  String get profileStatPoints;

  /// Profil istatistiği.
  ///
  /// In tr, this message translates to:
  /// **'gün seri'**
  String get profileStatStreak;

  /// Profil istatistiği.
  ///
  /// In tr, this message translates to:
  /// **'görev'**
  String get profileStatTasks;

  /// Görünüm kartının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get profileAppearanceTitle;

  /// Görünüm kartının alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'{mode} · {accent}'**
  String profileAppearanceSummary(String mode, String accent);

  /// Ebeveyn tarafına giden satır.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn modu'**
  String get profileParentMode;

  /// Ebeveyn modu satırının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Onaylar ve ödül havuzu · PIN gerekir'**
  String get profileParentModeBody;

  /// Sınav tarihi satırı.
  ///
  /// In tr, this message translates to:
  /// **'Sınav tarihi'**
  String get profileExamDate;

  /// Bağlı ebeveyn satırı.
  ///
  /// In tr, this message translates to:
  /// **'Bağlı ebeveyn'**
  String get profileLinkedParent;

  /// PIN kapısının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn PIN\'i'**
  String get parentGateTitle;

  /// PIN kapısının açıklaması.
  ///
  /// In tr, this message translates to:
  /// **'Ebeveyn moduna geçmek için 4 haneli kodu gir.'**
  String get parentGateBody;

  /// Yanlış ebeveyn PIN'i.
  ///
  /// In tr, this message translates to:
  /// **'PIN hatalı, tekrar dene.'**
  String get failurePinWrong;

  /// Ebeveyn modundan çıkış.
  ///
  /// In tr, this message translates to:
  /// **'Çık'**
  String get parentExit;

  /// Ebeveynin cihazdaki oturumu kapatması; çıkış ikonunun okunan adı.
  ///
  /// In tr, this message translates to:
  /// **'Hesaptan çıkış yap'**
  String get parentSignOut;

  /// Çocuk seçicinin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'BU CİHAZDA SEÇİLİ ÇOCUK'**
  String get parentActiveChildLabel;

  /// Çocuğun bugün kartının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'{name} · bugün'**
  String parentChildToday(String name);

  /// Çocuğun bugün kartının alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'{done}/{total} görev bitti · seri {streak} gün'**
  String parentChildTodayLine(int done, int total, int streak);

  /// Ebeveyn sekmesi.
  ///
  /// In tr, this message translates to:
  /// **'Onaylar'**
  String get parentTabApprovals;

  /// Ebeveyn sekmesi.
  ///
  /// In tr, this message translates to:
  /// **'Ödül havuzu'**
  String get parentTabPool;

  /// Onay kartındaki çocuk ve tarih.
  ///
  /// In tr, this message translates to:
  /// **'{child} · {date}'**
  String parentApprovalMeta(String child, String date);

  /// Onaydan sonra kalacak bakiye.
  ///
  /// In tr, this message translates to:
  /// **'Onaylanırsa {points}P kalır'**
  String parentApprovalAfter(int points);

  /// İsteği reddet.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi olmaz'**
  String get parentReject;

  /// İsteği onayla.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get parentApprove;

  /// Bekleyen istek olmadığında.
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen istek yok'**
  String get parentNoApprovals;

  /// Bekleyen istek olmadığında açıklama.
  ///
  /// In tr, this message translates to:
  /// **'{name} yeni bir ödül istediğinde burada görünecek.'**
  String parentNoApprovalsBody(String name);

  /// Gün şeridinin başlığı.
  ///
  /// In tr, this message translates to:
  /// **'{day} · görevler'**
  String parentDayTasks(String day);

  /// Gün şeridinin notu.
  ///
  /// In tr, this message translates to:
  /// **'düzenlemek için dokun'**
  String get parentTapToEdit;

  /// Gün şeridi.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get parentToday;

  /// Gün şeridi.
  ///
  /// In tr, this message translates to:
  /// **'Yarın'**
  String get parentTomorrow;

  /// Gün şeridi kutusunun alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'{weekday} · {count} görev'**
  String parentDayChipSub(String weekday, int count);

  /// Tamamlanmış görev.
  ///
  /// In tr, this message translates to:
  /// **'Bitti'**
  String get parentTaskDone;

  /// Bekleyen görev.
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get parentTaskWaiting;

  /// Ebeveyn görev satırının alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'{topic} · {time} · {points}P'**
  String parentTaskMeta(String topic, String time, int points);

  /// Havuza yeni ödül formunu açar.
  ///
  /// In tr, this message translates to:
  /// **'Yeni ödül ekle'**
  String get parentAddReward;

  /// Hazır ödül önerilerinin etiketi.
  ///
  /// In tr, this message translates to:
  /// **'HAZIR ÖNERİLER'**
  String get parentPresetsLabel;

  /// Yeni ödül formunun başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Yeni ödül'**
  String get parentNewReward;

  /// Ödül adı ipucu.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Bisiklet turu'**
  String get parentRewardNameHint;

  /// Ödül bedeli etiketi.
  ///
  /// In tr, this message translates to:
  /// **'PUAN BEDELİ'**
  String get parentRewardCostLabel;

  /// Yapılanı kaydetmeden kapat.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get commonCancel;

  /// Yeni ödülü havuza ekle.
  ///
  /// In tr, this message translates to:
  /// **'Havuza ekle'**
  String get parentAddToPool;

  /// Ödül listesinin başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Havuzdaki ödüller'**
  String get parentPoolTitle;

  /// Açık ödül sayısı.
  ///
  /// In tr, this message translates to:
  /// **'{count} açık'**
  String parentPoolOpen(int count);

  /// Açık ödül.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get parentRewardOn;

  /// Kapalı ödül.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get parentRewardOff;

  /// Havuz satırının alt satırı.
  ///
  /// In tr, this message translates to:
  /// **'{category} · {state}'**
  String parentRewardRowMeta(String category, String state);

  /// Ödülü havuzdan kaldır.
  ///
  /// In tr, this message translates to:
  /// **'Kaldır'**
  String get parentRemove;

  /// Görev sayfasının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Yeni görev'**
  String get parentTaskSheetNew;

  /// Görev sayfasının başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Görevi düzenle'**
  String get parentTaskSheetEdit;

  /// Tekrarlayan görevin bitişi.
  ///
  /// In tr, this message translates to:
  /// **'BİTİŞ'**
  String get parentTaskEndLabel;

  /// Seri bitişi.
  ///
  /// In tr, this message translates to:
  /// **'1 hafta'**
  String get taskSeriesOneWeek;

  /// Seri bitişi.
  ///
  /// In tr, this message translates to:
  /// **'2 hafta'**
  String get taskSeriesTwoWeeks;

  /// Seri bitişi.
  ///
  /// In tr, this message translates to:
  /// **'4 hafta'**
  String get taskSeriesFourWeeks;

  /// Seri bitişi.
  ///
  /// In tr, this message translates to:
  /// **'Sınava kadar'**
  String get taskSeriesUntilExam;

  /// Yeni görevi kaydet.
  ///
  /// In tr, this message translates to:
  /// **'Görevi ekle'**
  String get parentTaskAdd;

  /// Düzenlenen görevi kaydet.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get parentTaskSave;

  /// Ebeveyn bildirimi.
  ///
  /// In tr, this message translates to:
  /// **'İstek onaylandı.'**
  String get parentNoticeApproved;

  /// Ebeveyn bildirimi.
  ///
  /// In tr, this message translates to:
  /// **'İstek şimdilik reddedildi.'**
  String get parentNoticeRejected;

  /// Ebeveyn bildirimi.
  ///
  /// In tr, this message translates to:
  /// **'Ödül havuza eklendi.'**
  String get parentNoticeRewardAdded;

  /// Ebeveyn bildirimi.
  ///
  /// In tr, this message translates to:
  /// **'Görev plana eklendi.'**
  String get parentNoticeTasksAdded;

  /// Ebeveyn bildirimi.
  ///
  /// In tr, this message translates to:
  /// **'Görev kaydedildi.'**
  String get parentNoticeTaskSaved;

  /// Ebeveyn bildirimi.
  ///
  /// In tr, this message translates to:
  /// **'Görev silindi.'**
  String get parentNoticeTaskRemoved;

  /// Google ile giriş düğmesi.
  ///
  /// In tr, this message translates to:
  /// **'Google ile devam et'**
  String get authContinueGoogle;

  /// Apple ile giriş düğmesi.
  ///
  /// In tr, this message translates to:
  /// **'Apple ile devam et'**
  String get authContinueApple;

  /// Platform girişi reddedildi.
  ///
  /// In tr, this message translates to:
  /// **'Giriş tamamlanamadı, tekrar dene.'**
  String get failurePlatformSignInFailed;

  /// Giriş penceresi kapatıldı.
  ///
  /// In tr, this message translates to:
  /// **'Giriş iptal edildi.'**
  String get failureSignInCancelled;

  /// Ağ hatası.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı kurulamadı.'**
  String get failureNetwork;

  /// Çözümlenemeyen yanıt.
  ///
  /// In tr, this message translates to:
  /// **'Sunucudan beklenmeyen bir yanıt geldi.'**
  String get failureUnexpectedResponse;

  /// Yıla ait sınav tarihi yok.
  ///
  /// In tr, this message translates to:
  /// **'Sınav tarihi henüz belirlenmedi.'**
  String get failureExamDateMissing;

  /// Cihazın kendi deposu okunamadı ya da yazılamadı.
  ///
  /// In tr, this message translates to:
  /// **'Ayarların kaydedilemedi.'**
  String get failureStorageUnavailable;

  /// Başka açıklaması olmayan hata.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler ters gitti.'**
  String get failureUnknown;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppL10nTr();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
