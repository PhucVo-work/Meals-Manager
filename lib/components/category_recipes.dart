import 'package:flutter/material.dart';
import 'package:meals_manager/router/app_router.dart';
import '../components/api_service.dart';
import 'package:lottie/lottie.dart';
import '../constants/api_list.dart';
import '../constants/images_path.dart';

class CategoryRecipes extends StatefulWidget {
  @override
  CategoryRecipesState createState() => CategoryRecipesState();
}


class CategoryRecipesState extends State<CategoryRecipes> {
  final ApiService _apiService = ApiService();
  List<dynamic> _recipes = [];
  String currentApi = ApiList.breakfastApi;

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
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => {/* hàm lưu cho 2 trường hợp*/},
                                      icon: const Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
                                      ),
                                      iconSize: 30,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    IconButton(
                                      onPressed: () => {/* hàm yêu thích cho 2 trường hợp */},
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                      iconSize: 30,
                                    ),
                                  ],
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
