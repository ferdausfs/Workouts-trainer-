enum Gender { male, female, other }
enum FitnessLevel { beginner, intermediate, advanced }
enum FitnessGoal { fatLoss, muscleGain, maintenance, endurance, flexibility }
enum WorkoutLocation { home, gym, outdoor, mixed }
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

class UserProfile {
  final String id;
  final String name;
  final String? email;
  final int age;
  final double weightKg;
  final double heightCm;
  final Gender gender;
  final FitnessLevel level;
  final FitnessGoal goal;
  final WorkoutLocation location;
  final ActivityLevel activity;
  final List<String> injuries;
  final List<String> equipment;
  final int weeklyWorkoutDays;
  final String? photoUrl;
  final DateTime createdAt;
  final bool isPremium;

  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.gender,
    required this.level,
    required this.goal,
    required this.location,
    required this.activity,
    this.injuries = const [],
    this.equipment = const [],
    this.weeklyWorkoutDays = 4,
    this.photoUrl,
    required this.createdAt,
    this.isPremium = false,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    double? weightKg,
    double? heightCm,
    Gender? gender,
    FitnessLevel? level,
    FitnessGoal? goal,
    WorkoutLocation? location,
    ActivityLevel? activity,
    List<String>? injuries,
    List<String>? equipment,
    int? weeklyWorkoutDays,
    String? photoUrl,
    DateTime? createdAt,
    bool? isPremium,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      goal: goal ?? this.goal,
      location: location ?? this.location,
      activity: activity ?? this.activity,
      injuries: injuries ?? this.injuries,
      equipment: equipment ?? this.equipment,
      weeklyWorkoutDays: weeklyWorkoutDays ?? this.weeklyWorkoutDays,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'age': age,
    'weightKg': weightKg,
    'heightCm': heightCm,
    'gender': gender.name,
    'level': level.name,
    'goal': goal.name,
    'location': location.name,
    'activity': activity.name,
    'injuries': injuries,
    'equipment': equipment,
    'weeklyWorkoutDays': weeklyWorkoutDays,
    'photoUrl': photoUrl,
    'createdAt': createdAt.toIso8601String(),
    'isPremium': isPremium,
  };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    id: j['id'] as String,
    name: j['name'] as String,
    email: j['email'] as String?,
    age: j['age'] as int,
    weightKg: (j['weightKg'] as num).toDouble(),
    heightCm: (j['heightCm'] as num).toDouble(),
    gender: Gender.values.firstWhere((e) => e.name == j['gender'], orElse: () => Gender.male),
    level: FitnessLevel.values.firstWhere((e) => e.name == j['level'], orElse: () => FitnessLevel.beginner),
    goal: FitnessGoal.values.firstWhere((e) => e.name == j['goal'], orElse: () => FitnessGoal.fatLoss),
    location: WorkoutLocation.values.firstWhere((e) => e.name == j['location'], orElse: () => WorkoutLocation.home),
    activity: ActivityLevel.values.firstWhere((e) => e.name == j['activity'], orElse: () => ActivityLevel.moderate),
    injuries: List<String>.from(j['injuries'] ?? []),
    equipment: List<String>.from(j['equipment'] ?? []),
    weeklyWorkoutDays: j['weeklyWorkoutDays'] ?? 4,
    photoUrl: j['photoUrl'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String),
    isPremium: j['isPremium'] ?? false,
  );
}
