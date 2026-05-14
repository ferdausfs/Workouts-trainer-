import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/glass_card.dart';
import '../../controllers/onboarding_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  int _step = 0;
  final _nameCtrl = TextEditingController();

  static const _totalSteps = 8;

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _finish() async {
    final d = ref.read(onboardingControllerProvider);
    await ref.read(userControllerProvider.notifier).createFromOnboarding(
      name: _nameCtrl.text.trim().isEmpty ? 'Athlete' : _nameCtrl.text.trim(),
      age: d.age,
      weightKg: d.weightKg,
      heightCm: d.heightCm,
      gender: d.gender,
      level: d.level,
      goal: d.goal,
      location: d.location,
      activity: d.activity,
      injuries: d.injuries,
      equipment: d.equipment,
      weeklyWorkoutDays: d.weeklyWorkoutDays,
    );
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingControllerProvider);
    final progress = (_step + 1) / _totalSteps;

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    if (_step > 0)
                      IconButton(
                        onPressed: _back,
                        icon: const Icon(Icons.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation(AppColors.pulseCyan),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('${_step + 1}/$_totalSteps',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (c, a) => FadeTransition(
                    opacity: a,
                    child: SlideTransition(
                      position: Tween(begin: const Offset(0.05, 0), end: Offset.zero).animate(a),
                      child: c,
                    ),
                  ),
                  child: _buildStep(data),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: GradientButton(
                  label: _step == _totalSteps - 1 ? 'Build My Plan' : 'Continue',
                  icon: _step == _totalSteps - 1 ? Icons.auto_awesome : Icons.arrow_forward,
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(OnboardingData d) {
    switch (_step) {
      case 0: return _stepName(key: const ValueKey(0));
      case 1: return _stepGender(d, key: const ValueKey(1));
      case 2: return _stepAge(d, key: const ValueKey(2));
      case 3: return _stepBody(d, key: const ValueKey(3));
      case 4: return _stepGoal(d, key: const ValueKey(4));
      case 5: return _stepLevel(d, key: const ValueKey(5));
      case 6: return _stepLocation(d, key: const ValueKey(6));
      case 7: return _stepSchedule(d, key: const ValueKey(7));
      default: return const SizedBox.shrink();
    }
  }

  Widget _wrap({required Widget child, required Key key, required String title, String? subtitle}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700, height: 1.2,
              )).animate().fadeIn().slideY(begin: 0.2),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle,
                style: Theme.of(context).textTheme.bodyMedium)
                .animate().fadeIn(delay: 100.ms),
          ],
          const SizedBox(height: 32),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _stepName({required Key key}) {
    return _wrap(
      key: key,
      title: "What's your name?",
      subtitle: "We'll personalize your experience.",
      child: TextField(
        controller: _nameCtrl,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          hintText: 'Enter your name',
          prefixIcon: Icon(Icons.person_outline),
        ),
      ),
    );
  }

  Widget _stepGender(OnboardingData d, {required Key key}) {
    return _wrap(
      key: key,
      title: 'Select your gender',
      subtitle: 'Used for accurate calorie & macro calculations.',
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _choice('Male', Icons.male, d.gender == Gender.male,
              () => ref.read(onboardingControllerProvider.notifier).update((d) => d.gender = Gender.male)),
          _choice('Female', Icons.female, d.gender == Gender.female,
              () => ref.read(onboardingControllerProvider.notifier).update((d) => d.gender = Gender.female)),
        ],
      ),
    );
  }

  Widget _stepAge(OnboardingData d, {required Key key}) {
    return _wrap(
      key: key,
      title: 'How old are you?',
      subtitle: 'Used to estimate BMR.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${d.age}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 96, fontWeight: FontWeight.w800, color: AppColors.pulseCyan,
              )),
          const Text('years'),
          const SizedBox(height: 30),
          Slider(
            value: d.age.toDouble(),
            min: 14, max: 80, divisions: 66,
            label: '${d.age}',
            onChanged: (v) => ref.read(onboardingControllerProvider.notifier)
                .update((d) => d.age = v.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _stepBody(OnboardingData d, {required Key key}) {
    return _wrap(
      key: key,
      title: 'Body measurements',
      subtitle: 'Used to compute BMI and macros.',
      child: Column(
        children: [
          GlassCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Weight', style: TextStyle(fontSize: 16)),
                    Text('${d.weightKg.toStringAsFixed(1)} kg',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.pulseCyan)),
                  ],
                ),
                Slider(
                  value: d.weightKg, min: 35, max: 200, divisions: 165,
                  onChanged: (v) => ref.read(onboardingControllerProvider.notifier)
                      .update((d) => d.weightKg = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Height', style: TextStyle(fontSize: 16)),
                    Text('${d.heightCm.toStringAsFixed(0)} cm',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.pulseCyan)),
                  ],
                ),
                Slider(
                  value: d.heightCm, min: 130, max: 220, divisions: 90,
                  onChanged: (v) => ref.read(onboardingControllerProvider.notifier)
                      .update((d) => d.heightCm = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepGoal(OnboardingData d, {required Key key}) {
    return _wrap(
      key: key,
      title: 'Your main goal',
      subtitle: 'AI will optimize your plan accordingly.',
      child: ListView(
        children: [
          _goalTile('Lose Fat', 'Burn fat & get lean', Icons.local_fire_department, FitnessGoal.fatLoss, d),
          _goalTile('Build Muscle', 'Hypertrophy & strength', Icons.fitness_center, FitnessGoal.muscleGain, d),
          _goalTile('Maintain', 'Stay healthy & fit', Icons.favorite, FitnessGoal.maintenance, d),
          _goalTile('Endurance', 'Cardio & stamina', Icons.directions_run, FitnessGoal.endurance, d),
          _goalTile('Flexibility', 'Mobility & yoga', Icons.self_improvement, FitnessGoal.flexibility, d),
        ],
      ),
    );
  }

  Widget _stepLevel(OnboardingData d, {required Key key}) {
    return _wrap(
      key: key,
      title: 'Fitness level',
      subtitle: 'Choose your current ability.',
      child: ListView(
        children: [
          _levelTile('Beginner', 'New to fitness', FitnessLevel.beginner, d),
          _levelTile('Intermediate', '6+ months experience', FitnessLevel.intermediate, d),
          _levelTile('Advanced', '2+ years experience', FitnessLevel.advanced, d),
        ],
      ),
    );
  }

  Widget _stepLocation(OnboardingData d, {required Key key}) {
    return _wrap(
      key: key,
      title: 'Where will you train?',
      subtitle: 'We adapt exercises to your environment.',
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _choice('Home', Icons.home_rounded, d.location == WorkoutLocation.home,
              () => ref.read(onboardingControllerProvider.notifier).update((d) => d.location = WorkoutLocation.home)),
          _choice('Gym', Icons.fitness_center, d.location == WorkoutLocation.gym,
              () => ref.read(onboardingControllerProvider.notifier).update((d) => d.location = WorkoutLocation.gym)),
          _choice('Outdoor', Icons.park, d.location == WorkoutLocation.outdoor,
              () => ref.read(onboardingControllerProvider.notifier).update((d) => d.location = WorkoutLocation.outdoor)),
          _choice('Mixed', Icons.shuffle, d.location == WorkoutLocation.mixed,
              () => ref.read(onboardingControllerProvider.notifier).update((d) => d.location = WorkoutLocation.mixed)),
        ],
      ),
    );
  }

  Widget _stepSchedule(OnboardingData d, {required Key key}) {
    return _wrap(
      key: key,
      title: 'Days per week',
      subtitle: 'How many days can you commit?',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${d.weeklyWorkoutDays}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 120, fontWeight: FontWeight.w800, color: AppColors.pulseCyan,
                )),
            const Text('days / week'),
            const SizedBox(height: 30),
            Slider(
              value: d.weeklyWorkoutDays.toDouble(),
              min: 2, max: 7, divisions: 5,
              onChanged: (v) => ref.read(onboardingControllerProvider.notifier)
                  .update((d) => d.weeklyWorkoutDays = v.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choice(String label, IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected ? null : Colors.white.withOpacity(0.06),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.white24,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected ? [
            BoxShadow(color: AppColors.pulseCyan.withOpacity(0.4), blurRadius: 20),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: selected ? Colors.white : null),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600,
              color: selected ? Colors.white : null,
            )),
          ],
        ),
      ),
    );
  }

  Widget _goalTile(String title, String sub, IconData icon, FitnessGoal goal, OnboardingData d) {
    final selected = d.goal == goal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => ref.read(onboardingControllerProvider.notifier).update((d) => d.goal = goal),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryGradient : null,
            color: selected ? null : Colors.white.withOpacity(0.06),
            border: Border.all(color: selected ? Colors.transparent : Colors.white24),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(icon, size: 32, color: selected ? Colors.white : AppColors.pulseCyan),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : null,
                    )),
                    Text(sub, style: TextStyle(
                      fontSize: 13,
                      color: selected ? Colors.white70 : Colors.grey,
                    )),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelTile(String title, String sub, FitnessLevel lvl, OnboardingData d) {
    final selected = d.level == lvl;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => ref.read(onboardingControllerProvider.notifier).update((d) => d.level = lvl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryGradient : null,
            color: selected ? null : Colors.white.withOpacity(0.06),
            border: Border.all(color: selected ? Colors.transparent : Colors.white24),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : null,
                    )),
                    Text(sub, style: TextStyle(
                      fontSize: 13,
                      color: selected ? Colors.white70 : Colors.grey,
                    )),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
