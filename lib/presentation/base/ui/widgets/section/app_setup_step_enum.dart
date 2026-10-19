import 'package:lgs_reward_hunt/core/constants/value_constants.dart';

/// The steps of setup, in the order a parent walks them.
///
/// One enum rather than a `step` and a `totalSteps` constant beside each page:
/// the order is a single fact about the flow, and four files each saying "three
/// of six" are four places to forget when a step is added. The order here IS
/// the order in the header, so inserting a step renumbers every page after it
/// and grows every page's total without anyone touching them.
///
/// [number] is the step as it is spoken, one-based, and [total] how many there
/// are. The intro is not a step — nothing is being set up yet — which is why it
/// is not in this list.
enum AppSetupStepEnum {
  account,
  password,
  parentPin,
  child,
  tasks,
  rewards;

  int get number => index + ValueConstants.one;

  static int get total => values.length;
}
