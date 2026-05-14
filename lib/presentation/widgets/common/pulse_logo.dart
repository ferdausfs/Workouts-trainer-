import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Animated pulse heart logo - original PulseFit AI branding.
class PulseLogo extends StatefulWidget {
  final double size;
  final bool enablePulse;
  const PulseLogo({super.key, this.size = 100, this.enablePulse = true});

  @override
  State<PulseLogo> createState() => _PulseLogoState();
}

class _PulseLogoState extends State<PulseLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final scale = widget.enablePulse ? 1.0 + (_ctrl.value * 0.08) : 1.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.pulseCyan.withOpacity(0.45 + _ctrl.value * 0.2),
                  blurRadius: 40 + _ctrl.value * 25,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: widget.size * 0.55,
            ),
          ),
        );
      },
    );
  }
}