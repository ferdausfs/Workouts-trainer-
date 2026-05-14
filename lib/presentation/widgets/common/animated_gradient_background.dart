import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Subtle animated gradient mesh used on splash, onboarding, paywall.
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final t = _ctrl.value;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient,
              ),
            ),
            Positioned(
              top: 50 + (40 * t),
              left: -50 + (30 * t),
              child: _Blob(color: AppColors.pulseCyan.withOpacity(0.15), size: 260),
            ),
            Positioned(
              bottom: 80 + (50 * (1 - t)),
              right: -30 + (40 * (1 - t)),
              child: _Blob(color: AppColors.auroraViolet.withOpacity(0.15), size: 240),
            ),
            Positioned(
              top: 300 + (60 * t),
              right: 40 + (30 * t),
              child: _Blob(color: AppColors.neonCoral.withOpacity(0.10), size: 180),
            ),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }
}
