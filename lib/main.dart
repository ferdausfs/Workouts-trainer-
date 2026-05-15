import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const PulseFitRebuiltApp());
}

class PulseFitRebuiltApp extends StatefulWidget {
  const PulseFitRebuiltApp({super.key});

  @override
  State<PulseFitRebuiltApp> createState() => _PulseFitRebuiltAppState();
}

class _PulseFitRebuiltAppState extends State<PulseFitRebuiltApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF));
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C63FF),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PulseFit AI',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: const Color(0xFF10131A),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: DashboardShell(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  late Future<AppData> _dataFuture;
  int _currentIndex = 0;
  FitnessGoal _selectedGoal = FitnessGoal.fatLoss;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadDashboardData();
  }

  Future<AppData> _loadDashboardData() async {
    final exercisesRaw = await rootBundle.loadString('assets/data/exercises.json');
    final foodsRaw = await rootBundle.loadString('assets/data/foods.json');

    final exercisesJson = jsonDecode(exercisesRaw) as Map<String, dynamic>;
    final foodsJson = jsonDecode(foodsRaw) as Map<String, dynamic>;

    final exercises = (exercisesJson['exercises'] as List<dynamic>? ?? const [])
        .map((item) => Exercise.fromJson(item as Map<String, dynamic>))
        .toList();

    final foods = (foodsJson['foods'] as List<dynamic>? ?? const [])
        .map((item) => FoodItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return AppData(exercises: exercises, foods: foods);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LoadingScaffold();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _ErrorScaffold(
            message: 'App data load korte problem hocche. ZIP rebuild er poro asset read kora jacche na.',
            onRetry: () {
              setState(() {
                _dataFuture = _loadDashboardData();
              });
            },
          );
        }

        final data = snapshot.data!;
        final screens = [
          OverviewScreen(data: data, goal: _selectedGoal),
          WorkoutsScreen(exercises: data.exercises),
          NutritionScreen(foods: data.foods),
          ProgressScreen(exercises: data.exercises),
          CoachScreen(
            exercises: data.exercises,
            goal: _selectedGoal,
            onGoalChanged: (goal) {
              setState(() {
                _selectedGoal = goal;
              });
            },
          ),
          SettingsScreen(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('PulseFit AI'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    FitnessGoalX.label(_selectedGoal),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: IndexedStack(
                key: ValueKey(_currentIndex),
                index: _currentIndex,
                children: screens,
              ),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.fitness_center_outlined), label: 'Workout'),
              NavigationDestination(icon: Icon(Icons.restaurant_menu_outlined), label: 'Nutrition'),
              NavigationDestination(icon: Icon(Icons.show_chart_outlined), label: 'Progress'),
              NavigationDestination(icon: Icon(Icons.smart_toy_outlined), label: 'Coach'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key, required this.data, required this.goal});

  final AppData data;
  final FitnessGoal goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final averageMets = data.exercises.isEmpty
        ? 0.0
        : data.exercises.fold<double>(0, (sum, item) => sum + item.mets) / data.exercises.length;
    final beginnerCount = data.exercises.where((item) => item.difficulty == 'beginner').length;
    final proteinFoods = data.foods.where((item) => item.category == 'protein').length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/splash_logo.png',
                    height: 56,
                    errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, size: 42, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rebuilt & Optimized Fitness App',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Clean Flutter-only architecture, faster startup, simpler maintenance.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _StatChip(label: 'Exercises', value: '${data.exercises.length}'),
                  _StatChip(label: 'Avg METS', value: averageMets.toStringAsFixed(1)),
                  _StatChip(label: 'Beginner', value: '$beginnerCount'),
                  _StatChip(label: 'Protein Foods', value: '$proteinFoods'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Today\'s focus', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ..._buildTodayPlan(goal).map(
          (item) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(item.step.toString())),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
            ),
          ),
        ),
      ],
    );
  }
}

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => ExerciseBottomSheet(exercise: exercise),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          exercise.name,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      _DifficultyBadge(level: exercise.difficulty),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoPill(icon: Icons.repeat, label: exercise.volumeLabel),
                      _InfoPill(icon: Icons.bolt, label: '${exercise.mets.toStringAsFixed(1)} METS'),
                      _InfoPill(icon: Icons.sports_gymnastics, label: exercise.primaryMusclesLabel),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    exercise.instructions.isEmpty
                        ? 'Tap kore detail dekhun.'
                        : exercise.instructions.first,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: exercises.length,
    );
  }
}

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key, required this.foods});

  final List<FoodItem> foods;

  @override
  Widget build(BuildContext context) {
    final totalProtein = foods.fold<double>(0, (sum, item) => sum + item.proteinPer100g);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nutrition snapshot',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text('Loaded foods: ${foods.length}  •  Total protein density: ${totalProtein.toStringAsFixed(1)} g'),
                const SizedBox(height: 12),
                const Text('Recommended plate ratio: 40% protein • 35% smart carbs • 25% vegetables & healthy fats'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...foods.map(
          (food) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(food.name.isEmpty ? '?' : food.name.substring(0, 1).toUpperCase())),
              title: Text(food.name),
              subtitle: Text(
                '${food.category.toUpperCase()} • ${food.caloriesPer100g.toStringAsFixed(0)} kcal / 100g\n'
                'P ${food.proteinPer100g.toStringAsFixed(1)}g • C ${food.carbsPer100g.toStringAsFixed(1)}g • F ${food.fatPer100g.toStringAsFixed(1)}g',
              ),
              isThreeLine: true,
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  Widget build(BuildContext context) {
    final progress = _demoProgress(exercises.length);
    final completion = progress.fold<double>(0, (sum, item) => sum + item.completion) / progress.length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly consistency',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: completion),
                const SizedBox(height: 8),
                Text('Average completion ${(completion * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...progress.map(
          (item) => Card(
            child: ListTile(
              title: Text(item.label),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: item.completion),
                  const SizedBox(height: 6),
                  Text('${item.completedSessions}/${item.targetSessions} sessions complete'),
                ],
              ),
              trailing: Text('${(item.completion * 100).toStringAsFixed(0)}%'),
            ),
          ),
        ),
      ],
    );
  }
}

class CoachScreen extends StatelessWidget {
  const CoachScreen({
    super.key,
    required this.exercises,
    required this.goal,
    required this.onGoalChanged,
  });

  final List<Exercise> exercises;
  final FitnessGoal goal;
  final ValueChanged<FitnessGoal> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final recommendations = _buildCoachTips(goal, exercises);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goal-based AI coach (offline edition)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<FitnessGoal>(
                  value: goal,
                  decoration: const InputDecoration(
                    labelText: 'Primary goal',
                    border: OutlineInputBorder(),
                  ),
                  items: FitnessGoal.values
                      .map(
                        (item) => DropdownMenuItem<FitnessGoal>(
                          value: item,
                          child: Text(FitnessGoalX.label(item)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onGoalChanged(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...recommendations.map(
          (tip) => Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: Text(tip.title),
              subtitle: Text(tip.subtitle),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Simplified theme toggle for faster maintenance'),
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.offline_bolt),
            title: Text('Offline-first rebuild'),
            subtitle: Text('Firebase-heavy startup dependency remove kora hoyeche.'),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.speed_outlined),
            title: Text('Optimization notes'),
            subtitle: Text('Dependencies komano hoyeche, startup path clean kora hoyeche, navigation lightweight. '),
          ),
        ),
      ],
    );
  }
}

class ExerciseBottomSheet extends StatelessWidget {
  const ExerciseBottomSheet({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final instructions = exercise.instructions.isEmpty
        ? const ['Warm up 3-5 min', 'Maintain proper form', 'Recover with slow breathing']
        : exercise.instructions;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(icon: Icons.repeat, label: exercise.volumeLabel),
                _InfoPill(icon: Icons.sports_gymnastics, label: exercise.primaryMusclesLabel),
                _InfoPill(icon: Icons.handyman_outlined, label: exercise.equipmentLabel),
              ],
            ),
            const SizedBox(height: 16),
            Text('Instructions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...instructions.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 56),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    final color = switch (level.toLowerCase()) {
      'beginner' => Colors.green,
      'intermediate' => Colors.orange,
      'advanced' => Colors.red,
      _ => Colors.blueGrey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class AppData {
  const AppData({required this.exercises, required this.foods});

  final List<Exercise> exercises;
  final List<FoodItem> foods;
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.equipment,
    required this.difficulty,
    required this.mets,
    required this.defaultSets,
    required this.defaultReps,
    required this.isTimed,
    required this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    List<String> readStringList(dynamic value) => (value as List<dynamic>? ?? const []).map((item) => item.toString()).toList();

    return Exercise(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown exercise',
      primaryMuscles: readStringList(json['primaryMuscles']),
      secondaryMuscles: readStringList(json['secondaryMuscles']),
      equipment: readStringList(json['equipment']),
      difficulty: json['difficulty']?.toString() ?? 'beginner',
      mets: (json['mets'] as num?)?.toDouble() ?? 5.0,
      defaultSets: (json['defaultSets'] as num?)?.toInt() ?? 3,
      defaultReps: (json['defaultReps'] as num?)?.toInt() ?? 12,
      isTimed: json['isTimed'] as bool? ?? false,
      instructions: readStringList(json['instructions']),
    );
  }

  final String id;
  final String name;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> equipment;
  final String difficulty;
  final double mets;
  final int defaultSets;
  final int defaultReps;
  final bool isTimed;
  final List<String> instructions;

  String get volumeLabel => isTimed ? '${defaultReps}s hold' : '$defaultSets x $defaultReps reps';
  String get primaryMusclesLabel => primaryMuscles.isEmpty ? 'Full body' : primaryMuscles.join(', ');
  String get equipmentLabel => equipment.isEmpty ? 'No equipment' : equipment.join(', ');
}

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.category,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    double readNum(String key) => (json[key] as num?)?.toDouble() ?? 0;

    return FoodItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown food',
      caloriesPer100g: readNum('caloriesPer100g'),
      proteinPer100g: readNum('proteinPer100g'),
      carbsPer100g: readNum('carbsPer100g'),
      fatPer100g: readNum('fatPer100g'),
      category: json['category']?.toString() ?? 'general',
    );
  }

  final String id;
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final String category;
}

class ProgressSnapshot {
  const ProgressSnapshot({
    required this.label,
    required this.completedSessions,
    required this.targetSessions,
  });

  final String label;
  final int completedSessions;
  final int targetSessions;

  double get completion => targetSessions == 0 ? 0 : completedSessions / targetSessions;
}

class CoachTip {
  const CoachTip({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

class PlanItem {
  const PlanItem({required this.step, required this.title, required this.subtitle});

  final int step;
  final String title;
  final String subtitle;
}

enum FitnessGoal { fatLoss, muscleGain, endurance, consistency }

extension FitnessGoalX on FitnessGoal {
  static String label(FitnessGoal goal) => switch (goal) {
        FitnessGoal.fatLoss => 'Fat loss',
        FitnessGoal.muscleGain => 'Muscle gain',
        FitnessGoal.endurance => 'Endurance',
        FitnessGoal.consistency => 'Consistency',
      };
}

List<PlanItem> _buildTodayPlan(FitnessGoal goal) {
  return switch (goal) {
    FitnessGoal.fatLoss => const [
        PlanItem(step: 1, title: 'Warm-up walk', subtitle: '8 min brisk walk + mobility'),
        PlanItem(step: 2, title: 'Circuit block', subtitle: 'Push-up, squat, plank, burpee × 3 rounds'),
        PlanItem(step: 3, title: 'High-protein dinner', subtitle: 'Chicken + rice + broccoli target 35g protein'),
      ],
    FitnessGoal.muscleGain => const [
        PlanItem(step: 1, title: 'Activation', subtitle: 'Shoulder, hip and core prep for 6 min'),
        PlanItem(step: 2, title: 'Strength block', subtitle: 'Pull-up, squat and push-up progressive overload'),
        PlanItem(step: 3, title: 'Recovery meal', subtitle: 'Protein + complex carbs within 60 min'),
      ],
    FitnessGoal.endurance => const [
        PlanItem(step: 1, title: 'Breathing prep', subtitle: 'Box breathing 3 min and dynamic warm-up'),
        PlanItem(step: 2, title: 'Timed block', subtitle: 'Plank holds + burpees + short rest intervals'),
        PlanItem(step: 3, title: 'Hydration', subtitle: 'Electrolytes + balanced carbs through the day'),
      ],
    FitnessGoal.consistency => const [
        PlanItem(step: 1, title: 'Small habit', subtitle: 'Start with 10-15 min only'),
        PlanItem(step: 2, title: '2 priority moves', subtitle: 'Pick squat and plank for today'),
        PlanItem(step: 3, title: 'Log your win', subtitle: 'Check off the session and sleep on time'),
      ],
  };
}

List<ProgressSnapshot> _demoProgress(int exerciseCount) {
  final target = exerciseCount < 4 ? 4 : 5;
  return [
    ProgressSnapshot(label: 'Week 1', completedSessions: 3, targetSessions: target),
    ProgressSnapshot(label: 'Week 2', completedSessions: 4, targetSessions: target),
    ProgressSnapshot(label: 'Week 3', completedSessions: 4, targetSessions: target),
    ProgressSnapshot(label: 'Week 4', completedSessions: 5, targetSessions: target),
  ];
}

List<CoachTip> _buildCoachTips(FitnessGoal goal, List<Exercise> exercises) {
  final beginner = exercises.where((item) => item.difficulty == 'beginner').map((item) => item.name).take(3).join(', ');
  final advanced = exercises.where((item) => item.difficulty == 'advanced').map((item) => item.name).take(2).join(', ');

  return switch (goal) {
    FitnessGoal.fatLoss => [
        CoachTip(title: 'Calorie-aware plan', subtitle: 'Use moderate intensity 4 days/week and prioritize $beginner.'),
        const CoachTip(title: 'Keep rest short', subtitle: 'Target 30-45 sec rest during circuits to keep heart rate up.'),
        const CoachTip(title: 'Protein anchor', subtitle: 'Aim for protein in every main meal to support recovery.'),
      ],
    FitnessGoal.muscleGain => [
        CoachTip(title: 'Progressive overload', subtitle: 'Track reps or tempo weekly on $advanced.'),
        const CoachTip(title: 'Recovery priority', subtitle: 'Keep 1-2 rest days and sleep 7-8 hours for best growth.'),
        const CoachTip(title: 'Fuel correctly', subtitle: 'Add a carb source before training and protein after training.'),
      ],
    FitnessGoal.endurance => [
        const CoachTip(title: 'Timed sets', subtitle: 'Use plank and burpee intervals to improve work capacity.'),
        const CoachTip(title: 'Breathing control', subtitle: 'Nasal breathing on warm-up and cooldown improves pacing.'),
        const CoachTip(title: 'Volume ramp', subtitle: 'Increase weekly workload by about 10%, not all at once.'),
      ],
    FitnessGoal.consistency => [
        const CoachTip(title: 'Reduce friction', subtitle: 'Keep workouts short enough that missing feels harder than doing.'),
        const CoachTip(title: 'Anchor habit', subtitle: 'Train right after the same daily trigger like breakfast or work.'),
        const CoachTip(title: 'Score streaks', subtitle: 'Focus on 3 sessions weekly before chasing intensity.'),
      ],
  };
}
