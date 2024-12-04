import 'dart:convert';
import 'package:meals_manager/Model/recipe_model.dart';

// Hàm chuyển đối tượng Recipe thành Map<String, dynamic>
Map<String, dynamic> convertRecipeToJson(Recipe recipe) {
  return {
    'id': recipe.id,
    'name': recipe.name,
    'ingredients': recipe.ingredients,
    'instructions': recipe.instructions,
    'prepTimeMinutes': recipe.prepTimeMinutes,
    'cookTimeMinutes': recipe.cookTimeMinutes,
    'servings': recipe.servings,
    'difficulty': recipe.difficulty,
    'cuisine': recipe.cuisine,
    'caloriesPerServing': recipe.caloriesPerServing,
    'tags': recipe.tags,
    'image': recipe.image,
    'rating': recipe.rating,
    'reviewCount': recipe.reviewCount,
    'mealType': recipe.mealType,
  };
}

// Hàm chuyển đổi JSON thành đối tượng Recipe
Recipe convertJsonToRecipe(Map<String, dynamic> json) {
  return Recipe(
    id: json['id'],
    name: json['name'],
    ingredients: List<String>.from(json['ingredients']),
    instructions: List<String>.from(json['instructions']),
    prepTimeMinutes: json['prepTimeMinutes'],
    cookTimeMinutes: json['cookTimeMinutes'],
    servings: json['servings'],
    difficulty: json['difficulty'],
    cuisine: json['cuisine'],
    caloriesPerServing: json['caloriesPerServing'],
    tags: List<String>.from(json['tags']),
    image: json['image'],
    rating: json['rating'],
    reviewCount: json['reviewCount'],
    mealType: json['mealType'],
  );
}
