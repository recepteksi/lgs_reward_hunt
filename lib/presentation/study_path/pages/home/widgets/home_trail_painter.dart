import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/home_map_geometry.dart';

/// The road on the map, painted once: the terrain marks, the locked road, the
/// stretch already walked, and the dashed way on to the exam.
///
/// A painter rather than a widget tree, because the road is one continuous
/// curve through every stop and a widget per segment would be dozens of
/// layers for a single line. It is drawn back to front the way the design
/// stacks its strokes: a shadowed kerb under a pale locked road with a dotted
/// centre line, and over it the primary-coloured road as far as [reached]
/// stops, with its own dotted line.
///
/// The terrain — contour rings and specks beside the road — is placed by a
/// small seeded generator ([_seed]) — a contour ring beside every third stop,
/// a speck beside every other — so it lands in the same places on every
/// frame and every phone instead of shimmering on each rebuild.
///
/// [geometry] places everything, [palette] colours it, [reached] is how many
/// stops the walked road runs through.
class HomeTrailPainter extends CustomPainter {
  const HomeTrailPainter({
    required this.geometry,
    required this.palette,
    required this.reached,
  });

  static const int _seed = 91;

  static const int _lcgMultiplier = 1103515245;

  static const int _lcgIncrement = 12345;

  static const int _lcgModulus = 2147483648;

  static const double _kerb = 27;

  static const double _kerbDrop = 7;

  static const double _kerbOpacity = 0.75;

  static const double _road = 25;

  static const double _roadInner = 17;

  static const double _centreLine = 3.4;

  static const double _centreDash = 3;

  static const double _centreGap = 16;

  static const double _walkedLineOpacity = 0.5;

  static const double _farRoad = 13;

  static const double _farDash = 16;

  static const double _farGap = 14;

  static const double _farOpacity = 0.85;

  static const double _contourStroke = 2;

  static const List<double> _contourScales = <double>[1, 0.66, 0.34];

  static const List<double> _contourOpacities = <double>[0.5, 0.4, 0.3];

  static const double _speckOpacity = 0.55;

  static const int _contourEvery = 3;

  static const double _contourReach = 104;

  static const double _contourReachSpread = 46;

  static const double _contourRise = -40;

  static const double _contourRiseSpread = 80;

  static const double _contourRadius = 30;

  static const double _contourRadiusSpread = 30;

  static const double _speckReach = 72;

  static const double _speckReachSpread = 34;

  static const double _speckDrop = 20;

  static const double _speckDropSpread = 70;

  static const double _speckRadius = 2;

  static const double _speckRadiusSpread = 2.4;

  final HomeMapGeometry geometry;

  final AppPalette palette;

  final int reached;

  @override
  void paint(Canvas canvas, Size size) {
    _paintTerrain(canvas);

    final Path road = _roadThrough(geometry.stopCount);
    final Path far = Path()
      ..moveTo(
        geometry.stopCenter(geometry.stopCount - ValueConstants.one).dx,
        geometry.stopCenter(geometry.stopCount - ValueConstants.one).dy,
      )
      ..quadraticBezierTo(
        geometry.farControl.dx,
        geometry.farControl.dy,
        geometry.examCenter.dx,
        geometry.examCenter.dy,
      );

    canvas.drawPath(
      _dashed(far, _farDash, _farGap),
      _stroke(palette.mapLine.withValues(alpha: _farOpacity), _farRoad),
    );
    canvas.drawPath(
      road.shift(const Offset(ValueConstants.zeroDouble, _kerbDrop)),
      _stroke(palette.mapEdge.withValues(alpha: _kerbOpacity), _kerb),
    );
    canvas.drawPath(road, _stroke(palette.mapLockedEdge, _road));
    canvas.drawPath(road, _stroke(palette.mapLocked, _roadInner));
    canvas.drawPath(
      _dashed(road, _centreDash, _centreGap),
      _stroke(palette.mapLine, _centreLine),
    );

    if (reached <= ValueConstants.one) return;
    final Path walked = _roadThrough(
      reached.clamp(ValueConstants.zero, geometry.stopCount),
    );
    canvas.drawPath(walked, _stroke(palette.primaryShade, _road));
    canvas.drawPath(walked, _stroke(palette.primary, _roadInner));
    canvas.drawPath(
      _dashed(walked, _centreDash, _centreGap),
      _stroke(
        palette.onPrimarySoft.withValues(alpha: _walkedLineOpacity),
        _centreLine,
      ),
    );
  }

  @override
  bool shouldRepaint(HomeTrailPainter oldDelegate) =>
      oldDelegate.reached != reached ||
      oldDelegate.palette != palette ||
      oldDelegate.geometry.width != geometry.width ||
      oldDelegate.geometry.stopCount != geometry.stopCount;

  Path _roadThrough(int count) {
    final Offset first = geometry.stopCenter(ValueConstants.zero);
    final Path path = Path()..moveTo(first.dx, first.dy);
    for (int index = ValueConstants.one; index < count; index++) {
      final Offset control = geometry.trailTo(index);
      final Offset to = geometry.stopCenter(index);
      path.quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);
    }
    return path;
  }

  void _paintTerrain(Canvas canvas) {
    int seed = _seed;
    double next() {
      seed = (seed * _lcgMultiplier + _lcgIncrement) % _lcgModulus;
      return seed / _lcgModulus;
    }

    final double middle = geometry.width / ValueConstants.two;
    for (int index = ValueConstants.zero; index < geometry.stopCount; index++) {
      final Offset stop = geometry.stopCenter(index);
      final double away = stop.dx > middle
          ? ValueConstants.minusOne.toDouble()
          : ValueConstants.oneDouble;

      if (index % _contourEvery == ValueConstants.one) {
        final Offset centre = Offset(
          stop.dx + away * (_contourReach + next() * _contourReachSpread),
          stop.dy + _contourRise + next() * _contourRiseSpread,
        );
        final double radius = _contourRadius + next() * _contourRadiusSpread;
        for (
          int ring = ValueConstants.zero;
          ring < _contourScales.length;
          ring++
        ) {
          canvas.drawCircle(
            centre,
            radius * _contourScales[ring],
            _stroke(
              palette.mapEdge.withValues(alpha: _contourOpacities[ring]),
              _contourStroke,
            ),
          );
        }
      }

      if (index.isEven) {
        canvas.drawCircle(
          Offset(
            stop.dx - away * (_speckReach + next() * _speckReachSpread),
            stop.dy + _speckDrop + next() * _speckDropSpread,
          ),
          _speckRadius + next() * _speckRadiusSpread,
          Paint()..color = palette.mapLine.withValues(alpha: _speckOpacity),
        );
      }
    }
  }

  Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Path _dashed(Path source, double dash, double gap) {
    final Path dashed = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = ValueConstants.zeroDouble;
      while (distance < metric.length) {
        dashed.addPath(
          metric.extractPath(distance, distance + dash),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }
    return dashed;
  }
}
