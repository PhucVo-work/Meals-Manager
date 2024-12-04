import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meals_manager/Model/recipe_model.dart';
import 'package:meals_manager/components/save_recipe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meals_manager/constants/images_path.dart';
import 'package:lottie/lottie.dart';


class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  late Box saveBox;

  @override
  void initState() {
    super.initState();
    // Mở Hive Box đã lưu
    saveBox = Hive.box('Save');
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Saved Recipes",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFF7200b5).withOpacity(0.7),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: saveBox.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Lottie.asset(
                      ImagesPath.ingredients,
                      width: w * .80,
                      height: h * .300,
                      repeat: true,
                    ),
                  );
                }
            
                final savedRecipes = box.values.toList();
            
                return ListView.builder(
                  itemCount: savedRecipes.length,
                  itemBuilder: (context, index) {
                    // Dữ liệu từ Hive là đối tượng Recipe
                    final recipe = savedRecipes[index] as Recipe;
                    // Sử dụng trực tiếp Recipe
                    return SaveRecipe(recipe: recipe);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
