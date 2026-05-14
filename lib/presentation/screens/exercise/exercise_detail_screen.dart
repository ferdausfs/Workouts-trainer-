import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../domain/entities/exercise.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_card.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                expandedHeight: 280,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(colors: [
                        AppColors.pulseCyan.withOpacity(0.35),
                        AppColors.auroraViolet.withOpacity(0.35),
                      ]),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.fitness_center, size: 140, color: Colors.white.withOpacity(0.85))
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1500.ms),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _chip(exercise.difficulty.name.toUpperCase(), AppColors.coralGradient),
                            const SizedBox(width: 8),
                            _chip(exercise.primaryMuscles.first.name.toUpperCase(), AppColors.primaryGradient),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(exercise.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(exercise.description, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 24),
                        _section(context, 'Instructions', Icons.list_alt_rounded, exercise.instructions, AppColors.pulseCyan),
                        if (exercise.commonMistakes.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _section(context, 'Common Mistakes', Icons.warning_amber_rounded,
                              exercise.commonMistakes, AppColors.warning),
                        ],
                        if (exercise.safetyWarnings.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _section(context, 'Safety', Icons.health_and_safety_rounded,
                              exercise.safetyWarnings, AppColors.error),
                        ],
                        const SizedBox(height: 16),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Target Muscles', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8, runSpacing: 8,
                                children: [
                                  ...exercise.primaryMuscles.map((m) => _muscleChip(m.name, true)),
                                  ...exercise.secondaryMuscles.map((m) => _muscleChip(m.name, false)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text, Gradient g) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(gradient: g, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
    );
  }

  Widget _muscleChip(String name, bool primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (primary ? AppColors.pulseCyan : Colors.grey).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (primary ? AppColors.pulseCyan : Colors.grey).withOpacity(0.5)),
      ),
      child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _section(BuildContext context, String title, IconData icon, List<String> items, Color color) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22, height: 22, alignment: Alignment.center,
                  decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
                  child: Text('${e.key + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(e.value, style: const TextStyle(height: 1.5))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
