import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_style_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar_markup.dart';

/// Every hair style turns into complete markup with its colours filled in.
///
/// A token left in the SVG — `{hair}` where a colour should be — does not
/// throw; it draws the part black, which nobody notices until a child with
/// that style opens the app.
void main() {
  for (final AvatarStyleEnum style in AvatarStyleEnum.values) {
    test('the ${style.name} face has no unfilled colour', () {
      final String markup = AppAvatarMarkup.of(
        AvatarEntity(
          id: style.name,
          name: style.name,
          gender: AvatarGenderEnum.boy,
          style: style,
          skin: 0xFFF7D3B6,
          hair: 0xFF2C2016,
          shirt: 0xFF6FA8F0,
          background: 0xFFE6EEFD,
        ),
      );

      expect(markup, isNot(contains('{')));
      expect(markup, contains('#f7d3b6'));
      expect(markup, contains('#2c2016'));
    });
  }
}
