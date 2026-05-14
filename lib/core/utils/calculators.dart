/// Fitness science calculators - BMR (Mifflin-St Jeor), TDEE, BMI, macros, 1RM
class Calculators {
  Calculators._();

  /// BMR using Mifflin-St Jeor (most accurate everyday formula)
  static double bmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender, // 'male' | 'female'
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return gender.toLowerCase() == 'male' ? base + 5 : base - 161;
  }

  /// TDEE = BMR x activity multiplier
  static double tdee(double bmr, String activityLevel) {
    const factors = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };
    return bmr * (factors[activityLevel] ?? 1.375);
  }

  static double bmi(double weightKg, double heightCm) {
    final m = heightCm / 100.0;
    return weightKg / (m * m);
  }

  static String bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Daily calorie target based on goal
  static double calorieTarget(double tdee, String goal) {
    switch (goal) {
      case 'fat_loss':
        return tdee - 500; // 0.5 kg/week deficit
      case 'muscle_gain':
        return tdee + 300; // lean bulk surplus
      case 'maintenance':
      default:
        return tdee;
    }
  }

  /// Returns map: protein, carbs, fat grams
  static Map<String, double> macros(double calories, String goal) {
    double pPct, cPct, fPct;
    switch (goal) {
      case 'fat_loss':
        pPct = 0.40; cPct = 0.30; fPct = 0.30;
        break;
      case 'muscle_gain':
        pPct = 0.30; cPct = 0.50; fPct = 0.20;
        break;
      default:
        pPct = 0.30; cPct = 0.40; fPct = 0.30;
    }
    return {
      'protein': (calories * pPct) / 4,
      'carbs': (calories * cPct) / 4,
      'fat': (calories * fPct) / 9,
    };
  }

  /// 1RM estimate using Epley formula
  static double oneRepMax(double weight, int reps) {
    if (reps <= 0) return 0;
    if (reps == 1) return weight;
    return weight * (1 + reps / 30.0);
  }

  /// Calories burned per exercise minute (METs-based)
  static double exerciseCalories({
    required double mets,
    required double weightKg,
    required double minutes,
  }) {
    return (mets * 3.5 * weightKg / 200) * minutes;
  }

  /// Daily water intake (ml) — 35ml per kg body weight
  static double dailyWaterMl(double weightKg) => weightKg * 35;
}
