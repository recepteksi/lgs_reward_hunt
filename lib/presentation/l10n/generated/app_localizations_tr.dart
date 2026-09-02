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
  String get countdownTitle => 'LGS\'ye kalan';

  @override
  String countdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün',
      one: '$days gün',
      zero: 'Bugün!',
    );
    return '$_temp0';
  }

  @override
  String countdownExamDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Sınav tarihi: $dateString';
  }

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get failureNetwork => 'İnternet bağlantısı kurulamadı.';

  @override
  String get failureUnexpectedResponse =>
      'Sunucudan beklenmeyen bir yanıt geldi.';

  @override
  String get failureExamDateMissing => 'Sınav tarihi henüz belirlenmedi.';

  @override
  String get failureUnknown => 'Bir şeyler ters gitti.';
}
