import 'package:hive/hive.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> ingredients;

  @HiveField(3)
  final List<String> instructions;

  @HiveField(4)
  final int prepTimeMinutes;

  @HiveField(5)
  final int cookTimeMinutes;

  @HiveField(6)
  final int servings;

  @HiveField(7)
  final String difficulty;

  @HiveField(8)
  final String cuisine;

  @HiveField(9)
  final int caloriesPerServing;

  @HiveField(10)
  final List<String> tags;

  @HiveField(11)
  final String image;

  @HiveField(12)
  final double rating;

  @HiveField(13)
  final int reviewCount;

  @HiveField(14)
  final List<String> mealType;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.tags,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.mealType,
  });
}
