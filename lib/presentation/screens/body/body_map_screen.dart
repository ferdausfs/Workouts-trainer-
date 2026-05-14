import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/local/exercise_database.dart';
import '../../../domain/entities/exercise.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_card.dart';

class BodyMapScreen extends ConsumerStatefulWidget {
  const BodyMapScreen({super.key});

  @override
  ConsumerState<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends ConsumerState<BodyMapScreen>
    with SingleTickerProviderStateMixin {
  MuscleGroup? _selected;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    Text('Body Map', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _selected == null ? 'Tap a muscle group to see exercises' : 'Selected: ${_selected!.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.pulseCyan),
                ),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 0.5,
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) {
                        return CustomPaint(
                          painter: _BodyPainter(
                            selected: _selected,
                            pulse: _pulse.value,
                          ),
                          child: GestureDetector(
                            onTapDown: (d) => _handleTap(d, context),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (_selected != null) _exerciseList(_selected!),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(TapDownDetails d, BuildContext context) {
    final box = context.findRenderObject();
    if (box is! RenderBox) return;
    final size = box.size;
    if (size.width == 0 || size.height == 0) return;
    final x = d.localPosition.dx / size.width;
    final y = d.localPosition.dy / size.height;

    // Simple zone detection on body silhouette (front view)
    MuscleGroup? hit;
    if (y < 0.10) {
      hit = null; // head
    } else if (y < 0.18) {
      hit = MuscleGroup.shoulders;
    } else if (y < 0.30) {
      hit = MuscleGroup.chest;
    } else if (y < 0.42) {
      hit = (x < 0.4 || x > 0.6) ? MuscleGroup.biceps : MuscleGroup.abs;
    } else if (y < 0.55) {
      hit = MuscleGroup.abs;
    } else if (y < 0.72) {
      hit = MuscleGroup.quads;
    } else if (y < 0.92) {
      hit = MuscleGroup.calves;
    } else {
      return;
    }

    setState(() => _selected = hit);
  }

  Widget _exerciseList(MuscleGroup group) {
    final list = ExerciseDatabase.byMuscle(group);
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final ex = list[i];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 200,
              child: GlassCard(
                onTap: () => context.push('/exercise-detail', extra: ex),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(child: Icon(Icons.fitness_center, color: Colors.white, size: 36)),
                    ),
                    const SizedBox(height: 10),
                    Text(ex.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(ex.difficulty.name, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 70)).slideX(begin: 0.1);
        },
      ),
    );
  }
}

/// Custom-painted human body silhouette with highlightable zones.
class _BodyPainter extends CustomPainter {
  final MuscleGroup? selected;
  final double pulse;

  _BodyPainter({this.selected, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Body silhouette (simplified)
    final bodyPaint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Head
    canvas.drawCircle(Offset(w * 0.5, h * 0.06), w * 0.10, bodyPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.06), w * 0.10, outlinePaint);

    // Torso
    final torso = Path()
      ..moveTo(w * 0.25, h * 0.18)
      ..quadraticBezierTo(w * 0.20, h * 0.30, w * 0.25, h * 0.50)
      ..lineTo(w * 0.30, h * 0.55)
      ..lineTo(w * 0.70, h * 0.55)
      ..lineTo(w * 0.75, h * 0.50)
      ..quadraticBezierTo(w * 0.80, h * 0.30, w * 0.75, h * 0.18)
      ..close();
    canvas.drawPath(torso, bodyPaint);
    canvas.drawPath(torso, outlinePaint);

    // Arms
    final leftArm = Path()
      ..moveTo(w * 0.22, h * 0.20)
      ..lineTo(w * 0.10, h * 0.42)
      ..lineTo(w * 0.15, h * 0.45)
      ..lineTo(w * 0.27, h * 0.24)
      ..close();
    final rightArm = Path()
      ..moveTo(w * 0.78, h * 0.20)
      ..lineTo(w * 0.90, h * 0.42)
      ..lineTo(w * 0.85, h * 0.45)
      ..lineTo(w * 0.73, h * 0.24)
      ..close();
    canvas.drawPath(leftArm, bodyPaint);
    canvas.drawPath(rightArm, bodyPaint);
    canvas.drawPath(leftArm, outlinePaint);
    canvas.drawPath(rightArm, outlinePaint);

    // Legs
    final leftLeg = Path()
      ..moveTo(w * 0.30, h * 0.55)
      ..lineTo(w * 0.28, h * 0.95)
      ..lineTo(w * 0.45, h * 0.95)
      ..lineTo(w * 0.48, h * 0.55)
      ..close();
    final rightLeg = Path()
      ..moveTo(w * 0.52, h * 0.55)
      ..lineTo(w * 0.55, h * 0.95)
      ..lineTo(w * 0.72, h * 0.95)
      ..lineTo(w * 0.70, h * 0.55)
      ..close();
    canvas.drawPath(leftLeg, bodyPaint);
    canvas.drawPath(rightLeg, bodyPaint);
    canvas.drawPath(leftLeg, outlinePaint);
    canvas.drawPath(rightLeg, outlinePaint);

    // Highlight selected muscle
    if (selected != null) {
      final hl = Paint()
        ..color = _colorFor(selected!).withOpacity(0.45 + pulse * 0.25)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 + pulse * 4);


      switch (selected!) {
        case MuscleGroup.chest:
          canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.24), width: w * 0.45, height: h * 0.10), hl);
          break;
        case MuscleGroup.shoulders:
          canvas.drawCircle(Offset(w * 0.25, h * 0.20), w * 0.07, hl);
          canvas.drawCircle(Offset(w * 0.75, h * 0.20), w * 0.07, hl);
          break;
        case MuscleGroup.abs:
          canvas.drawRect(Rect.fromCenter(center: Offset(w * 0.5, h * 0.40), width: w * 0.30, height: h * 0.15), hl);
          break;
        case MuscleGroup.biceps:
          canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.18, h * 0.32), width: w * 0.10, height: h * 0.10), hl);
          canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.82, h * 0.32), width: w * 0.10, height: h * 0.10), hl);
          break;
        case MuscleGroup.quads:
          canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.38, h * 0.65), width: w * 0.18, height: h * 0.18), hl);
          canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.62, h * 0.65), width: w * 0.18, height: h * 0.18), hl);
          break;
        case MuscleGroup.calves:
          canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.36, h * 0.85), width: w * 0.14, height: h * 0.12), hl);
          canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.64, h * 0.85), width: w * 0.14, height: h * 0.12), hl);
          break;
        default: break;
      }
    }
  }

  Color _colorFor(MuscleGroup g) {
    switch (g) {
      case MuscleGroup.chest: return AppColors.chestColor;
      case MuscleGroup.back: return AppColors.backColor;
      case MuscleGroup.shoulders: return AppColors.shouldersColor;
      case MuscleGroup.biceps:
      case MuscleGroup.triceps: return AppColors.armsColor;
      case MuscleGroup.abs:
      case MuscleGroup.obliques: return AppColors.absColor;
      case MuscleGroup.quads:
      case MuscleGroup.hamstrings:
      case MuscleGroup.glutes:
      case MuscleGroup.calves: return AppColors.legsColor;
      default: return AppColors.pulseCyan;
    }
  }

  @override
  bool shouldRepaint(covariant _BodyPainter old) =>
      old.selected != selected || old.pulse != pulse;
}
