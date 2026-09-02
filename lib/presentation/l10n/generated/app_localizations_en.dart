// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LGS Reward Hunt';

  @override
  String get countdownTitle => 'Until the LGS';

  @override
  String countdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
      zero: 'Today!',
    );
    return '$_temp0';
  }

  @override
  String countdownExamDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Exam date: $dateString';
  }

  @override
  String get commonRetry => 'Try again';

  @override
  String get failureNetwork => 'Could not reach the internet.';

  @override
  String get failureUnexpectedResponse =>
      'The server sent something unexpected.';

  @override
  String get failureExamDateMissing =>
      'The exam date has not been announced yet.';

  @override
  String get failureUnknown => 'Something went wrong.';
}
