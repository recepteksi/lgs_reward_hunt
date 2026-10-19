import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_points_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_status_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_streak_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_day_cell.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_settings_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_stepper.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/map/app_map_stop.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_bottom_nav.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_level_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_progress_ring.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_week_chart.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_empty_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row.dart';

/// Every component in the kit, laid out at phone width.
///
/// It is one test rather than twenty because what it is checking is the thing
/// twenty separate tests would each check by accident: that a component can be
/// built at all, in both brightnesses and under an accent that is not the
/// default. Nearly every mistake in a design system this size — a missing theme
/// extension, a colour read outside a `Theme`, a row that overflows on a narrow
/// screen — shows up here as an exception, and none of them shows up in
/// `flutter analyze`.
Widget _kit() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: <Widget>[
      const AppPointsBadge(points: 480),
      const AppPointsBadge.prominent(points: 1240),
      const AppStatusBadge.pending(label: 'Onay bekliyor'),
      const AppStatusBadge.approved(label: 'Onaylandı'),
      const AppStatusBadge.rejected(label: 'Reddedildi'),
      const AppStatusBadge.locked(label: 'Kilitli'),
      const AppStreakBadge(days: 7),
      AppButton.filled(label: 'Görevi tamamla', onPressed: () {}),
      AppButton.reward(
        label: 'Ödülü iste',
        icon: AppIcons.star,
        onPressed: () {},
      ),
      AppButton.tonal(label: 'Görev ekle', onPressed: () {}),
      AppButton.rewardTonal(label: 'Tonal ödül', onPressed: () {}),
      AppButton.outlined(label: 'Reddet', onPressed: () {}),
      AppButton.text(label: 'Talebi geri al', onPressed: () {}),
      const AppButton.filled(label: 'Devre dışı', onPressed: null),
      const AppCard(child: Text('Kart')),
      const AppTaskRow.pending(
        title: 'Kareköklü ifadeler',
        meta: 'Matematik · 19:00 · 30 dk',
        points: 20,
      ),
      const AppTaskRow.done(
        title: 'Basınç · deneme testi',
        meta: 'Fen Bilimleri · 17:30 · 25 dk',
        points: 20,
      ),
      const AppTaskRow.locked(
        title: 'Millî Uyanış',
        meta: 'İnkılap Tarihi · yarın açılıyor',
        points: 15,
      ),
      const AppRewardCard.available(
        title: '1 saat ekstra oyun',
        cost: 120,
        icon: AppIcons.categoryScreen,
        footer: 'Alınabilir',
      ),
      const AppRewardCard.locked(
        title: 'Kablosuz kulaklık',
        cost: 5000,
        icon: AppIcons.categoryOther,
        footer: '4.520 puan daha',
        progress: 0.24,
      ),
      const AppRewardCard.pending(
        title: 'Sinema bileti',
        cost: 350,
        icon: AppIcons.categoryFun,
        footer: 'Annen onayını bekliyor',
      ),
      const AppRewardCard.approved(
        title: 'Hafta sonu geç yatma',
        cost: 150,
        icon: AppIcons.star,
        footer: 'Onaylandı · cumartesi',
      ),
      const Row(
        children: <Widget>[
          AppMapStop.done(label: 'Tamamlandı'),
          AppMapStop.today(day: 3, label: 'Bugün'),
          AppMapStop.special(label: 'Özel gün'),
          AppMapStop.locked(day: 12, label: 'Kilitli'),
        ],
      ),
      const AppProgressRing(completed: 3, total: 4),
      const AppLevelCard(
        level: 4,
        title: 'Kararlı avcı',
        caption: 'Sonraki seviyeye 120 puan',
        progress: 0.64,
        levelLabel: 'SEVİYE',
      ),
      const AppWeekChart(
        values: <int>[3, 4, 2, 4, 4, 1, 0],
        labels: <String>['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'],
        highlightedIndex: 3,
      ),
      Row(
        children: <Widget>[
          AppChip(label: 'Tümü', isSelected: true, onTap: () {}),
          AppChip(label: 'Ekran', isSelected: false, onTap: () {}),
        ],
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: AppDayCell(
              weekday: 'Per',
              day: 4,
              isSelected: true,
              onTap: () {},
            ),
          ),
          Expanded(
            child: AppDayCell(
              weekday: 'Cum',
              day: 5,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ],
      ),
      AppSettingsRow(
        icon: AppIcons.locked,
        title: 'Ebeveyn modu',
        subtitle: '4 haneli PIN ile',
        onTap: () {},
      ),
      AppSettingsRow(
        title: 'Görev puanı',
        subtitle: 'Sayaç · 5 puan adımlı',
        trailing: AppStepper(
          value: 20,
          decreaseLabel: 'Azalt',
          increaseLabel: 'Artır',
          onChanged: (_) {},
        ),
      ),
      const AppToast.reward(message: '+20 puan kazandın'),
      const AppToast.info(message: 'Talebin annene gönderildi'),
      const SizedBox(height: 200, child: AppLoadingView()),
      SizedBox(
        height: 240,
        child: AppEmptyView(
          message: 'Bugün için görev yok.',
          caption: 'Ebeveynin görev eklemesini bekle.',
          actionLabel: 'Görev ekle',
          onAction: () {},
        ),
      ),
      SizedBox(
        height: 260,
        child: AppErrorView(
          message: 'İnternet bağlantısı kurulamadı.',
          onRetry: () {},
        ),
      ),
    ],
  );
}

Future<void> _pump(
  WidgetTester tester,
  AppAccentEnum accent,
  Brightness brightness,
  Widget child,
) {
  return tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light
          ? AppTheme.light(accent)
          : AppTheme.dark(accent),
      locale: const Locale('tr'),
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets(
    'every component builds, in both themes and off the default accent',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final (AppAccentEnum accent, Brightness brightness)
          in <(AppAccentEnum, Brightness)>[
            (AppAccentEnum.blue, Brightness.light),
            (AppAccentEnum.blue, Brightness.dark),
            (AppAccentEnum.pink, Brightness.light),
            (AppAccentEnum.yellow, Brightness.dark),
          ]) {
        await _pump(tester, accent, brightness, _kit());
        await tester.pump();

        expect(
          tester.takeException(),
          isNull,
          reason: '${accent.name} ${brightness.name}',
        );
      }
    },
  );

  testWidgets('the navigation bar carries four tabs and the parent button', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    AppNavTabEnum? selected;
    await _pump(
      tester,
      AppAccentEnum.blue,
      Brightness.light,
      Align(
        alignment: Alignment.bottomCenter,
        child: AppBottomNav(
          currentTab: AppNavTabEnum.home,
          onSelected: (AppNavTabEnum tab) => selected = tab,
          onParentPressed: () {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Ana sayfa'), findsOneWidget);
    expect(find.text('Ödüller'), findsOneWidget);
    expect(find.text('İlerleme'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Ebeveyn'), findsOneWidget);

    await tester.tap(find.text('Ödüller'));

    expect(selected, AppNavTabEnum.rewards);
  });
}
