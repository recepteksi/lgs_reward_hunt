import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_map_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_day_sheet.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_map.dart';

/// The home page's one body: the map, a fade under the floating bar, and the
/// day sheet over the bottom.
///
/// The map runs under the navigation bar; the sheet stops above it — the
/// scaffold reports the bar's height as the body's bottom padding — so the
/// tasks it peeks at are never under the bar.
///
/// Which stop the sheet shows is kept here — it is where the child is looking,
/// not something the map knows — and starts on today. When the map comes back
/// after a task is ticked the selection stays where it was.
///
/// [map] is what to draw, [onComplete] ticks a task, [busyTaskId] is one being
/// ticked and [failure] a refused tick.
class HomeBody extends StatefulWidget {
  const HomeBody({
    required this.map,
    required this.onComplete,
    this.busyTaskId,
    this.failure,
    super.key,
  });

  final StudyMapReadModel map;

  final ValueChanged<String> onComplete;

  final String? busyTaskId;

  final Failure? failure;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

/// Holds the selected stop.
class _HomeBodyState extends State<HomeBody> {
  static const double _fadeHeight = 130;

  late int _selected = widget.map.path.todayIndex;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final int selected = _selected.clamp(
      ValueConstants.zero,
      widget.map.path.stops.length - ValueConstants.one,
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: HomeMap(
            path: widget.map.path,
            selectedIndex: selected,
            onSelect: (int index) => setState(() => _selected = index),
          ),
        ),
        Positioned(
          left: ValueConstants.zeroDouble,
          right: ValueConstants.zeroDouble,
          top: ValueConstants.zeroDouble,
          height: _fadeHeight,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    palette.mapBase,
                    palette.mapBase.withValues(
                      alpha: ValueConstants.zeroDouble,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          child: HomeDaySheet(
            stop: widget.map.path.stops[selected],
            onComplete: widget.onComplete,
            busyTaskId: widget.busyTaskId,
            failure: widget.failure,
          ),
        ),
      ],
    );
  }
}
