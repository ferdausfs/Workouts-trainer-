class AppConstants {
  AppConstants._();

  static const String appName = 'PulseFit AI';
  static const String appTagline = 'Your AI-Powered Fitness Coach';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.pulsefit.ai/v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Hive boxes
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';
  static const String workoutBox = 'workout_box';
  static const String nutritionBox = 'nutrition_box';
  static const String progressBox = 'progress_box';

  // SharedPrefs keys
  static const String kOnboardingComplete = 'onboarding_complete';
  static const String kThemeMode = 'theme_mode';
  static const String kLanguage = 'language';
  static const String kUserId = 'user_id';
  static const String kIsPremium = 'is_premium';
  static const String kFirstLaunch = 'first_launch';

  // Workout constants
  static const int defaultRestSeconds = 30;
  static const int defaultPrepSeconds = 10;
  static const double kcalPerKgPerHour = 5.5; // Approx METs baseline

  // UI
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration midAnim = Duration(milliseconds: 400);
  static const Duration longAnim = Duration(milliseconds: 700);
}
