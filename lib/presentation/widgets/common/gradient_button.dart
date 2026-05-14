import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final IconData? icon;
  final bool loading;
  final double height;
  final double radius;
  final double fontSize;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.gradient = AppColors.primaryGradient,
    this.icon,
    this.loading = false,
    this.height = 56,
    this.radius = 18,
    this.fontSize = 16,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    return GestureDetector(
      onTapDown: (_) {
        if (enabled) _ctrl.animateTo(0.95);
      },
      onTapUp: (_) => _ctrl.animateTo(1.0),
      onTapCancel: () => _ctrl.animateTo(1.0),
      onTap: enabled ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            gradient: enabled ? widget.gradient : null,
            color: enabled ? null : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: enabled ? [
              BoxShadow(
                color: AppColors.pulseCyan.withOpacity(0.35),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ] : null,
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? const SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.black87),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
