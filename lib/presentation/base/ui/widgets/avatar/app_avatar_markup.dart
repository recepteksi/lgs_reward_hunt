import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/radix_constants.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_style_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';

/// Turns an [AvatarEntity]'s recipe into the SVG that draws the face.
///
/// The shapes are the design's own, on its 64 by 64 grid, painted back to front:
/// the shirt, the hair behind the head, the ears and the face, whatever sits on
/// top of the head — a fringe, a cap, a wave — and last the features, which are
/// the same on every face. Only the colours come from the catalogue; they are
/// spliced into the markup at the `{skin}`-style tokens, because the colours
/// are data rather than a tint, and a face has four of them.
///
/// [of] is the only entry point. The `switch` over [AvatarStyleEnum] is
/// exhaustive, so a style added to the enum does not draw until it is drawn
/// here. [_hex] writes an ARGB int as `#rrggbb`, dropping the alpha the wire
/// never had.
abstract final class AppAvatarMarkup {
  static const String _skin = '{skin}';

  static const String _hair = '{hair}';

  static const String _shirt = '{shirt}';

  static const String _accent = '{accent}';

  static const String _ink = '{ink}';

  static const String _highlight = '{highlight}';

  static const String _blush = '{blush}';

  static const int _argbDigits = 8;

  static const int _alphaDigits = 2;

  static const String _hexPrefix = '#';

  static const String _open = '<svg viewBox="0 0 64 64">';

  static const String _close = '</svg>';

  static const String _shirtShape =
      '<path d="M11 64c0-10.5 9.4-15.5 21-15.5S53 53.5 53 64z" fill="{shirt}"/>';

  static const String _headHair =
      '<circle cx="32" cy="29" r="14.6" fill="{hair}"/>';

  static const String _longBack =
      '<path d="M17 30a15 15 0 0 1 30 0v19a3.2 3.2 0 0 1-6.4 0V33H23.4v16a3.2 3.2 0 0 1-6.4 0z" fill="{hair}"/>';

  static const String _pigtailBack =
      '<circle cx="32" cy="29" r="15" fill="{hair}"/>'
      '<circle cx="15.5" cy="39" r="6.4" fill="{hair}"/>'
      '<circle cx="48.5" cy="39" r="6.4" fill="{hair}"/>';

  static const String _bunBack =
      '<circle cx="32" cy="29.5" r="15" fill="{hair}"/>'
      '<circle cx="32" cy="13.5" r="7" fill="{hair}"/>';

  static const String _curlyBack =
      '<circle cx="32" cy="29" r="14.6" fill="{hair}"/>'
      '<circle cx="19.5" cy="23" r="7" fill="{hair}"/>'
      '<circle cx="44.5" cy="23" r="7" fill="{hair}"/>'
      '<circle cx="32" cy="16.5" r="7.4" fill="{hair}"/>';

  static const String _spikyBack =
      '<circle cx="32" cy="29" r="14.2" fill="{hair}"/>'
      '<path d="M23 19l2.6-7 3.4 6.6zM31.4 16.2l2.8-7.6 2.6 7.6zM39.4 18.6l3.2-6.8 2.4 7.2z" fill="{hair}"/>';

  static const String _head =
      '<circle cx="18.8" cy="32.4" r="3.1" fill="{skin}"/>'
      '<circle cx="45.2" cy="32.4" r="3.1" fill="{skin}"/>'
      '<circle cx="32" cy="31" r="13.6" fill="{skin}"/>';

  static const String _fringe =
      '<path d="M19.5 29.5c1.4-8.4 6.6-12.6 12.5-12.6s11.1 4.2 12.5 12.6c-3.4-6.2-8-8.3-12.5-8.3s-9.1 2.1-12.5 8.3z" fill="{hair}"/>';

  static const String _sweep =
      '<path d="M31 16.6c-3.6 5.2-8.6 8-15 8.4 2-6.4 7-10.4 15-10.4z" fill="{hair}"/>';

  static const String _cap =
      '<path d="M18 25.5a14 14 0 0 1 28 0z" fill="{accent}"/>'
      '<path d="M14.6 25.5h34.8a2.6 2.6 0 0 1 0 5.2H14.6a2.6 2.6 0 0 1 0-5.2z" fill="{accent}"/>';

  static const String _wave =
      '<path d="M19.4 29.6c1-8.4 6.2-12.8 12.6-12.8 5.4 0 9.4 2.6 11.6 7-3.6-2.4-7-3-10-2-3.2 1.2-5 3.4-5.2 6.6-1.8-2-4.6-1.4-9 1.2z" fill="{hair}"/>';

  static const String _features =
      '<circle cx="27" cy="30.5" r="2.4" fill="{ink}"/>'
      '<circle cx="37" cy="30.5" r="2.4" fill="{ink}"/>'
      '<circle cx="28.35" cy="29.5" r="0.85" fill="{highlight}"/>'
      '<circle cx="38.35" cy="29.5" r="0.85" fill="{highlight}"/>'
      '<path d="M28.7 36.3q3.3 3 6.6 0" fill="none" stroke="{ink}" stroke-width="2" stroke-linecap="round"/>'
      '<ellipse cx="22.6" cy="34.6" rx="2.6" ry="1.6" fill="{blush}" opacity="0.5"/>'
      '<ellipse cx="41.4" cy="34.6" rx="2.6" ry="1.6" fill="{blush}" opacity="0.5"/>';

  static String of(AvatarEntity avatar) {
    final String back = switch (avatar.style) {
      AvatarStyleEnum.long => _longBack,
      AvatarStyleEnum.pigtail => _pigtailBack,
      AvatarStyleEnum.bun => _bunBack,
      AvatarStyleEnum.curly => _curlyBack,
      AvatarStyleEnum.spiky => _spikyBack,
      AvatarStyleEnum.short ||
      AvatarStyleEnum.cap ||
      AvatarStyleEnum.wave => _headHair,
    };
    final String front = switch (avatar.style) {
      AvatarStyleEnum.cap => _cap,
      AvatarStyleEnum.wave => _wave,
      AvatarStyleEnum.long || AvatarStyleEnum.pigtail => '$_fringe$_sweep',
      AvatarStyleEnum.bun ||
      AvatarStyleEnum.curly ||
      AvatarStyleEnum.spiky ||
      AvatarStyleEnum.short => _fringe,
    };

    return '$_open$_shirtShape$back$_head$front$_features$_close'
        .replaceAll(_skin, _hex(avatar.skin))
        .replaceAll(_hair, _hex(avatar.hair))
        .replaceAll(_shirt, _hex(avatar.shirt))
        .replaceAll(_accent, _hex(avatar.accessory ?? avatar.hair))
        .replaceAll(_ink, _hex(AppPalette.avatarInk.toARGB32()))
        .replaceAll(_highlight, _hex(AppPalette.avatarHighlight.toARGB32()))
        .replaceAll(_blush, _hex(AppPalette.avatarBlush.toARGB32()));
  }

  static String _hex(int argb) =>
      _hexPrefix +
      argb
          .toRadixString(RadixConstants.hexadecimal)
          .padLeft(_argbDigits, CharConstants.zeroDigit)
          .substring(_alphaDigits);
}
