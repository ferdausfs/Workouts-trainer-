import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;
  static late Box _userBox;
  static late Box _settingsBox;
  static late Box _workoutBox;
  static late Box _nutritionBox;
  static late Box _progressBox;

  static SharedPreferences get prefs => _prefs;
  static Box get userBox => _userBox;
  static Box get settingsBox => _settingsBox;
  static Box get workoutBox => _workoutBox;
  static Box get nutritionBox => _nutritionBox;
  static Box get progressBox => _progressBox;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _userBox = await Hive.openBox(AppConstants.userBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
    _workoutBox = await Hive.openBox(AppConstants.workoutBox);
    _nutritionBox = await Hive.openBox(AppConstants.nutritionBox);
    _progressBox = await Hive.openBox(AppConstants.progressBox);
  }

  // Onboarding
  static bool get isOnboardingComplete =>
      _prefs.getBool(AppConstants.kOnboardingComplete) ?? false;
  static Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(AppConstants.kOnboardingComplete, value);

  // Premium
  static bool get isPremium => _prefs.getBool(AppConstants.kIsPremium) ?? false;
  static Future<void> setPremium(bool value) =>
      _prefs.setBool(AppConstants.kIsPremium, value);

  // Theme
  static String get themeMode => _prefs.getString(AppConstants.kThemeMode) ?? 'dark';
  static Future<void> setThemeMode(String mode) =>
      _prefs.setString(AppConstants.kThemeMode, mode);

  // Language
  static String get language => _prefs.getString(AppConstants.kLanguage) ?? 'en';
  static Future<void> setLanguage(String code) =>
      _prefs.setString(AppConstants.kLanguage, code);

  static Future<void> clearAll() async {
    await _userBox.clear();
    await _workoutBox.clear();
    await _nutritionBox.clear();
    await _progressBox.clear();
    await _prefs.clear();
  }
}
