import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/user_controller.dart';
import '../../controllers/workout_controller.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/calculators.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/entities/user_profile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider);
    final plan = ref.watch(activePlanProvider);

    if (user == null) return const Center(child: CircularProgressIndicator());

    final bmr = Calculators.bmr(
      weightKg: user.weightKg, heightCm: user.heightCm,
      age: user.age, gender: user.gender.name,
    );
    final tdee = Calculators.tdee(bmr, user.activity.name);
    final target = Calculators.calorieTarget(tdee, user.goal.name == 'fatLoss' ? 'fat_loss' :
        user.goal.name == 'muscleGain' ? 'muscle_gain' : 'maintenance');

    return AnimatedGradientBackground(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header(context, user)),
            SliverToBoxAdapter(child: _todayCard(context, plan, target.toInt())),
            SliverToBoxAdapter(child: _quickStats(context, user, bmr, tdee)),
            SliverToBoxAdapter(child: _planList(context, plan)),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, UserProfile user) {
    final hour = DateTime.now().hour;
    final greet = hour < 12 ? 'Good morning' : hour < 18 ? 'Good afternoon' : 'Good evening';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greet, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(user.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/settings'),
            child: Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              alignment: Alignment.center,
              child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _todayCard(BuildContext context, WorkoutPlan? plan, int calTarget) {
    final workout = plan?.workouts.isNotEmpty == true ? plan!.workouts[0] : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.coralGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('TODAY', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.2,
                  )),
                ),
                Icon(Icons.auto_awesome, color: AppColors.pulseCyan, size: 22),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              workout?.name ?? 'Rest Day',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              workout?.description ?? 'Recover and refuel.',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _miniStat(Icons.access_time_filled, '${workout?.estimatedMinutes ?? 0} min'),
                const SizedBox(width: 16),
                _miniStat(Icons.local_fire_department, '${workout?.estimatedCalories ?? 0} kcal'),
                const SizedBox(width: 16),
                _miniStat(Icons.fitness_center, '${workout?.exercises.length ?? 0} ex'),
              ],
            ),
            const SizedBox(height: 16),
            if (workout != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/workout-detail', extra: workout),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Workout'),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1);
  }

  Widget _miniStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.pulseCyan),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _quickStats(BuildContext context, UserProfile user, double bmr, double tdee) {
    final bmi = Calculators.bmi(user.weightKg, user.heightCm);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statCard('BMI', bmi.toStringAsFixed(1), Calculators.bmiCategory(bmi), AppColors.pulseCyan, 0)),
          const SizedBox(width: 12),
          Expanded(child: _statCard('BMR', bmr.toInt().toString(), 'kcal/day', AppColors.neonCoral, 100)),
          const SizedBox(width: 12),
          Expanded(child: _statCard('TDEE', tdee.toInt().toString(), 'kcal/day', AppColors.auroraViolet, 200)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, String sub, Color color, int delayMs) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 300 + delayMs)).slideY(begin: 0.2);
  }

  Widget _planList(BuildContext context, WorkoutPlan? plan) {
    if (plan == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your AI Plan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(plan.workouts.length, (i) {
            final w = plan.workouts[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                onTap: () => context.push('/workout-detail', extra: w),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(colors: [
                          AppColors.pulseCyan.withOpacity(0.4),
                          AppColors.auroraViolet.withOpacity(0.4),
                        ]),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.fitness_center, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text('${w.exercises.length} ex • ${w.estimatedMinutes} min • ${w.estimatedCalories} kcal',
                              style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 400 + i * 80)).slideX(begin: 0.05);
          }),
        ],
      ),
    );
  }
}
