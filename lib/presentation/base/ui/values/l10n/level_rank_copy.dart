import 'package:lgs_reward_hunt/domain/progress/enums/level_rank_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [LevelRankEnum] into the name on the level card — the one place
/// that mapping happens.
String levelRankCopy(AppL10n l10n, LevelRankEnum rank) => switch (rank) {
  LevelRankEnum.rookie => l10n.levelRankRookie,
  LevelRankEnum.tracker => l10n.levelRankTracker,
  LevelRankEnum.mapMaster => l10n.levelRankMapMaster,
  LevelRankEnum.treasureHunter => l10n.levelRankTreasureHunter,
};
