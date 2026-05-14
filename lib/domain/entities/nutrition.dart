class FoodItem {
  final String id;
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final String? imageUrl;
  final String category;

  const FoodItem({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.imageUrl,
    this.category = 'general',
  });

  factory FoodItem.fromJson(Map<String, dynamic> j) => FoodItem(
    id: j['id'],
    name: j['name'],
    caloriesPer100g: (j['caloriesPer100g'] as num).toDouble(),
    proteinPer100g: (j['proteinPer100g'] as num).toDouble(),
    carbsPer100g: (j['carbsPer100g'] as num).toDouble(),
    fatPer100g: (j['fatPer100g'] as num).toDouble(),
    imageUrl: j['imageUrl'],
    category: j['category'] ?? 'general',
  );
}

class MealEntry {
  final String id;
  final FoodItem food;
  final double grams;
  final String mealType; // breakfast/lunch/dinner/snack
  final DateTime loggedAt;

  const MealEntry({
    required this.id,
    required this.food,
    required this.grams,
    required this.mealType,
    required this.loggedAt,
  });

  double get calories => food.caloriesPer100g * grams / 100;
  double get protein => food.proteinPer100g * grams / 100;
  double get carbs => food.carbsPer100g * grams / 100;
  double get fat => food.fatPer100g * grams / 100;
}

class WaterEntry {
  final DateTime date;
  final int amountMl;

  const WaterEntry({required this.date, required this.amountMl});
}
