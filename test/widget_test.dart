import 'package:flutter_test/flutter_test.dart';
import 'package:pulsefit_ai/core/utils/calculators.dart';

void main() {
  group('Calculators', () {
    test('BMR Mifflin-St Jeor — male', () {
      final bmr = Calculators.bmr(weightKg: 80, heightCm: 180, age: 25, gender: 'male');
      expect(bmr, closeTo(1855, 1));
    });

    test('BMR Mifflin-St Jeor — female', () {
      final bmr = Calculators.bmr(weightKg: 65, heightCm: 165, age: 30, gender: 'female');
      expect(bmr, closeTo(1370.25, 1));
    });

    test('BMI calculation', () {
      expect(Calculators.bmi(70, 175), closeTo(22.86, 0.1));
      expect(Calculators.bmiCategory(22.86), 'Normal');
      expect(Calculators.bmiCategory(17), 'Underweight');
      expect(Calculators.bmiCategory(27), 'Overweight');
      expect(Calculators.bmiCategory(32), 'Obese');
    });

    test('Calorie target for fat loss = TDEE - 500', () {
      final t = Calculators.calorieTarget(2500, 'fat_loss');
      expect(t, 2000);
    });

    test('1RM Epley formula', () {
      expect(Calculators.oneRepMax(100, 1), 100);
      expect(Calculators.oneRepMax(100, 5), closeTo(116.67, 0.1));
    });

    test('Macros sum approximately to calorie target', () {
      final m = Calculators.macros(2000, 'fat_loss');
      final cal = m['protein']! * 4 + m['carbs']! * 4 + m['fat']! * 9;
      expect(cal, closeTo(2000, 5));
    });
  });
}
