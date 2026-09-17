import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';

/// The dashed outline a locked row wears.
///
/// Dashed rather than solid because the row is not off — it is not open yet,
/// and a solid grey border reads as disabled where a dashed one reads as
/// waiting. Flutter has no dashed `BorderSide`, so the rounded rectangle is cut
/// into dashes by walking its own path metrics, which keeps the dashes even
/// around the corners instead of bunching at them.
class AppDashedBorderPainter extends CustomPainter {
  const AppDashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  static const double _dash = 6;

  static const double _gap = 5;

  final Color color;

  final double radius;

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Path source = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ).deflate(strokeWidth / ValueConstants.two),
      );
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (final PathMetric metric in source.computeMetrics()) {
      double start = ValueConstants.zeroDouble;

      while (start < metric.length) {
        final double end = (start + _dash).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(start, end), paint);
        start = end + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(AppDashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth;
}
