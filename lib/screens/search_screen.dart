import 'package:flutter/material.dart';
import 'package:meals_manager/components/RecipeCard.dart';
import 'package:meals_manager/constants/api_list.dart';
import 'package:meals_manager/constants/images_path.dart';
import 'package:meals_manager/router/app_router.dart';
import '../components/api_service.dart';
import '../components/text_field_widget.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    if (widget.searchQuery.isNotEmpty) {
      _searchRecipes(widget.searchQuery);
    }
  }

  Future<void> _searchRecipes(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a search query.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _apiService.fetchData(ApiList.mainApi);
      final allRecipes = data['recipes'];

      setState(() {
        _recipes = allRecipes.where((recipe) {
          final queryLower = query.toLowerCase();
          return recipe['name'].toString().toLowerCase().contains(queryLower);
        }).toList();
      });
    } catch (e) {
      print('Error fetching search data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Search Recipes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFieldWidget(
              controller: _searchController,
              hintText: "Search recipes...",
              onSubmitted: (value) {
                _searchRecipes(value.trim());
              },
              onSearchPressed: () {
                _searchRecipes(_searchController.text.trim());
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                  child: Lottie.asset(
                   ImagesPath.loading,
                   width: w * .55,
                   height: h * .255,
                   repeat: true,
                  ),
                )
                : _recipes.isEmpty
                ? Center(child: Text("No results found for '${_searchController.text.trim()}'"))
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return Padding(
                      padding: EdgeInsets.only(left: 5, bottom: h * .028),
                      child: RecipeCard(
                        onTap: (){
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detailFoodRecipe,
                            arguments: {'recipe': recipe},
                          );
                        },
                        recipe: recipe,
                        onSavePressed: () => print("Saved ${recipe['name']}"),
                        onLikePressed: () => print("Liked ${recipe['name']}"),
                        isSearchScreen: true,
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
