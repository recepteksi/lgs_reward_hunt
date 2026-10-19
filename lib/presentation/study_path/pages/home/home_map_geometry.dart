import 'dart:ui';

import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/study_path/rules/study_map_rules.dart';

/// Where everything on the map sits, for a path of [stopCount] stops drawn
/// [width] wide.
///
/// The design's own layout, measured on its 402-wide phone and scaled to the
/// width given: the stops zigzag through four columns ([_columns], as
/// fractions of the width), [_gap] apart from the bottom up, with room at the
/// top for the exam flag and at the bottom for the day sheet's peek. The
/// trail between two stops is a quadratic curve pulled [_bend] to one side
/// and then the other, which is what makes it read as a road rather than a
/// zigzag.
///
/// [height] is the scrollable map's height. [stopCenter] is a stop's centre,
/// stop 0 at the bottom. [trailTo] is the curve's control point into a stop.
/// [zoneDividerY] is the middle of the gap before the first stop of a zone.
/// [examCenter] is the centre of the exam flag's disc and [farChipY] where the
/// "stops ahead" chip sits above the last stop. `bend` and `farBendX` shape
/// the dashed road from the last stop to the flag. [stopRadiusFor] is half
/// the kit stop's diameter for each kind, which is how far above its centre a
/// stop is placed.
final class HomeMapGeometry {
  const HomeMapGeometry({required this.width, required this.stopCount});

  static const double _designWidth = 402;

  static const List<double> _columns = <double>[196, 92, 196, 300];

  static const double _gap = 125;

  static const double _top = 320;

  static const double _bottom = 240;

  static const double _bend = 22;

  static const double _examY = 146;

  static const double _examLabelY = 206;

  static const double _farChipAbove = 96;

  static const double _farBend = 60;

  static const double _farControlY = 250;

  static const double _zoneLabelHalf = 9;

  static const double _todayRadius = 39;

  static const double _specialRadius = 31;

  static const double _stopRadius = 25;

  final double width;

  final int stopCount;

  static double stopRadiusFor({
    required bool isToday,
    required bool isSpecial,
  }) => isToday
      ? _todayRadius
      : isSpecial
      ? _specialRadius
      : _stopRadius;

  double get _scale => width / _designWidth;

  double get height => _top + (stopCount - ValueConstants.one) * _gap + _bottom;

  Offset stopCenter(int index) => Offset(
    _columns[index % _columns.length] * _scale,
    height - _bottom - index * _gap,
  );

  Offset trailTo(int index) {
    final Offset from = stopCenter(index - ValueConstants.one);
    final Offset to = stopCenter(index);
    return Offset(
      (from.dx + to.dx) / ValueConstants.two + (index.isOdd ? _bend : -_bend),
      (from.dy + to.dy) / ValueConstants.two,
    );
  }

  double zoneDividerY(int index) =>
      (stopCenter(index).dy + stopCenter(index - ValueConstants.one).dy) /
          ValueConstants.two -
      _zoneLabelHalf;

  bool startsZone(int index) =>
      index > ValueConstants.zero &&
      index % StudyMapRules.stopsPerZone == ValueConstants.zero;

  Offset get examCenter => Offset(width / ValueConstants.two, _examY);

  double get examLabelY => _examLabelY;

  double get farChipY =>
      stopCenter(stopCount - ValueConstants.one).dy - _farChipAbove;

  Offset get farControl => Offset(
    stopCenter(stopCount - ValueConstants.one).dx + _farBend * _scale,
    _farControlY,
  );
}
