import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_style_enum.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_setup/body/child_setup_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';

/// The child setup list, empty and full, on a small phone.
///
/// Empty, the primary action says what is missing and cannot be pressed. Full,
/// the add button gives way to the limit note, and two rows with faces and a
/// long email still fit in 320 pixels.
Future<void> _pump(WidgetTester tester, HouseholdReadModel household) async {
  tester.view.physicalSize = const Size(320, 568);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark(AppAccentEnum.green),
      locale: const Locale('tr'),
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      home: AppScaffold(
        padding: const EdgeInsets.all(24),
        body: ChildSetupBody(
          household: household,
          onAdd: () {},
          onRemove: (_) {},
          onContinue: () {},
        ),
      ),
    ),
  );
  await tester.pump();
}

final ParentEntity _parent = ParentEntity.create(
  id: 'p',
  name: 'Ayşe Yılmazoğulları',
  email: 'ayse.yilmazogullari.uzun@ornek-aile.com',
  linkCode: 'X',
).right;

const AvatarEntity _face = AvatarEntity(
  id: 'av_k_03',
  name: 'Elif',
  gender: AvatarGenderEnum.girl,
  style: AvatarStyleEnum.bun,
  skin: 0xFFF3C49A,
  hair: 0xFF8A4B2A,
  shirt: 0xFF8FB4F5,
  background: 0xFFE6EEFD,
);

void main() {
  testWidgets('with no child the button asks for one and does nothing', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      HouseholdReadModel(
        parent: _parent,
        children: const <ChildEntity>[],
        avatars: const <AvatarEntity>[_face],
      ),
    );

    expect(find.text('En az bir çocuk ekle'), findsOneWidget);
    expect(find.text('Çocuk ekle'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a full household shows the limit instead of the add button', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      HouseholdReadModel(
        parent: _parent,
        children: <ChildEntity>[
          ChildEntity.create(
            id: 'a',
            parentId: 'p',
            name: 'Elif',
            avatarId: 'av_k_03',
          ).right,
          ChildEntity.create(id: 'b', parentId: 'p', name: 'Kerem').right,
        ],
        avatars: const <AvatarEntity>[_face],
      ),
    );

    expect(find.text('Çocuk ekle'), findsNothing);
    expect(find.text('8. sınıf · Elif avatarı'), findsOneWidget);
    expect(find.text('8. sınıf'), findsOneWidget);
    expect(find.text('Devam et'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
