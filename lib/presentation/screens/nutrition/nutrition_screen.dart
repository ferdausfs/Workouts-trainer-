import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/user_controller.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/calculators.dart';
import '../../../data/local/food_database.dart';
import '../../../domain/entities/nutrition.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen> {
  int _waterMl = 800;
  final List<MealEntry> _meals = [];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userControllerProvider);
    if (user == null) return const Center(child: CircularProgressIndicator());

    final bmr = Calculators.bmr(
      weightKg: user.weightKg, heightCm: user.heightCm,
      age: user.age, gender: user.gender.name,
    );
    final tdee = Calculators.tdee(bmr, user.activity.name);
    final calTarget = Calculators.calorieTarget(tdee,
      user.goal.name == 'fatLoss' ? 'fat_loss' : user.goal.name == 'muscleGain' ? 'muscle_gain' : 'maintenance');
    final macros = Calculators.macros(calTarget,
      user.goal.name == 'fatLoss' ? 'fat_loss' : user.goal.name == 'muscleGain' ? 'muscle_gain' : 'maintenance');

    final consumed = _meals.fold<double>(0, (s, m) => s + m.calories);
    final waterTarget = Calculators.dailyWaterMl(user.weightKg);

    return AnimatedGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            Text('Nutrition',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800))
                .animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 4),
            Text('Daily targets based on your AI plan', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            _calorieCard(consumed, calTarget).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),
            _macroRow(macros).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            _waterCard(waterTarget).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 24),
            Text('Quick Add', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _foodGrid(),
          ],
        ),
      ),
    );
  }

  Widget _calorieCard(double consumed, double target) {
    final pct = (consumed / target).clamp(0.0, 1.0);
    return GlassCard(
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 10,
            percent: pct,
            progressColor: AppColors.pulseCyan,
            backgroundColor: Colors.white12,
            circularStrokeCap: CircularStrokeCap.round,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(consumed.toInt().toString(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text('/ ${target.toInt()}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Calories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                const SizedBox(height: 6),
                Text('${(target - consumed).toInt()} kcal remaining',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(consumed < target * 0.3 ? '🌱 Stay focused' :
                     consumed < target * 0.7 ? '🔥 On track' :
                     consumed < target ? '⭐ Almost there' : '✅ Great job',
                     style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroRow(Map<String, double> macros) {
    return Row(
      children: [
        Expanded(child: _macroCard('Protein', macros['protein']!.toInt(), 'g', AppColors.neonCoral)),
        const SizedBox(width: 10),
        Expanded(child: _macroCard('Carbs', macros['carbs']!.toInt(), 'g', AppColors.pulseCyan)),
        const SizedBox(width: 10),
        Expanded(child: _macroCard('Fat', macros['fat']!.toInt(), 'g', AppColors.auroraViolet)),
      ],
    );
  }

  Widget _macroCard(String label, int value, String unit, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.circle, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          RichText(text: TextSpan(children: [
            TextSpan(text: '$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            TextSpan(text: unit, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ])),
        ],
      ),
    );
  }

  Widget _waterCard(double target) {
    final pct = (_waterMl / target).clamp(0.0, 1.0);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop, color: AppColors.info, size: 22),
              const SizedBox(width: 8),
              const Text('Water Intake', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
              const Spacer(),
              Text('$_waterMl / ${target.toInt()} ml',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: pct, minHeight: 12,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(AppColors.info),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final amount in [250, 500, 750])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _waterMl += amount),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.info.withOpacity(0.4)),
                      ),
                      child: Text('+$amount ml', style: const TextStyle(color: AppColors.info, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _foodGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: FoodDatabase.all.take(8).map((f) {
        return GlassCard(
          padding: const EdgeInsets.all(12),
          onTap: () {
            setState(() => _meals.add(MealEntry(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              food: f, grams: 100, mealType: 'meal', loggedAt: DateTime.now(),
            )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(gradient: AppColors.energyGradient, shape: BoxShape.circle),
                child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('${f.caloriesPer100g.toInt()} kcal /100g',
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
