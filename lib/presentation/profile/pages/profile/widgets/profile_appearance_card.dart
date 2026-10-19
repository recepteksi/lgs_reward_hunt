import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/settings/cubit/appearance/appearance_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/accent_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/theme_mode_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_appearance_picker.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_section_header.dart';

/// The appearance setting on the profile: brightness and accent.
///
/// It reads `AppearanceCubit` from above — `App` provides it, as the app's one
/// shell-level Cubit — so a tap
/// re-themes the whole app at once and is saved — the same Cubit `main`
/// restores before the first frame. The line under the title says what is
/// chosen in words, for the child who cannot see the difference between two
/// swatches.
class ProfileAppearanceCard extends StatelessWidget {
  const ProfileAppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    return BlocBuilder<AppearanceCubit, AppearanceState>(
      builder: (BuildContext context, AppearanceState state) {
        final ThemeMode mode = AppTheme.modeFrom(state.settings.theme);
        final AppAccentEnum accent = AppAccentEnum.from(state.settings.accent);

        return AppCard(
          radius: AppRadii.xxxl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppSectionHeader(
                title: l10n.profileAppearanceTitle,
                trailing: l10n.profileAppearanceSummary(
                  themeModeCopy(l10n, mode),
                  accentCopy(l10n, accent),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppAppearancePicker(
                mode: mode,
                accent: accent,
                onModeChanged: (ThemeMode value) => context
                    .read<AppearanceCubit>()
                    .chooseTheme(AppTheme.choiceFrom(value)),
                onAccentChanged: (AppAccentEnum value) =>
                    context.read<AppearanceCubit>().chooseAccent(value.choice),
              ),
            ],
          ),
        );
      },
    );
  }
}
