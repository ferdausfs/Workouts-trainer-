import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../domain/entities/workout.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../../core/theme/app_colors.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final Workout workout;
  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _appBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _heroCard(context).animate().fadeIn().slideY(begin: 0.05),
                    const SizedBox(height: 16),
                    _statsRow().animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 24),
                    Text('Exercises (${workout.exercises.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    ...List.generate(workout.exercises.length, (i) {
                      final we = workout.exercises[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          onTap: () => context.push('/exercise-detail', extra: we.exercise),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text('${i + 1}',
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(we.exercise.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                    Text(we.exercise.isTimed
                                        ? '${we.sets} sets × ${we.durationSeconds ?? 30}s'
                                        : '${we.sets} sets × ${we.reps} reps',
                                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: Duration(milliseconds: 150 + i * 50)).slideX(begin: 0.05);
                    }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        color: Colors.transparent,
        child: GradientButton(
          label: 'Start Workout',
          icon: Icons.play_arrow_rounded,
          onPressed: () => context.push('/workout-player', extra: workout),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
        ],
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: AppColors.coralGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(workout.difficulty.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 14),
          Text(workout.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(workout.description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _stat(Icons.timer, '${workout.estimatedMinutes}', 'minutes')),
        const SizedBox(width: 12),
        Expanded(child: _stat(Icons.local_fire_department, '${workout.estimatedCalories}', 'kcal')),
        const SizedBox(width: 12),
        Expanded(child: _stat(Icons.fitness_center, '${workout.exercises.length}', 'exercises')),
      ],
    );
  }

  Widget _stat(IconData icon, String value, String label) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, color: AppColors.pulseCyan, size: 22),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
