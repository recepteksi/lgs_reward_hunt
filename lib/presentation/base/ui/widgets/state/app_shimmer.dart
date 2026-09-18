import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/duration_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';

/// The loading highlight: one light band sweeping across the skeletons in
/// [child].
///
/// Every shimmer on screen runs in one phase, taken from the clock when it
/// starts — boxes each sweeping on their own read as noise. A shimmer wraps
/// only skeletons, never the card around them, because the band is painted
/// over every opaque pixel beneath it (`BlendMode.srcATop`). The colours are
/// surfaces, never the accent: a skeleton is not content. With animations
/// turned off on the device the band stops and the skeletons stay flat.
class AppShimmer extends StatefulWidget {
  const AppShimmer({required this.child, super.key});

  final Widget child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  static const double _travel = 4;

  static const double _start = -3;

  static const double _band = 2;

  static const double _tilt = 0.35;

  static const List<double> _stops = <double>[0.4, 0.5, 0.6];

  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: DurationConstants.shimmer,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _sweep.stop();
    } else if (!_sweep.isAnimating) {
      _sweep
        ..value = _phaseNow()
        ..repeat();
    }
  }

  double _phaseNow() {
    final int period = DurationConstants.shimmer.inMicroseconds;
    return (DateTime.now().microsecondsSinceEpoch % period) / period;
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color base = palette.surfaceHigh;
    final Color light = dark ? palette.outline : palette.surface;

    return AnimatedBuilder(
      animation: _sweep,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double x = _start + _travel * _sweep.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) => LinearGradient(
            begin: Alignment(x, -_tilt),
            end: Alignment(x + _band, _tilt),
            colors: <Color>[base, light, base],
            stops: _stops,
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}
