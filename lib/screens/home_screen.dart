import 'package:flutter/material.dart';
import 'package:meals_manager/components/category_recipes.dart';
import 'package:meals_manager/components/home_app_bar.dart';
import 'package:meals_manager/components/text_field_widget.dart';
import 'package:meals_manager/components/trending_recipe.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAppBar(),
                  SizedBox(height: h * 0.014,),
                  const TextFieldWidget(),
                  SizedBox(height: h * 0.014,),
                  TrendingRecipe(),
                  CategoryRecipes(),
                ],
              ),
            ),
          )
      ),
    );
  }
}
