import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';

/// Draws the track and the arc over it.
///
/// The arc starts at twelve o'clock and runs clockwise with a round cap, so a
/// day with one task done looks like a beginning rather than like a slice of a
/// pie chart.
class AppProgressRingPainter extends CustomPainter {
  const AppProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.color,
    required this.strokeWidth,
  });

  static const double _start = -math.pi / ValueConstants.two;

  static const double _fullTurn = math.pi * ValueConstants.two;

  final double progress;

  final Color trackColor;

  final Color color;

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect circle = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - strokeWidth) / ValueConstants.two,
    );
    final Paint track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(circle, ValueConstants.zeroDouble, _fullTurn, false, track);

    if (progress <= ValueConstants.zeroDouble) {
      return;
    }

    canvas.drawArc(
      circle,
      _start,
      _fullTurn * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(AppProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}
