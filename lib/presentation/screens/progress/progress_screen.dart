import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/user_controller.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider);
    if (user == null) return const Center(child: CircularProgressIndicator());

    return AnimatedGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            Text('Progress',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800))
                .animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _streakCard().animate().fadeIn(delay: 100.ms)),
                const SizedBox(width: 12),
                Expanded(child: _kcalCard().animate().fadeIn(delay: 200.ms)),
              ],
            ),
            const SizedBox(height: 16),
            Text('Weight Trend (kg)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            GlassCard(
              child: SizedBox(height: 200, child: _weightChart(user.weightKg)),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 20),
            Text('Weekly Activity',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            GlassCard(
              child: SizedBox(height: 200, child: _activityChart()),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 20),
            Text('Achievements',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            _achievements().animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _streakCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_fire_department, color: AppColors.neonCoral, size: 28),
          const SizedBox(height: 8),
          const Text('7', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const Text('Day Streak', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _kcalCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bolt, color: AppColors.pulseCyan, size: 28),
          const SizedBox(height: 8),
          const Text('3,420', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const Text('kcal burned this week', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _weightChart(double current) {
    final data = [
      current + 2.5, current + 2.1, current + 1.6, current + 1.0,
      current + 0.6, current + 0.3, current,
    ];
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true,
          getDrawingHorizontalLine: (_) => FlLine(color: Colors.white.withOpacity(0.08), strokeWidth: 1),
          drawVerticalLine: false,
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
            isCurved: true,
            gradient: AppColors.primaryGradient,
            barWidth: 4,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [AppColors.pulseCyan.withOpacity(0.3), AppColors.pulseCyan.withOpacity(0)],
            )),
          ),
        ],
      ),
    );
  }

  Widget _activityChart() {
    final values = [40, 55, 30, 70, 60, 85, 50];
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) => Text(days[v.toInt()],
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          )),
        ),
        barGroups: List.generate(values.length, (i) => BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(
            toY: values[i].toDouble(),
            gradient: AppColors.primaryGradient,
            width: 18,
            borderRadius: BorderRadius.circular(8),
          )],
        )),
      ),
    );
  }

  Widget _achievements() {
    final list = [
      ('First Workout', Icons.celebration, AppColors.pulseCyan, true),
      ('7-Day Streak', Icons.local_fire_department, AppColors.neonCoral, true),
      ('1000 kcal', Icons.bolt, AppColors.warning, true),
      ('30 Workouts', Icons.fitness_center, AppColors.auroraViolet, false),
      ('Marathon', Icons.directions_run, Colors.grey, false),
      ('Strong Bones', Icons.shield, Colors.grey, false),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: list.map((a) {
        return GlassCard(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: a.$4 ? LinearGradient(colors: [a.$3, a.$3.withOpacity(0.5)]) : null,
                  color: a.$4 ? null : Colors.grey.withOpacity(0.2),
                ),
                child: Icon(a.$2, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 8),
              Text(a.$1, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: a.$4 ? null : Colors.grey)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
