import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';

class OnboardingData {
  String name;
  int age;
  double weightKg;
  double heightCm;
  Gender gender;
  FitnessLevel level;
  FitnessGoal goal;
  WorkoutLocation location;
  ActivityLevel activity;
  List<String> injuries;
  List<String> equipment;
  int weeklyWorkoutDays;

  OnboardingData({
    this.name = '',
    this.age = 25,
    this.weightKg = 70,
    this.heightCm = 175,
    this.gender = Gender.male,
    this.level = FitnessLevel.beginner,
    this.goal = FitnessGoal.fatLoss,
    this.location = WorkoutLocation.home,
    this.activity = ActivityLevel.moderate,
    this.injuries = const [],
    this.equipment = const [],
    this.weeklyWorkoutDays = 4,
  });
}

class OnboardingController extends StateNotifier<OnboardingData> {
  OnboardingController() : super(OnboardingData());

  void update(void Function(OnboardingData) updater) {
    updater(state);
    state = state; // force rebuild
  }

  void reset() => state = OnboardingData();
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingData>(
        (ref) => OnboardingController());
