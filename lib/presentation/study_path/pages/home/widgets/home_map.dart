import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_path_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/home_map_geometry.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/items/home_map_stop_item.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_exam_flag.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_far_chip.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_trail_painter.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_zone_divider.dart';

/// The scrolling map: the painted road, the stops on it, the zone names and
/// the exam at the top.
///
/// It opens scrolled so today sits a little below the middle of what is left
/// above the day sheet — the child sees the stop they are on and the next few
/// ahead of it, which is the whole point of drawing a road. The scroll
/// position is set once, from the first layout, and left to the child after
/// that.
///
/// [path] is the road, [selectedIndex] the stop the sheet shows, [onSelect]
/// selects another.
class HomeMap extends StatefulWidget {
  const HomeMap({
    required this.path,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  final StudyPathReadModel path;

  final int selectedIndex;

  final ValueChanged<int> onSelect;

  @override
  State<HomeMap> createState() => _HomeMapState();
}

/// Holds the scroll position.
class _HomeMapState extends State<HomeMap> {
  static const double _todayFromTop = 0.4;

  static const double _stopColumn = 78;

  static const double _zoneInset = 20;

  static const double _farChipHalf = 16;

  ScrollController? _scroll;

  @override
  void dispose() {
    _scroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final StudyPathReadModel path = widget.path;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final HomeMapGeometry geometry = HomeMapGeometry(
          width: constraints.maxWidth,
          stopCount: path.stops.length,
        );
        final double todayY = geometry.stopCenter(path.todayIndex).dy;
        _scroll ??= ScrollController(
          initialScrollOffset: (todayY - constraints.maxHeight * _todayFromTop)
              .clamp(
                ValueConstants.zeroDouble,
                (geometry.height - constraints.maxHeight).clamp(
                  ValueConstants.zeroDouble,
                  double.infinity,
                ),
              ),
        );

        return ColoredBox(
          color: palette.mapBase,
          child: SingleChildScrollView(
            controller: _scroll,
            child: SizedBox(
              width: geometry.width,
              height: geometry.height,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: HomeTrailPainter(
                          geometry: geometry,
                          palette: palette,
                          reached: path.reachedCount,
                        ),
                      ),
                    ),
                  ),
                  for (
                    int index = ValueConstants.one;
                    index < path.stops.length;
                    index++
                  )
                    if (geometry.startsZone(index))
                      Positioned(
                        left: _zoneInset,
                        right: _zoneInset,
                        top: geometry.zoneDividerY(index),
                        child: HomeZoneDivider(number: path.zoneOf(index)),
                      ),
                  Positioned(
                    left: ValueConstants.zeroDouble,
                    right: ValueConstants.zeroDouble,
                    top: geometry.examCenter.dy - HomeExamFlag.discRadius,
                    child: Center(child: HomeExamFlag(examDate: path.examDate)),
                  ),
                  if (path.daysBeyond > ValueConstants.zero)
                    Positioned(
                      left: ValueConstants.zeroDouble,
                      right: ValueConstants.zeroDouble,
                      top: geometry.farChipY - _farChipHalf,
                      child: Center(child: HomeFarChip(days: path.daysBeyond)),
                    ),
                  for (
                    int index = ValueConstants.zero;
                    index < path.stops.length;
                    index++
                  )
                    Positioned(
                      left:
                          geometry.stopCenter(index).dx -
                          _stopColumn / ValueConstants.two,
                      top:
                          geometry.stopCenter(index).dy -
                          HomeMapGeometry.stopRadiusFor(
                            isToday: index == path.todayIndex,
                            isSpecial: path.stops[index].isSpecial,
                          ),
                      child: HomeMapStopItem(
                        stop: path.stops[index],
                        isSelected: index == widget.selectedIndex,
                        onTap: () => widget.onSelect(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
