import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meals_manager/Model/recipe_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meals_manager/components/convertToJson.dart';
import 'package:meals_manager/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meals_manager/service/ingredient_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeCard extends StatelessWidget {
  final bool isSearchScreen;
  final Map<String, dynamic> recipe;

  const RecipeCard({
    Key? key,
    required this.recipe,
    this.isSearchScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final Box saveBox = Hive.box('Save');

    // Hàm kiểm tra món ăn đã được lưu chưa
    bool isSaved(int recipeId) {
      return saveBox.containsKey(recipeId);
    }

    void _onSavePressed(Map<String, dynamic> recipe) async {
      final newRecipe = Recipe(
        id: recipe['id'],
        name: recipe['name'],
        ingredients: List<String>.from(recipe['ingredients']),
        instructions: List<String>.from(recipe['instructions']),
        prepTimeMinutes: recipe['prepTimeMinutes'],
        cookTimeMinutes: recipe['cookTimeMinutes'],
        servings: recipe['servings'],
        difficulty: recipe['difficulty'],
        cuisine: recipe['cuisine'],
        caloriesPerServing: recipe['caloriesPerServing'],
        tags: List<String>.from(recipe['tags']),
        image: recipe['image'],
        rating: recipe['rating'],
        reviewCount: recipe['reviewCount'],
        mealType: List<String>.from(recipe['mealType']),
      );

      final saveBox = Hive.box('Save');
      final user = FirebaseAuth.instance.currentUser;

      // Kiểm tra nếu người dùng đã đăng nhập
      if (user == null) {
        // Nếu người dùng chưa đăng nhập, chỉ lưu/xóa vào Hive
        if (!isSaved(recipe['id'])) {
          saveBox.put(recipe['id'], newRecipe); // Lưu công thức vào Hive
          print('Công thức "${recipe['name']}" đã được lưu vào bộ nhớ cục bộ.');
        } else {
          saveBox.delete(recipe['id']); // Xóa công thức khỏi Hive
          print('Công thức "${recipe['name']}" đã được xóa khỏi bộ nhớ cục bộ.');
        }
        return; // Nếu chưa đăng nhập thì không thực hiện lưu/xóa trên Firestore
      }

      // Nếu người dùng đã đăng nhập, xử lý lưu/xóa ở Firestore
      final uid = user.uid;
      final userRecipesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('recipes');

      try {
        // Lưu/xóa vào Hive trước
        if (!isSaved(recipe['id'])) {
          saveBox.put(recipe['id'], newRecipe); // Lưu công thức vào Hive
          print('Công thức "${recipe['name']}" đã được lưu vào bộ nhớ cục bộ.');
        } else {
          saveBox.delete(recipe['id']); // Xóa công thức khỏi Hive
          print('Công thức "${recipe['name']}" đã được xóa khỏi bộ nhớ cục bộ.');
        }

        // Lưu hoặc xóa dữ liệu trên Firestore nếu đã đăng nhập
        if (!isSaved(recipe['id'])) {
          // Xóa công thức khỏi Firestore
          await userRecipesRef.doc(recipe['id'].toString()).delete();
          print('Công thức "${recipe['name']}" đã được xóa khỏi Firestore.');
        } else {
          // Lưu công thức vào Firestore
          await userRecipesRef.doc(recipe['id'].toString()).set(
            convertRecipeToJson(newRecipe),
            SetOptions(merge: true),
          );
          print('Công thức "${recipe['name']}" đã được lưu vào Firestore.');
        }
      } catch (e) {
        print('Lỗi khi lưu/xóa công thức lên Firestore: $e');
      }
    }

    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(
          context,
          AppRoutes.detailFoodRecipe,
          arguments: {'recipe': recipe},
        )
      },
      child: ValueListenableBuilder(
        valueListenable: saveBox.listenable(), // This listens to the changes in the 'Save' box
        builder: (context, Box box, _) {
          return Container(
            width: w * .60,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.network(
                        recipe['image'],
                        height: isSearchScreen ? h * .25 : h * .18,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Recipe Details
                    Padding(
                      padding: isSearchScreen
                          ? const EdgeInsets.all(18)
                          : const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recipe Name
                          Text(
                            recipe['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Cuisine Type
                          Text(
                            recipe['cuisine'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Time and Difficulty
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${recipe['prepTimeMinutes']}-${recipe['cookTimeMinutes']} minutes',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.work_outline,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                recipe['difficulty'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Save Button (Positioned in Stack)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => _onSavePressed(recipe),
                    icon: Icon(
                      isSaved(recipe['id']) ? Icons.bookmark : Icons.bookmark_border,
                      color: const Color(0xFF8A47EB),
                    ),
                    iconSize: 30,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
