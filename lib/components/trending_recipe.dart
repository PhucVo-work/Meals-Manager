import 'package:flutter/material.dart';
import 'package:meals_manager/components/RecipeCard.dart';
import 'package:meals_manager/router/app_router.dart';
import '../components/api_service.dart';
import 'package:lottie/lottie.dart';
import '../constants/api_list.dart';
import '../constants/images_path.dart';

class TrendingRecipe extends StatefulWidget {
  @override
  TrendingRecipeState createState() => TrendingRecipeState();
}

class TrendingRecipeState extends State<TrendingRecipe> {
  final ApiService _apiService = ApiService();
  List<dynamic> _carouselData = [];

  @override
  void initState() {
    super.initState();
    _loadCarouselData();
  }

  Future<void> _loadCarouselData() async {
    try {
      final data = await _apiService.fetchData(ApiList.trendingRecipeApi);
      setState(() {
        _carouselData = data['recipes'];
      });
    } catch (e) {
      print('Error fetching carousel data: $e');
    }
  }

  void _onSavePressed(String recipeName) {
    print("Saved recipe: $recipeName");
  }

  void _onLikePressed(String recipeName) {
    print("Liked recipe: $recipeName");
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return _carouselData.isEmpty
        ? Container(
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Lottie.asset(
          ImagesPath.CookingLoading,
          width: w * .4,
          height: h * .380,
          repeat: true,
        ),
      ),
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular recipes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: h * .328,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _carouselData.length,
            itemBuilder: (context, index) {
              final recipe = _carouselData[index];
              return RecipeCard(
                  recipe: recipe,
                  onSavePressed: () => _onSavePressed(recipe['name']),
                  onLikePressed: () => _onLikePressed(recipe['name']),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailFoodRecipe,
                      arguments: {'recipe': recipe},
                    );
                  }
              );
            },
          ),
        ),
      ],
    );
  }
}
