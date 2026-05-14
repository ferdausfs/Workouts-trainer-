import 'exercise.dart';

class WorkoutExercise {
  final Exercise exercise;
  final int sets;
  final int reps;
  final int restSeconds;
  final int? durationSeconds;
  final double? weightKg;

  const WorkoutExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.durationSeconds,
    this.weightKg,
  });

  Map<String, dynamic> toJson() => {
    'exercise': exercise.toJson(),
    'sets': sets,
    'reps': reps,
    'restSeconds': restSeconds,
    'durationSeconds': durationSeconds,
    'weightKg': weightKg,
  };

  factory WorkoutExercise.fromJson(Map<String, dynamic> j) => WorkoutExercise(
    exercise: Exercise.fromJson(j['exercise']),
    sets: j['sets'],
    reps: j['reps'],
    restSeconds: j['restSeconds'],
    durationSeconds: j['durationSeconds'],
    weightKg: (j['weightKg'] as num?)?.toDouble(),
  );
}

class Workout {
  final String id;
  final String name;
  final String description;
  final List<WorkoutExercise> exercises;
  final int estimatedMinutes;
  final int estimatedCalories;
  final String category; // 'fat_loss' | 'muscle_gain' | 'endurance' | 'flexibility'
  final String difficulty;
  final String? coverImage;

  const Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
    required this.estimatedMinutes,
    required this.estimatedCalories,
    required this.category,
    required this.difficulty,
    this.coverImage,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'estimatedMinutes': estimatedMinutes,
    'estimatedCalories': estimatedCalories,
    'category': category,
    'difficulty': difficulty,
    'coverImage': coverImage,
  };

  factory Workout.fromJson(Map<String, dynamic> j) => Workout(
    id: j['id'],
    name: j['name'],
    description: j['description'],
    exercises: (j['exercises'] as List)
        .map((e) => WorkoutExercise.fromJson(e)).toList(),
    estimatedMinutes: j['estimatedMinutes'],
    estimatedCalories: j['estimatedCalories'],
    category: j['category'],
    difficulty: j['difficulty'],
    coverImage: j['coverImage'],
  );
}

class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final int durationWeeks;
  final List<Workout> workouts; // organized per day
  final DateTime createdAt;

  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.durationWeeks,
    required this.workouts,
    required this.createdAt,
  });
}

class WorkoutSession {
  final String id;
  final String workoutId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int caloriesBurned;
  final int durationSeconds;
  final List<String> completedExerciseIds;

  const WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.startedAt,
    this.completedAt,
    required this.caloriesBurned,
    required this.durationSeconds,
    this.completedExerciseIds = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'workoutId': workoutId,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'caloriesBurned': caloriesBurned,
    'durationSeconds': durationSeconds,
    'completedExerciseIds': completedExerciseIds,
  };

  factory WorkoutSession.fromJson(Map<String, dynamic> j) => WorkoutSession(
    id: j['id'],
    workoutId: j['workoutId'],
    startedAt: DateTime.parse(j['startedAt']),
    completedAt: j['completedAt'] != null ? DateTime.parse(j['completedAt']) : null,
    caloriesBurned: j['caloriesBurned'],
    durationSeconds: j['durationSeconds'],
    completedExerciseIds: List<String>.from(j['completedExerciseIds'] ?? []),
  );
}
