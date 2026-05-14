enum MuscleGroup {
  chest, back, shoulders, biceps, triceps, forearms,
  abs, obliques, quads, hamstrings, glutes, calves,
  fullBody, cardio
}

enum Difficulty { beginner, intermediate, advanced }
enum Equipment {
  none, dumbbell, barbell, kettlebell, resistanceBand,
  pullUpBar, bench, cableMachine, smithMachine, treadmill, mat
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final List<MuscleGroup> primaryMuscles;
  final List<MuscleGroup> secondaryMuscles;
  final List<Equipment> equipment;
  final Difficulty difficulty;
  final String animationAsset; // lottie/rive asset key
  final String? videoUrl;
  final String? thumbnailUrl;
  final List<String> instructions;
  final List<String> commonMistakes;
  final List<String> safetyWarnings;
  final double mets; // metabolic equivalent
  final int defaultSets;
  final int defaultReps;
  final int restSeconds;
  final bool isTimed; // duration-based instead of reps

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryMuscles,
    this.secondaryMuscles = const [],
    this.equipment = const [Equipment.none],
    required this.difficulty,
    required this.animationAsset,
    this.videoUrl,
    this.thumbnailUrl,
    required this.instructions,
    this.commonMistakes = const [],
    this.safetyWarnings = const [],
    this.mets = 5.0,
    this.defaultSets = 3,
    this.defaultReps = 12,
    this.restSeconds = 60,
    this.isTimed = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'primaryMuscles': primaryMuscles.map((e) => e.name).toList(),
    'secondaryMuscles': secondaryMuscles.map((e) => e.name).toList(),
    'equipment': equipment.map((e) => e.name).toList(),
    'difficulty': difficulty.name,
    'animationAsset': animationAsset,
    'videoUrl': videoUrl,
    'thumbnailUrl': thumbnailUrl,
    'instructions': instructions,
    'commonMistakes': commonMistakes,
    'safetyWarnings': safetyWarnings,
    'mets': mets,
    'defaultSets': defaultSets,
    'defaultReps': defaultReps,
    'restSeconds': restSeconds,
    'isTimed': isTimed,
  };

  factory Exercise.fromJson(Map<String, dynamic> j) => Exercise(
    id: j['id'] as String,
    name: j['name'] as String,
    description: j['description'] as String,
    primaryMuscles: (j['primaryMuscles'] as List)
        .map((e) => MuscleGroup.values.firstWhere(
            (m) => m.name == e,
            orElse: () => MuscleGroup.fullBody)).toList(),
    secondaryMuscles: (j['secondaryMuscles'] as List? ?? [])
        .map((e) => MuscleGroup.values.firstWhere(
            (m) => m.name == e,
            orElse: () => MuscleGroup.fullBody)).toList(),
    equipment: (j['equipment'] as List? ?? [])
        .map((e) => Equipment.values.firstWhere(
            (eq) => eq.name == e,
            orElse: () => Equipment.none)).toList(),
    difficulty: Difficulty.values.firstWhere(
        (d) => d.name == j['difficulty'],
        orElse: () => Difficulty.beginner),
    animationAsset: j['animationAsset'] as String,
    videoUrl: j['videoUrl'] as String?,
    thumbnailUrl: j['thumbnailUrl'] as String?,
    instructions: List<String>.from(j['instructions'] ?? []),
    commonMistakes: List<String>.from(j['commonMistakes'] ?? []),
    safetyWarnings: List<String>.from(j['safetyWarnings'] ?? []),
    mets: (j['mets'] as num? ?? 5.0).toDouble(),
    defaultSets: j['defaultSets'] ?? 3,
    defaultReps: j['defaultReps'] ?? 12,
    restSeconds: j['restSeconds'] ?? 60,
    isTimed: j['isTimed'] ?? false,
  );
}
