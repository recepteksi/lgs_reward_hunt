import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';

/// The glyph a reward's category is drawn with, from [AppIcons].
///
/// The design's own: a screen, a ticket, a cone, two people, and the points
/// star for a free choice. The one place the mapping happens, beside
/// `taskCategoryColor`, so the shop, the setup step and the parent's pool all
/// draw a category the same way.
String rewardCategoryIcon(RewardCategoryEnum category) => switch (category) {
  RewardCategoryEnum.screen => AppIcons.categoryScreen,
  RewardCategoryEnum.fun => AppIcons.categoryFun,
  RewardCategoryEnum.treat => AppIcons.categoryTreat,
  RewardCategoryEnum.social => AppIcons.categorySocial,
  RewardCategoryEnum.free => AppIcons.categoryFree,
};
