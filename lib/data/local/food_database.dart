import '../../domain/entities/nutrition.dart';

class FoodDatabase {
  static const List<FoodItem> all = [
    FoodItem(id: 'f1', name: 'Chicken Breast', caloriesPer100g: 165, proteinPer100g: 31, carbsPer100g: 0, fatPer100g: 3.6, category: 'protein'),
    FoodItem(id: 'f2', name: 'Brown Rice', caloriesPer100g: 112, proteinPer100g: 2.6, carbsPer100g: 23, fatPer100g: 0.9, category: 'carbs'),
    FoodItem(id: 'f3', name: 'Salmon', caloriesPer100g: 208, proteinPer100g: 20, carbsPer100g: 0, fatPer100g: 13, category: 'protein'),
    FoodItem(id: 'f4', name: 'Sweet Potato', caloriesPer100g: 86, proteinPer100g: 1.6, carbsPer100g: 20, fatPer100g: 0.1, category: 'carbs'),
    FoodItem(id: 'f5', name: 'Broccoli', caloriesPer100g: 34, proteinPer100g: 2.8, carbsPer100g: 7, fatPer100g: 0.4, category: 'vegetable'),
    FoodItem(id: 'f6', name: 'Avocado', caloriesPer100g: 160, proteinPer100g: 2, carbsPer100g: 9, fatPer100g: 15, category: 'fat'),
    FoodItem(id: 'f7', name: 'Eggs', caloriesPer100g: 155, proteinPer100g: 13, carbsPer100g: 1.1, fatPer100g: 11, category: 'protein'),
    FoodItem(id: 'f8', name: 'Oats', caloriesPer100g: 389, proteinPer100g: 17, carbsPer100g: 66, fatPer100g: 7, category: 'carbs'),
    FoodItem(id: 'f9', name: 'Greek Yogurt', caloriesPer100g: 59, proteinPer100g: 10, carbsPer100g: 3.6, fatPer100g: 0.4, category: 'protein'),
    FoodItem(id: 'f10', name: 'Almonds', caloriesPer100g: 579, proteinPer100g: 21, carbsPer100g: 22, fatPer100g: 50, category: 'fat'),
    FoodItem(id: 'f11', name: 'Banana', caloriesPer100g: 89, proteinPer100g: 1.1, carbsPer100g: 23, fatPer100g: 0.3, category: 'fruit'),
    FoodItem(id: 'f12', name: 'Quinoa', caloriesPer100g: 120, proteinPer100g: 4.4, carbsPer100g: 21, fatPer100g: 1.9, category: 'carbs'),
    FoodItem(id: 'f13', name: 'Spinach', caloriesPer100g: 23, proteinPer100g: 2.9, carbsPer100g: 3.6, fatPer100g: 0.4, category: 'vegetable'),
    FoodItem(id: 'f14', name: 'Beef (Lean)', caloriesPer100g: 250, proteinPer100g: 26, carbsPer100g: 0, fatPer100g: 15, category: 'protein'),
    FoodItem(id: 'f15', name: 'Tuna', caloriesPer100g: 132, proteinPer100g: 28, carbsPer100g: 0, fatPer100g: 1, category: 'protein'),
    FoodItem(id: 'f16', name: 'Olive Oil', caloriesPer100g: 884, proteinPer100g: 0, carbsPer100g: 0, fatPer100g: 100, category: 'fat'),
    FoodItem(id: 'f17', name: 'Cottage Cheese', caloriesPer100g: 98, proteinPer100g: 11, carbsPer100g: 3.4, fatPer100g: 4.3, category: 'protein'),
    FoodItem(id: 'f18', name: 'Whey Protein', caloriesPer100g: 400, proteinPer100g: 80, carbsPer100g: 8, fatPer100g: 6, category: 'protein'),
    FoodItem(id: 'f19', name: 'Apple', caloriesPer100g: 52, proteinPer100g: 0.3, carbsPer100g: 14, fatPer100g: 0.2, category: 'fruit'),
    FoodItem(id: 'f20', name: 'Blueberries', caloriesPer100g: 57, proteinPer100g: 0.7, carbsPer100g: 14, fatPer100g: 0.3, category: 'fruit'),
  ];
}
