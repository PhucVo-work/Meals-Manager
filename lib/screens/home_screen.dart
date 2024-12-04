import 'package:flutter/material.dart';
import 'package:meals_manager/components/category_recipes.dart';
import 'package:meals_manager/components/home_app_bar.dart';
import 'package:meals_manager/components/text_field_widget.dart';
import 'package:meals_manager/components/trending_recipe.dart';

class HomePage extends StatefulWidget {
  final Function(String) onSearch;
  const HomePage({super.key, required this.onSearch});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                SizedBox(height: h * 0.014),
                TextFieldWidget(
                  controller: _searchController,
                  hintText: "Type any ingredients to get a recipe",
                  onSearchPressed: () {
                    final query = _searchController.text.trim();
                    if (query.isEmpty) {
                      // Nếu query rỗng, hiển thị thông báo lỗi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a search query.")),
                      );
                    } else {
                      widget.onSearch(query);
                      _searchController.clear();
                    }
                  },
                ),
                SizedBox(height: h * 0.014),
                TrendingRecipe(),
                CategoryRecipes(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
