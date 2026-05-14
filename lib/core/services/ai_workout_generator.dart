import '../../domain/entities/user_profile.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';
import '../../data/local/exercise_database.dart';
import 'package:uuid/uuid.dart';

/// Rule-based AI workout plan generator.
/// Produces personalized plans based on user goal, level, location, and equipment.
class AIWorkoutGenerator {
  static const _uuid = Uuid();

  static WorkoutPlan generatePlan(UserProfile user) {
    final allExercises = ExerciseDatabase.all;

    // Filter by user constraints
    final available = allExercises.where((e) {
      // Match location/equipment
      if (user.location == WorkoutLocation.home) {
        final ok = e.equipment.every((eq) =>
          eq == Equipment.none ||
          eq == Equipment.dumbbell ||
          eq == Equipment.resistanceBand ||
          eq == Equipment.mat ||
          eq == Equipment.pullUpBar);
        if (!ok) return false;
      }
      // Match difficulty
      if (user.level == FitnessLevel.beginner &&
          e.difficulty == Difficulty.advanced) return false;
      return true;
    }).toList();

    final weeklyDays = user.weeklyWorkoutDays;
    final workouts = <Workout>[];

    // Split structure based on goal
    final split = _buildSplit(user.goal, weeklyDays);

    for (var i = 0; i < split.length; i++) {
      final dayFocus = split[i];
      workouts.add(_buildDayWorkout(
        dayIndex: i,
        focusMuscles: dayFocus.muscles,
        focusName: dayFocus.name,
        user: user,
        pool: available,
      ));
    }

    final goalName = switch (user.goal) {
      FitnessGoal.fatLoss => 'Fat Burn Accelerator',
      FitnessGoal.muscleGain => 'Hypertrophy Pro',
      FitnessGoal.endurance => 'Endurance Builder',
      FitnessGoal.flexibility => 'Mobility & Flow',
      _ => 'Total Body Maintenance',
    };

    return WorkoutPlan(
      id: _uuid.v4(),
      name: '$goalName • ${user.level.name.toUpperCase()}',
      description: 'AI-personalized ${user.weeklyWorkoutDays}-day plan tailored to your goal, '
          'experience level, and available equipment.',
      durationWeeks: 8,
      workouts: workouts,
      createdAt: DateTime.now(),
    );
  }

  static List<_DayFocus> _buildSplit(FitnessGoal goal, int days) {
    if (goal == FitnessGoal.fatLoss) {
      // HIIT + full body mix
      const focuses = [
        _DayFocus('HIIT Cardio Burn', [MuscleGroup.cardio, MuscleGroup.fullBody]),
        _DayFocus('Upper Body Sculpt', [MuscleGroup.chest, MuscleGroup.back, MuscleGroup.shoulders]),
        _DayFocus('Core Crusher', [MuscleGroup.abs, MuscleGroup.obliques]),
        _DayFocus('Lower Body Burn', [MuscleGroup.quads, MuscleGroup.glutes, MuscleGroup.hamstrings]),
        _DayFocus('Full Body Cardio', [MuscleGroup.fullBody, MuscleGroup.cardio]),
        _DayFocus('Active Recovery', [MuscleGroup.fullBody]),
        _DayFocus('Power Endurance', [MuscleGroup.cardio, MuscleGroup.fullBody]),
      ];
      return focuses.take(days).toList();
    }

    if (goal == FitnessGoal.muscleGain) {
      const focuses = [
        _DayFocus('Chest & Triceps', [MuscleGroup.chest, MuscleGroup.triceps]),
        _DayFocus('Back & Biceps', [MuscleGroup.back, MuscleGroup.biceps]),
        _DayFocus('Shoulders & Core', [MuscleGroup.shoulders, MuscleGroup.abs]),
        _DayFocus('Legs Power', [MuscleGroup.quads, MuscleGroup.hamstrings, MuscleGroup.glutes]),
        _DayFocus('Arms Volume', [MuscleGroup.biceps, MuscleGroup.triceps, MuscleGroup.forearms]),
        _DayFocus('Push Day', [MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.triceps]),
        _DayFocus('Pull Day', [MuscleGroup.back, MuscleGroup.biceps]),
      ];
      return focuses.take(days).toList();
    }

    // Maintenance/general
    const general = [
      _DayFocus('Upper Body', [MuscleGroup.chest, MuscleGroup.back, MuscleGroup.shoulders]),
      _DayFocus('Lower Body', [MuscleGroup.quads, MuscleGroup.glutes, MuscleGroup.hamstrings]),
      _DayFocus('Core & Cardio', [MuscleGroup.abs, MuscleGroup.cardio]),
      _DayFocus('Full Body', [MuscleGroup.fullBody]),
      _DayFocus('Mobility', [MuscleGroup.fullBody]),
      _DayFocus('Strength', [MuscleGroup.fullBody]),
      _DayFocus('Active Recovery', [MuscleGroup.fullBody]),
    ];
    return general.take(days).toList();
  }

  static Workout _buildDayWorkout({
    required int dayIndex,
    required List<MuscleGroup> focusMuscles,
    required String focusName,
    required UserProfile user,
    required List<Exercise> pool,
  }) {
    // Pick 5-7 exercises that hit focus muscles
    final candidates = pool.where((e) =>
      e.primaryMuscles.any((m) => focusMuscles.contains(m)) ||
      e.secondaryMuscles.any((m) => focusMuscles.contains(m))
    ).toList();

    candidates.shuffle();
    final picked = candidates.take(user.level == FitnessLevel.beginner ? 5 : 7).toList();

    // Convert to WorkoutExercise with rep/set scheme based on goal
    final wExercises = picked.map((ex) {
      int sets, reps, rest;
      switch (user.goal) {
        case FitnessGoal.fatLoss:
          sets = 3; reps = 15; rest = 30;
          break;
        case FitnessGoal.muscleGain:
          sets = 4; reps = 10; rest = 75;
          break;
        case FitnessGoal.endurance:
          sets = 3; reps = 20; rest = 30;
          break;
        default:
          sets = 3; reps = 12; rest = 45;
      }
      if (user.level == FitnessLevel.beginner) sets = (sets - 1).clamp(2, 5);
      return WorkoutExercise(
        exercise: ex,
        sets: sets,
        reps: reps,
        restSeconds: rest,
        durationSeconds: ex.isTimed ? 40 : null,
      );
    }).toList();

    // Estimate duration & calories
    final estMin = wExercises.fold<int>(0, (sum, w) =>
      sum + (w.sets * ((w.durationSeconds ?? 30) + w.restSeconds)) ~/ 60);
    final estKcal = (estMin * user.weightKg * 0.08).round();

    return Workout(
      id: _uuid.v4(),
      name: 'Day ${dayIndex + 1} • $focusName',
      description: 'Focused session targeting ${focusMuscles.map((m) => m.name).join(", ")}.',
      exercises: wExercises,
      estimatedMinutes: estMin.clamp(20, 90),
      estimatedCalories: estKcal,
      category: user.goal.name,
      difficulty: user.level.name,
    );
  }
}

class _DayFocus {
  final String name;
  final List<MuscleGroup> muscles;
  const _DayFocus(this.name, this.muscles);
}
