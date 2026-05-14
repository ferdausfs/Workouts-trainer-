import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user_profile.dart';
import '../../core/services/local_storage_service.dart';

class UserController extends StateNotifier<UserProfile?> {
  UserController() : super(_load());

  static UserProfile? _load() {
    final json = LocalStorageService.userBox.get('profile');
    if (json == null) return null;
    try {
      return UserProfile.fromJson(Map<String, dynamic>.from(json as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> save(UserProfile profile) async {
    state = profile;
    await LocalStorageService.userBox.put('profile', profile.toJson());
  }

  Future<void> update({
    String? name,
    double? weightKg,
    double? heightCm,
    int? age,
    Gender? gender,
    FitnessLevel? level,
    FitnessGoal? goal,
    WorkoutLocation? location,
    ActivityLevel? activity,
    List<String>? injuries,
    List<String>? equipment,
    int? weeklyWorkoutDays,
  }) async {
    if (state == null) return;
    final updated = state!.copyWith(
      name: name, weightKg: weightKg, heightCm: heightCm, age: age,
      gender: gender, level: level, goal: goal, location: location,
      activity: activity, injuries: injuries, equipment: equipment,
      weeklyWorkoutDays: weeklyWorkoutDays,
    );
    await save(updated);
  }

  Future<void> createFromOnboarding({
    required String name,
    required int age,
    required double weightKg,
    required double heightCm,
    required Gender gender,
    required FitnessLevel level,
    required FitnessGoal goal,
    required WorkoutLocation location,
    required ActivityLevel activity,
    List<String> injuries = const [],
    List<String> equipment = const [],
    int weeklyWorkoutDays = 4,
  }) async {
    final profile = UserProfile(
      id: const Uuid().v4(),
      name: name,
      age: age,
      weightKg: weightKg,
      heightCm: heightCm,
      gender: gender,
      level: level,
      goal: goal,
      location: location,
      activity: activity,
      injuries: injuries,
      equipment: equipment,
      weeklyWorkoutDays: weeklyWorkoutDays,
      createdAt: DateTime.now(),
    );
    await save(profile);
    await LocalStorageService.setOnboardingComplete(true);
  }

  Future<void> logout() async {
    state = null;
    await LocalStorageService.userBox.clear();
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, UserProfile?>((ref) => UserController());
