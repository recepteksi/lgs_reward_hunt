import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/settings/use_cases/read_appearance_use_case.dart';
import 'package:lgs_reward_hunt/application/settings/use_cases/save_appearance_use_case.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/accent_choice_enum.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/theme_choice_enum.dart';
import 'package:lgs_reward_hunt/domain/settings/value_objects/appearance_settings_value_object.dart';

part 'appearance_state.dart';

/// The one Cubit that is not a screen's: it belongs to the shell.
///
/// Every other Cubit in this app is owned by a page and dies with it. This one
/// is created above `MaterialApp` and lives as long as the app does, because
/// what it holds — the accent and the brightness — is read by every screen at
/// once and changed from one of them. A per-page Cubit cannot do that; it would
/// have to be lifted, and lifting it later means every screen that read it
/// changes too.
///
/// It is a `lazySingleton`, unlike every other Cubit here: `main` restores it
/// before the first frame and the shell reads that same instance, so a factory
/// would hand the shell a second, empty one and the restore would go nowhere.
/// It is provided with `BlocProvider.value`, which does not close what it did
/// not create — closing the shell's Cubit would mean closing the app.
///
/// It emits before it saves. A student tapping a colour sees it on the same
/// frame, and the disk write happens behind that; if the write fails there is
/// nothing to tell them, because the app already looks the way they asked and
/// the only loss is on the next launch.
@lazySingleton
final class AppearanceCubit extends Cubit<AppearanceState> {
  AppearanceCubit(this._readAppearance, this._saveAppearance)
    : super(const AppearanceReady(AppearanceSettingsValueObject.initial));

  final ReadAppearanceUseCase _readAppearance;

  final SaveAppearanceUseCase _saveAppearance;

  Future<void> restore() async {
    final result = await _readAppearance();
    if (isClosed) return;

    emit(switch (result) {
      Left() => const AppearanceReady(AppearanceSettingsValueObject.initial),
      Right(:final value) => AppearanceReady(value),
    });
  }

  void chooseAccent(AccentChoiceEnum accent) =>
      _apply(state.settings.copyWith(accent: accent));

  void chooseTheme(ThemeChoiceEnum theme) =>
      _apply(state.settings.copyWith(theme: theme));

  void _apply(AppearanceSettingsValueObject settings) {
    emit(AppearanceReady(settings));
    unawaited(_saveAppearance(settings));
  }
}
