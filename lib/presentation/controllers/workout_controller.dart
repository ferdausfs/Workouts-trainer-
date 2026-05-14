import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/workout.dart';
import '../../core/services/ai_workout_generator.dart';
import 'user_controller.dart';

final activePlanProvider = Provider<WorkoutPlan?>((ref) {
  final user = ref.watch(userControllerProvider);
  if (user == null) return null;
  return AIWorkoutGenerator.generatePlan(user);
});

class WorkoutSessionState {
  final Workout workout;
  final int currentExerciseIndex;
  final int currentSet;
  final bool isResting;
  final bool isPaused;
  final int remainingRest;
  final int elapsedSeconds;

  const WorkoutSessionState({
    required this.workout,
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.isResting = false,
    this.isPaused = false,
    this.remainingRest = 0,
    this.elapsedSeconds = 0,
  });

  WorkoutSessionState copyWith({
    int? currentExerciseIndex,
    int? currentSet,
    bool? isResting,
    bool? isPaused,
    int? remainingRest,
    int? elapsedSeconds,
  }) {
    return WorkoutSessionState(
      workout: workout,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      isResting: isResting ?? this.isResting,
      isPaused: isPaused ?? this.isPaused,
      remainingRest: remainingRest ?? this.remainingRest,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}

class WorkoutSessionController extends StateNotifier<WorkoutSessionState?> {
  WorkoutSessionController() : super(null);

  void start(Workout w) {
    state = WorkoutSessionState(workout: w);
  }

  void nextSet() {
    final s = state;
    if (s == null) return;
    final ex = s.workout.exercises[s.currentExerciseIndex];
    if (s.currentSet < ex.sets) {
      state = s.copyWith(
        currentSet: s.currentSet + 1,
        isResting: true,
        remainingRest: ex.restSeconds,
      );
    } else {
      // Move to next exercise
      if (s.currentExerciseIndex < s.workout.exercises.length - 1) {
        state = s.copyWith(
          currentExerciseIndex: s.currentExerciseIndex + 1,
          currentSet: 1,
          isResting: true,
          remainingRest: ex.restSeconds,
        );
      } else {
        // Workout complete
        state = null;
      }
    }
  }

  void tickRest() {
    final s = state;
    if (s == null || !s.isResting || s.isPaused) return;
    if (s.remainingRest <= 1) {
      state = s.copyWith(isResting: false, remainingRest: 0);
    } else {
      state = s.copyWith(remainingRest: s.remainingRest - 1);
    }
  }

  void togglePause() {
    final s = state;
    if (s == null) return;
    state = s.copyWith(isPaused: !s.isPaused);
  }

  void cancel() {
    state = null;
  }
}

final workoutSessionProvider =
    StateNotifierProvider<WorkoutSessionController, WorkoutSessionState?>(
        (ref) => WorkoutSessionController());
