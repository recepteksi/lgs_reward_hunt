import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';

/// The colour of the dot a task's category is marked with.
///
/// Read from the palette, so it follows the accent like everything else. The
/// lessons get the design's five voices — the primary for maths, the reward
/// ink for Turkish, the earned green for science, the error red for history
/// and the practice exam, the primary container's ink for English — and
/// reading is the quiet ink. Every chore shares one colour: they are one
/// group to the parent, and the lessons are what the eye should separate.
Color taskCategoryColor(AppPalette palette, TaskCategoryEnum category) {
  if (category.kind == TaskKindEnum.chore) return palette.onPrimaryContainer;

  return switch (category) {
    TaskCategoryEnum.math => palette.primary,
    TaskCategoryEnum.turkish => palette.rewardInk,
    TaskCategoryEnum.science => palette.success,
    TaskCategoryEnum.history || TaskCategoryEnum.practiceExam => palette.error,
    TaskCategoryEnum.english => palette.onPrimaryContainer,
    TaskCategoryEnum.reading ||
    TaskCategoryEnum.brushTeeth ||
    TaskCategoryEnum.tidyRoom ||
    TaskCategoryEnum.dishes ||
    TaskCategoryEnum.trash ||
    TaskCategoryEnum.laundry ||
    TaskCategoryEnum.drinkWater ||
    TaskCategoryEnum.exercise ||
    TaskCategoryEnum.earlyBed ||
    TaskCategoryEnum.screenFree => palette.onSurfaceMuted,
  };
}
