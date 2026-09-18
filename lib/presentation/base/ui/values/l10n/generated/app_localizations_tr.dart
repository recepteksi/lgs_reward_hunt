// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppL10nTr extends AppL10n {
  AppL10nTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'LGS Ödül Avı';

  @override
  String streakDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün',
    );
    return '$_temp0';
  }

  @override
  String taskPointsAward(int points) {
    return '+${points}P';
  }

  @override
  String taskPointsLocked(int points) {
    return '${points}P';
  }

  @override
  String get themeModeSystem => 'Sistem';

  @override
  String get themeModeLight => 'Açık';

  @override
  String get themeModeDark => 'Koyu';

  @override
  String get accentBlue => 'Mavi';

  @override
  String get accentPink => 'Pembe';

  @override
  String get accentGreen => 'Yeşil';

  @override
  String get accentYellow => 'Sarı';

  @override
  String get accentRed => 'Kırmızı';

  @override
  String progressRatio(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String get pointsUnit => 'puan';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navRewards => 'Ödüller';

  @override
  String get navProgress => 'İlerleme';

  @override
  String get navProfile => 'Profil';

  @override
  String get navParent => 'Ebeveyn';

  @override
  String get commonLoading => 'Yükleniyor';

  @override
  String get introSkip => 'Geç';

  @override
  String get introContinue => 'Devam';

  @override
  String get introTitleOne => 'Görevleri bitir,\nhazineyi aç.';

  @override
  String get introBodyOne =>
      'Her gün haritada bir durak. Ailenle birlikte belirlediğiniz görevleri tamamla, puan topla, ödül havuzundan istediğini seç.';

  @override
  String get introTitleTwo => 'Her gün bir durak,\nbirkaç görev.';

  @override
  String get introBodyTwo =>
      'Ailenle belirlediğiniz görevler her sabah haritada karşına çıkar. Bitirdikçe puan kazanır, patikada bir durak ilerlersin.';

  @override
  String get introTitleThree => 'Puanlar ödüle\ndönüşür.';

  @override
  String get introBodyThree =>
      'Biriken puanla ödül havuzundan seçim yaparsın. Her talep ebeveyn onayından geçer, böylece ödül ikinizin kararı olur.';

  @override
  String get introCreateAccount => 'Hesap oluştur';

  @override
  String get introEmblemMark => 'LGS';

  @override
  String get introEmblemPoints => 'P';

  @override
  String get introTasksTitle => 'Bugünün görevleri';

  @override
  String introTasksMeta(int stop, int points) {
    return '$stop. durak · ${points}P';
  }

  @override
  String get introSampleMathTitle => 'Matematik';

  @override
  String get introSampleMathMeta => 'Çarpanlar ve katlar · 30 dk';

  @override
  String get introSampleTurkishTitle => 'Türkçe';

  @override
  String get introSampleTurkishMeta => 'Paragrafta anlam · 25 dk';

  @override
  String get introSampleScienceTitle => 'Fen Bilimleri';

  @override
  String get introSampleScienceMeta => 'Basınç · 25 dk';

  @override
  String get introSampleReadingTitle => 'Okuma';

  @override
  String get introSampleReadingMeta => '20 sayfa kitap · 20 dk';

  @override
  String get introBalanceTitle => 'Puan hesabın';

  @override
  String introBalanceMeta(int points) {
    return '$points puan birikti';
  }

  @override
  String get introRewardName => 'Sinema bileti';

  @override
  String introRewardCost(int points) {
    return '$points puan';
  }

  @override
  String get introRewardPending => 'Onay bekliyor';

  @override
  String get introRewardNote => 'Annen onayladığında haber vereceğiz.';

  @override
  String get authTitle => 'Ebeveyn hesabı';

  @override
  String get authBody =>
      'Görevleri ve ödül havuzunu sen kuruyorsun. Çocuğunun hesabını da bu hesaptan açacaksın.';

  @override
  String get authTabSignUp => 'Kayıt ol';

  @override
  String get authTabSignIn => 'Giriş yap';

  @override
  String get authOrEmail => 'veya e-posta ile';

  @override
  String get authTerms =>
      'Devam ederek Kullanım Koşulları ve Gizlilik Politikası\'nı kabul ediyorsun.';

  @override
  String get fieldFullName => 'AD SOYAD';

  @override
  String get fieldFullNameHint => 'Adın ve soyadın';

  @override
  String get fieldEmail => 'E-POSTA';

  @override
  String get fieldEmailHint => 'ornek@eposta.com';

  @override
  String get fieldPassword => 'ŞİFRE';

  @override
  String get fieldPasswordHint => 'Hesap şifren';

  @override
  String get fieldPasswordRepeat => 'ŞİFRE TEKRAR';

  @override
  String get passwordTitle => 'Şifre belirle';

  @override
  String get passwordBody =>
      'Ödül onaylarına ve ebeveyn paneline girerken bu şifreyi kullanacaksın. Çocuğunla paylaşma.';

  @override
  String get passwordShow => 'Göster';

  @override
  String get passwordHide => 'Gizle';

  @override
  String get passwordMismatch => 'Şifreler aynı değil.';

  @override
  String get passwordRuleLength => 'En az 8 karakter';

  @override
  String get passwordRuleDigit => 'Bir rakam';

  @override
  String get passwordRuleUppercase => 'Bir büyük harf';

  @override
  String get pinTitleSet => 'Ebeveyn PIN\'i belirle';

  @override
  String get pinTitleRepeat => 'PIN\'i tekrar gir';

  @override
  String get pinBodySet =>
      'Ebeveyn moduna geçişte 4 haneli bu kod sorulur. Şifreden ayrı, hızlı giriş için.';

  @override
  String get pinBodyRepeat =>
      'Aynı 4 haneyi bir daha gir; yanlış yazarsan baştan başlayacağız.';

  @override
  String get pinNote =>
      'PIN\'i çocuğunla paylaşma; ebeveyn moduna her geçişte sorulacak.';

  @override
  String get setupStepAccount => 'Kayıt';

  @override
  String get setupStepPassword => 'Şifre';

  @override
  String get setupStepPin => 'Ebeveyn PIN\'i';

  @override
  String get setupStepChild => 'Çocuk';

  @override
  String get setupStepTasks => 'Görevler';

  @override
  String get setupStepRewards => 'Ödüller';

  @override
  String setupStepCount(int index, int total) {
    return '$index/$total';
  }

  @override
  String get commonBack => 'Geri';

  @override
  String get commonContinue => 'Devam et';

  @override
  String get failureEmailInvalid => 'E-posta adresi geçerli görünmüyor.';

  @override
  String get failurePasswordTooShort => 'Şifre en az 8 karakter olmalı.';

  @override
  String get failurePasswordTooWeak =>
      'Şifrede bir rakam ve bir büyük harf olmalı.';

  @override
  String get failureCredentialsInvalid => 'E-posta ya da şifre hatalı.';

  @override
  String get failureEmailInUse => 'Bu e-posta ile bir hesap zaten var.';

  @override
  String get failurePinInvalid => 'PIN 4 haneli olmalı.';

  @override
  String get failurePinMismatch => 'Kodlar aynı değil, baştan deneyelim.';

  @override
  String get failureNotSignedIn => 'Önce giriş yapman gerekiyor.';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get childSetupTitle => 'Çocuğunu ekle';

  @override
  String childSetupBody(int max) {
    return 'Her çocuğun kendi görev haritası ve puan hesabı olur. Şimdilik en fazla $max çocuk ekleyebilirsin.';
  }

  @override
  String get childSetupParentVia => 'E-posta';

  @override
  String get childSetupAdd => 'Çocuk ekle';

  @override
  String childSetupLimit(int max) {
    return '$max çocuk sınırına ulaştın. Daha fazlası için ebeveyn panelinden talep gönderebilirsin.';
  }

  @override
  String get childSetupNeedOne => 'En az bir çocuk ekle';

  @override
  String childSetupRowMeta(int grade, String avatar) {
    return '$grade. sınıf · $avatar avatarı';
  }

  @override
  String childSetupRowMetaNoAvatar(int grade) {
    return '$grade. sınıf';
  }

  @override
  String get childSetupRemove => 'Çocuğu kaldır';

  @override
  String get childFormTitle => 'Çocuk bilgileri';

  @override
  String get childFormName => 'ADI';

  @override
  String get childFormNameHint => 'Çocuğunun adı';

  @override
  String get childFormGrade => 'SINIFI';

  @override
  String childFormGradeOption(int grade) {
    return '$grade. sınıf';
  }

  @override
  String get childFormAvatar => 'AVATARI';

  @override
  String get childFormGirl => 'Kız';

  @override
  String get childFormBoy => 'Erkek';

  @override
  String get childFormAvatarsLoading => 'Avatar kataloğu sunucudan yükleniyor…';

  @override
  String get childFormAvatarsFailed => 'Avatarlar yüklenemedi.';

  @override
  String get childFormAvatarPick => 'Çocuğun için bir avatar seç.';

  @override
  String childFormAvatarPicked(String name) {
    return 'Seçilen avatar: $name';
  }

  @override
  String get childFormSave => 'Çocuğu ekle';

  @override
  String get failureChildNameEmpty => 'Çocuğunun adını yaz.';

  @override
  String get failureChildGradeInvalid => 'Sınıf 7 ya da 8 olmalı.';

  @override
  String get failureChildAvatarMissing => 'Çocuğun için bir avatar seç.';

  @override
  String get failureChildLimitReached =>
      'Bu hesaba daha fazla çocuk eklenemez.';

  @override
  String get taskSetupTitle => 'Günlük görevler';

  @override
  String get taskSetupBody =>
      'Standart bir çalışma günü hazırladık. Silebilir, düzenleyebilir, yenilerini ekleyebilirsin — sonra ebeveyn panelinden de değişir.';

  @override
  String taskSetupSummary(int lessons, int chores, int points) {
    return '$lessons ders · $chores sorumluluk · bugün ${points}P';
  }

  @override
  String get taskSetupEmpty => 'Henüz görev yok';

  @override
  String taskMeta(String topic, String time, int minutes) {
    return '$topic · $time · $minutes dk';
  }

  @override
  String get taskSetupAdd => 'Görev ekle';

  @override
  String get taskSetupNeedOne => 'En az bir görev ekle';

  @override
  String get taskSetupRemove => 'Görevi sil';

  @override
  String get taskSetupKind => 'TÜR';

  @override
  String get taskSetupCategoryLesson => 'DERS';

  @override
  String get taskSetupCategoryChore => 'SORUMLULUK';

  @override
  String get taskSetupTopicLesson => 'KONU';

  @override
  String get taskSetupTopicChore => 'AÇIKLAMA';

  @override
  String get taskSetupTopicHintLesson => 'Örn. Çarpanlar ve katlar';

  @override
  String get taskSetupTopicHintChore => 'Örn. Masa ve yatak';

  @override
  String get taskSetupTime => 'SAAT';

  @override
  String get taskSetupDuration => 'SÜRE';

  @override
  String taskSetupMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get taskSetupPoints => 'PUAN';

  @override
  String get taskSetupRepeat => 'SIKLIK';

  @override
  String get taskKindLesson => 'Ders';

  @override
  String get taskKindChore => 'Sorumluluk';

  @override
  String get taskCategoryMath => 'Matematik';

  @override
  String get taskCategoryTurkish => 'Türkçe';

  @override
  String get taskCategoryScience => 'Fen Bilimleri';

  @override
  String get taskCategoryHistory => 'İnkılap Tarihi';

  @override
  String get taskCategoryEnglish => 'İngilizce';

  @override
  String get taskCategoryReading => 'Okuma';

  @override
  String get taskCategoryPracticeExam => 'Deneme sınavı';

  @override
  String get taskCategoryBrushTeeth => 'Diş fırçalama';

  @override
  String get taskCategoryTidyRoom => 'Oda toplama';

  @override
  String get taskCategoryDishes => 'Bulaşık';

  @override
  String get taskCategoryTrash => 'Çöp atma';

  @override
  String get taskCategoryLaundry => 'Çamaşır';

  @override
  String get taskCategoryDrinkWater => 'Su içme';

  @override
  String get taskCategoryExercise => 'Spor';

  @override
  String get taskCategoryEarlyBed => 'Erken yatma';

  @override
  String get taskCategoryScreenFree => 'Ekransız saat';

  @override
  String get taskRepeatOnce => 'Bir kez';

  @override
  String get taskRepeatDaily => 'Her gün';

  @override
  String get taskRepeatWeekdays => 'Hafta içi';

  @override
  String get taskRepeatWeekend => 'Hafta sonu';

  @override
  String get taskRepeatWeekly => 'Haftada bir';

  @override
  String get failureTaskPlanEmpty => 'En az bir görev ekle.';

  @override
  String get failureTaskTitleEmpty =>
      'Her görevin bir konusu ya da açıklaması olmalı.';

  @override
  String get failureTaskPointsInvalid =>
      'Görev puanı izin verilen aralığın dışında.';

  @override
  String get failureTaskDurationInvalid =>
      'Görev süresi izin verilen aralığın dışında.';

  @override
  String get failureTaskCategoryInvalid => 'Görevin türü ile konusu uyuşmuyor.';

  @override
  String get failureTaskTimeInvalid => 'Görev saati geçerli değil.';

  @override
  String get rewardSetupTitle => 'Ödül havuzu';

  @override
  String get rewardSetupBody =>
      'Puanların harcanacağı ödüller. Bunlar da bir başlangıç; çocuğunla birlikte değiştirin.';

  @override
  String rewardSetupSummary(int count, int cheapest, int dearest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ödül',
    );
    return '$_temp0 · ${cheapest}P–${dearest}P';
  }

  @override
  String get rewardSetupEmpty => 'Henüz ödül yok';

  @override
  String get rewardSetupAdd => 'Ödül ekle';

  @override
  String get rewardSetupRemove => 'Ödülü sil';

  @override
  String get rewardSetupName => 'ÖDÜL';

  @override
  String get rewardSetupNameHint => 'Örn. Sinema bileti';

  @override
  String get rewardSetupCategory => 'KATEGORİ';

  @override
  String get rewardSetupCost => 'PUAN';

  @override
  String get rewardSetupFinish => 'Kurulumu bitir';

  @override
  String get rewardSetupNeedOne => 'En az bir ödül ekle';

  @override
  String get commonDone => 'Tamam';

  @override
  String get commonPointsDown => 'Puan azalt';

  @override
  String get commonPointsUp => 'Puan artır';

  @override
  String get rewardCategoryScreen => 'Ekran';

  @override
  String get rewardCategoryFun => 'Eğlence';

  @override
  String get rewardCategoryTreat => 'Lezzet';

  @override
  String get rewardCategorySocial => 'Sosyal';

  @override
  String get rewardCategoryFree => 'Serbest';

  @override
  String get failureRewardPoolEmpty => 'En az bir ödül ekle.';

  @override
  String get failureRewardNameEmpty => 'Her ödülün bir adı olmalı.';

  @override
  String get failureRewardCostInvalid =>
      'Ödül puanı izin verilen aralığın dışında.';

  @override
  String get failureInsufficientPoints => 'Bu ödül için puanın yetmiyor.';

  @override
  String get failureRedemptionNotPending => 'Bu talep zaten yanıtlandı.';

  @override
  String get deviceChildTitle => 'Bu cihazı kim kullanıyor?';

  @override
  String get deviceChildBody =>
      'Uygulama seçtiğin çocuğun haritasını açar. Ebeveyn modundan her zaman diğerine geçebilirsin.';

  @override
  String deviceChildRowMeta(int grade, int points) {
    return '$grade. sınıf · $points puan';
  }

  @override
  String get deviceChildNote =>
      'İki çocuğunun verileri ayrı tutulur; ebeveyn modunda hangisinin seçili olduğunu değiştirebilirsin.';

  @override
  String mapLeg(int zone, String month) {
    return '$zone. etap · $month';
  }

  @override
  String get mapExamDay => 'Sınav günü';

  @override
  String get mapExamMark => 'LGS';

  @override
  String mapStopsAhead(int count) {
    return '$count durak ilerde';
  }

  @override
  String mapZone(int number) {
    return '$number. BÖLÜM';
  }

  @override
  String mapStopToday(int done, int total) {
    return 'Bugün · $done/$total';
  }

  @override
  String mapStopTodayDone(int points) {
    return 'Bugün · tamam · +${points}P';
  }

  @override
  String mapStopEarned(int points) {
    return '+${points}P';
  }

  @override
  String mapStopProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String mapStopSpecial(int points) {
    return 'Özel görev · ${points}P';
  }

  @override
  String mapStopTasks(int count, int points) {
    return '$count görev · ${points}P';
  }

  @override
  String get mapSheetToday => 'Bugünün görevleri';

  @override
  String get mapSheetTodayDone => 'Bugün tamamlandı';

  @override
  String mapSheetSpecial(String date) {
    return 'Özel görev · $date';
  }

  @override
  String mapSheetDay(String date) {
    return '$date';
  }

  @override
  String mapSheetProgress(int done, int total, int points) {
    return '$done/$total görev · toplam ${points}P';
  }

  @override
  String get mapSheetUpcoming => 'Sırası gelince açılacak';

  @override
  String get mapSheetEmpty => 'Bu gün için görev yok.';

  @override
  String get mapLockedTitle => 'Bu durak henüz kilitli';

  @override
  String mapLockedHint(int count, int points) {
    return '$count görev, ${points}P';
  }

  @override
  String get mapDayCompleteTitle => 'Gün tamam! Yol bir durak ilerledi.';

  @override
  String mapDayCompleteBody(int points) {
    return 'Kazandığın ${points}P ödül havuzunda kullanılabilir.';
  }

  @override
  String get rewardsPoolLabel => 'ÖDÜL HAVUZU';

  @override
  String rewardsSummary(int count, int cheapest) {
    return '$count ödül açık · en yakını ${cheapest}P';
  }

  @override
  String get rewardsSummaryEmpty => 'Henüz açık ödül yok';

  @override
  String get rewardCategoryAll => 'Tümü';

  @override
  String get rewardsReady => 'Hazır · dokun ve iste';

  @override
  String rewardsSaved(int percent) {
    return '%$percent biriktin';
  }

  @override
  String get rewardsPending => 'Onay bekliyor';

  @override
  String get rewardsEmptyCategory => 'Bu kategoride ödül yok.';

  @override
  String get rewardsRequestsTitle => 'İsteklerim';

  @override
  String rewardsRequestMeta(String date, int cost) {
    return '$date · ${cost}P';
  }

  @override
  String get redemptionPending => 'Onay bekliyor';

  @override
  String get redemptionApproved => 'Onaylandı';

  @override
  String get redemptionRejected => 'Şimdi olmaz';

  @override
  String setupDoneToast(int tasks, int rewards) {
    return 'Kurulum tamam · $tasks görev, $rewards ödül hazır';
  }

  @override
  String setupDoneRewardsToast(int rewards) {
    return 'Kurulum tamam · $rewards ödül hazır';
  }

  @override
  String rewardsRequestSent(String reward) {
    return '$reward isteği gönderildi.';
  }

  @override
  String childGrade(int grade) {
    return '$grade. sınıf';
  }

  @override
  String get progressTitle => 'İlerleme';

  @override
  String get progressLevelLabel => 'SEVİYE';

  @override
  String progressLevelGap(int points) {
    return 'Sonraki seviyeye $points puan';
  }

  @override
  String get levelRankRookie => 'Çaylak Avcı';

  @override
  String get levelRankTracker => 'İz Sürücü';

  @override
  String get levelRankMapMaster => 'Harita Ustası';

  @override
  String get levelRankTreasureHunter => 'Hazine Avcısı';

  @override
  String get progressStreakLabel => 'SERİ';

  @override
  String get progressStreakCaption => 'gün üst üste';

  @override
  String get progressTotalLabel => 'TOPLAM';

  @override
  String get progressTotalCaption => 'tamamlanan görev';

  @override
  String get progressWeekTitle => 'Bu hafta';

  @override
  String get progressMonthCaption => 'Tamamlanan günler';

  @override
  String get progressAchievementsTitle => 'Başarımlar';

  @override
  String achievementWeekStreakTitle(int days) {
    return '$days gün seri';
  }

  @override
  String get achievementWeekStreakBody => 'Bir hafta hiç kaçırmadın';

  @override
  String get achievementFirstPracticeTitle => 'İlk deneme sınavı';

  @override
  String get achievementFirstPracticeBody => 'İlk deneme sınavını bitirdin';

  @override
  String get achievementPracticeMasterTitle => 'Deneme ustası';

  @override
  String achievementPracticeMasterBody(int target, int done) {
    return '$target deneme çöz · $done/$target';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String profileChildLine(int grade, int level, String rank) {
    return '$grade. sınıf · Seviye $level · $rank';
  }

  @override
  String get profileStatPoints => 'puan';

  @override
  String get profileStatStreak => 'gün seri';

  @override
  String get profileStatTasks => 'görev';

  @override
  String get profileAppearanceTitle => 'Görünüm';

  @override
  String profileAppearanceSummary(String mode, String accent) {
    return '$mode · $accent';
  }

  @override
  String get profileParentMode => 'Ebeveyn modu';

  @override
  String get profileParentModeBody => 'Onaylar ve ödül havuzu · PIN gerekir';

  @override
  String get profileExamDate => 'Sınav tarihi';

  @override
  String get profileLinkedParent => 'Bağlı ebeveyn';

  @override
  String get parentGateTitle => 'Ebeveyn PIN\'i';

  @override
  String get parentGateBody => 'Ebeveyn moduna geçmek için 4 haneli kodu gir.';

  @override
  String get failurePinWrong => 'PIN hatalı, tekrar dene.';

  @override
  String get parentExit => 'Çık';

  @override
  String get parentSignOut => 'Hesaptan çıkış yap';

  @override
  String get parentActiveChildLabel => 'BU CİHAZDA SEÇİLİ ÇOCUK';

  @override
  String parentChildToday(String name) {
    return '$name · bugün';
  }

  @override
  String parentChildTodayLine(int done, int total, int streak) {
    return '$done/$total görev bitti · seri $streak gün';
  }

  @override
  String get parentTabApprovals => 'Onaylar';

  @override
  String get parentTabPool => 'Ödül havuzu';

  @override
  String parentApprovalMeta(String child, String date) {
    return '$child · $date';
  }

  @override
  String parentApprovalAfter(int points) {
    return 'Onaylanırsa ${points}P kalır';
  }

  @override
  String get parentReject => 'Şimdi olmaz';

  @override
  String get parentApprove => 'Onayla';

  @override
  String get parentNoApprovals => 'Bekleyen istek yok';

  @override
  String parentNoApprovalsBody(String name) {
    return '$name yeni bir ödül istediğinde burada görünecek.';
  }

  @override
  String parentDayTasks(String day) {
    return '$day · görevler';
  }

  @override
  String get parentTapToEdit => 'düzenlemek için dokun';

  @override
  String get parentToday => 'Bugün';

  @override
  String get parentTomorrow => 'Yarın';

  @override
  String parentDayChipSub(String weekday, int count) {
    return '$weekday · $count görev';
  }

  @override
  String get parentTaskDone => 'Bitti';

  @override
  String get parentTaskWaiting => 'Bekliyor';

  @override
  String parentTaskMeta(String topic, String time, int points) {
    return '$topic · $time · ${points}P';
  }

  @override
  String get parentAddReward => 'Yeni ödül ekle';

  @override
  String get parentPresetsLabel => 'HAZIR ÖNERİLER';

  @override
  String get parentNewReward => 'Yeni ödül';

  @override
  String get parentRewardNameHint => 'Örn. Bisiklet turu';

  @override
  String get parentRewardCostLabel => 'PUAN BEDELİ';

  @override
  String get commonCancel => 'Vazgeç';

  @override
  String get parentAddToPool => 'Havuza ekle';

  @override
  String get parentPoolTitle => 'Havuzdaki ödüller';

  @override
  String parentPoolOpen(int count) {
    return '$count açık';
  }

  @override
  String get parentRewardOn => 'Açık';

  @override
  String get parentRewardOff => 'Kapalı';

  @override
  String parentRewardRowMeta(String category, String state) {
    return '$category · $state';
  }

  @override
  String get parentRemove => 'Kaldır';

  @override
  String get parentTaskSheetNew => 'Yeni görev';

  @override
  String get parentTaskSheetEdit => 'Görevi düzenle';

  @override
  String get parentTaskEndLabel => 'BİTİŞ';

  @override
  String get taskSeriesOneWeek => '1 hafta';

  @override
  String get taskSeriesTwoWeeks => '2 hafta';

  @override
  String get taskSeriesFourWeeks => '4 hafta';

  @override
  String get taskSeriesUntilExam => 'Sınava kadar';

  @override
  String get parentTaskAdd => 'Görevi ekle';

  @override
  String get parentTaskSave => 'Kaydet';

  @override
  String get parentNoticeApproved => 'İstek onaylandı.';

  @override
  String get parentNoticeRejected => 'İstek şimdilik reddedildi.';

  @override
  String get parentNoticeRewardAdded => 'Ödül havuza eklendi.';

  @override
  String get parentNoticeTasksAdded => 'Görev plana eklendi.';

  @override
  String get parentNoticeTaskSaved => 'Görev kaydedildi.';

  @override
  String get parentNoticeTaskRemoved => 'Görev silindi.';

  @override
  String get authContinueGoogle => 'Google ile devam et';

  @override
  String get authContinueApple => 'Apple ile devam et';

  @override
  String get failurePlatformSignInFailed => 'Giriş tamamlanamadı, tekrar dene.';

  @override
  String get failureSignInCancelled => 'Giriş iptal edildi.';

  @override
  String get failureNetwork => 'İnternet bağlantısı kurulamadı.';

  @override
  String get failureUnexpectedResponse =>
      'Sunucudan beklenmeyen bir yanıt geldi.';

  @override
  String get failureExamDateMissing => 'Sınav tarihi henüz belirlenmedi.';

  @override
  String get failureStorageUnavailable => 'Ayarların kaydedilemedi.';

  @override
  String get failureUnknown => 'Bir şeyler ters gitti.';
}
