import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';

/// Writes an hour and a minute the way a Turkish clock reads: `19:00`.
///
/// Two digits either side of a colon, 24-hour — the form every time on the
/// setup and map pages is shown in, written once so no two pages pad it
/// differently.
String clockTimeCopy(int hour, int minute) =>
    '${hour.toString().padLeft(ValueConstants.two, CharConstants.zeroDigit)}'
    '${CharConstants.colon}'
    '${minute.toString().padLeft(ValueConstants.two, CharConstants.zeroDigit)}';
