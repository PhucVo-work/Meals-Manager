import 'package:flutter/material.dart';
import 'package:meals_manager/screens/detail_recipe_screen.dart';
import 'package:meals_manager/screens/grocery_list_screen.dart';
import 'package:meals_manager/screens/home.dart';
import 'package:meals_manager/screens/meal_plan_screen.dart';
import 'package:meals_manager/screens/onboarding_screen.dart';
import 'package:meals_manager/screens/search_screen.dart';

class AppRoutes {
  static const String onBoarding = '/onBoarding';
  static const String home = '/home';
  static const String search = '/search';
  static const String mealPlan = '/mealPlan';
  static const String groceryList = '/groceryList';
  static const String detailFoodRecipe = '/detailFoodRecipe';
}

final Map<String, WidgetBuilder> routes = {
  AppRoutes.onBoarding: (context) => const OnBoardingScreen(),
  AppRoutes.home: (context) => const Home(),
  AppRoutes.search: (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final query = args?['searchQuery'] ?? '';
    return SearchScreen(searchQuery: query);
  },
  AppRoutes.detailFoodRecipe: (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final recipe = args?['recipe'];
    return DetailRecipeScreen(recipe: recipe);
  },
  AppRoutes.mealPlan: (context) => const MealPlanScreen(),
  AppRoutes.groceryList: (context) => const GroceryListScreen(),
};
