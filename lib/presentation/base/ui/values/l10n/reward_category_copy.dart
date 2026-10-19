import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [RewardCategoryEnum] into its word — the one place that mapping
/// happens, so a sixth category does not compile until it has a name.
String rewardCategoryCopy(AppL10n l10n, RewardCategoryEnum category) =>
    switch (category) {
      RewardCategoryEnum.screen => l10n.rewardCategoryScreen,
      RewardCategoryEnum.fun => l10n.rewardCategoryFun,
      RewardCategoryEnum.treat => l10n.rewardCategoryTreat,
      RewardCategoryEnum.social => l10n.rewardCategorySocial,
      RewardCategoryEnum.free => l10n.rewardCategoryFree,
    };
