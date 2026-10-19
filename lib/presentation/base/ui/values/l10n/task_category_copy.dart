import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [TaskCategoryEnum] into the subject or chore a parent reads.
///
/// The one place that mapping happens, like `failureCopy`: a category added to
/// the domain does not compile here until it has a name.
String taskCategoryCopy(AppL10n l10n, TaskCategoryEnum category) =>
    switch (category) {
      TaskCategoryEnum.math => l10n.taskCategoryMath,
      TaskCategoryEnum.turkish => l10n.taskCategoryTurkish,
      TaskCategoryEnum.science => l10n.taskCategoryScience,
      TaskCategoryEnum.history => l10n.taskCategoryHistory,
      TaskCategoryEnum.english => l10n.taskCategoryEnglish,
      TaskCategoryEnum.reading => l10n.taskCategoryReading,
      TaskCategoryEnum.practiceExam => l10n.taskCategoryPracticeExam,
      TaskCategoryEnum.brushTeeth => l10n.taskCategoryBrushTeeth,
      TaskCategoryEnum.tidyRoom => l10n.taskCategoryTidyRoom,
      TaskCategoryEnum.dishes => l10n.taskCategoryDishes,
      TaskCategoryEnum.trash => l10n.taskCategoryTrash,
      TaskCategoryEnum.laundry => l10n.taskCategoryLaundry,
      TaskCategoryEnum.drinkWater => l10n.taskCategoryDrinkWater,
      TaskCategoryEnum.exercise => l10n.taskCategoryExercise,
      TaskCategoryEnum.earlyBed => l10n.taskCategoryEarlyBed,
      TaskCategoryEnum.screenFree => l10n.taskCategoryScreenFree,
    };
