import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_manager/Model/recipe_model.dart';
import 'package:meals_manager/components/convertToJson.dart';
import 'package:meals_manager/router/app_router.dart';
import '../components/api_service.dart';
import 'package:lottie/lottie.dart';
import '../constants/api_list.dart';
import '../constants/images_path.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryRecipes extends StatefulWidget {
  @override
  CategoryRecipesState createState() => CategoryRecipesState();
}

class CategoryRecipesState extends State<CategoryRecipes> {
  final ApiService _apiService = ApiService();
  List<dynamic> _recipes = [];
  String currentApi = ApiList.breakfastApi;

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

  @override
  void initState() {
    super.initState();
    _loadRecipes(currentApi);
  }

  Future<void> _loadRecipes(String apiUrl) async {
    try {
      final data = await _apiService.fetchData(apiUrl);
      setState(() {
        _recipes = data['recipes'];
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }


  void _updateCategory(String apiUrl) {
    setState(() {
      _recipes = [];
      currentApi = apiUrl;
    });
    _loadRecipes(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    // Danh sách các tag
    final List<Map<String, String>> categories = [
      {'name': 'Breakfast', 'api': ApiList.breakfastApi},
      {'name': 'Lunch', 'api': ApiList.lunchApi},
      {'name': 'Dinner', 'api': ApiList.dinnerApi},
      {'name': 'Dessert', 'api': ApiList.dessertApi},
      {'name': 'Snack', 'api': ApiList.snackApi},
      {'name': 'Side Dish', 'api': ApiList.sideDishApi},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Section
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(
          height: h * 0.05,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => _updateCategory(category['api']!), // Truyền API khi bấm
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: currentApi == category['api']
                        ? Colors.red // Thay đổi màu khi chọn
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: currentApi == category['api'] ? Colors.red : Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      category['name']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: currentApi == category['api'] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        // Recipe Section
        _recipes.isEmpty
            ? Center(
          child: Lottie.asset(
            ImagesPath.loading,
            width: w * .55,
            height: h * .255,
            repeat: true,
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * .210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detailFoodRecipe,
                        arguments: {'recipe': recipe},
                      );
                    },
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(recipe['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Text(
                                recipe['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8A47EB).withOpacity(0.6),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)
                                  ),
                                ),
                                child: ValueListenableBuilder(
                                  valueListenable: saveBox.listenable(),
                                  builder: (context, Box box, _) {
                                    bool saved = isSaved(recipe['id']);
                                    return IconButton(
                                      onPressed: () => _onSavePressed(recipe),
                                      icon: Icon(
                                        saved ? Icons.bookmark : Icons.bookmark_border,
                                        color: Colors.white,
                                      ),
                                      iconSize: 30,
                                      color: Colors.black.withOpacity(0.6),
                                    );
                                  },
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
