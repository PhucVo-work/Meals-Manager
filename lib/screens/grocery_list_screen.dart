import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meals_manager/Model/ingredients_model.dart';
import 'package:meals_manager/constants/images_path.dart';
import 'package:meals_manager/service/ingredient_service.dart';
import 'package:lottie/lottie.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  late IngredientService ingredientService;

  @override
  void initState() {
    super.initState();
    ingredientService = IngredientService();
    ingredientService.init(); // Khởi tạo dịch vụ
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Ingredients list",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFF7200b5).withOpacity(0.7),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: h * 0.0012),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Ingredient>('ingredients').listenable(),
          builder: (context, Box<Ingredient> box, _) {
            final ingredients = box.values.toList();
            if (ingredients.isEmpty) {
              return Center(
                child: Lottie.asset(
                  ImagesPath.ingredients,
                  width: w * .80,
                  height: h * .300,
                  repeat: true,
                ),
              );
            }

            // Phân nhóm nguyên liệu
            final duplicateIngredients = ingredients.where((ing) => ing.isDuplicate).toList();
            final uncheckedIngredients = ingredients.where((ing) => !ing.isCheck && !ing.isDuplicate).toList();
            final checkedIngredients = ingredients.where((ing) => ing.isCheck).toList();

            return ListView(
              children: [
                if (duplicateIngredients.isNotEmpty) ...[
                  _buildGroupContainer(
                    title: 'Ingredients in multiple recipes',
                    ingredients: duplicateIngredients,
                  ),
                ],

                if (uncheckedIngredients.isNotEmpty) ...[
                  _buildGroupContainer(
                    title: 'Ingredients',
                    ingredients: uncheckedIngredients,
                  ),
                ],

                if (checkedIngredients.isNotEmpty) ...[
                  _buildGroupContainer(
                    title: 'Purchased Ingredients',
                    ingredients: checkedIngredients,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGroupContainer({required String title, required List<Ingredient> ingredients}) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only( left: w * .04, bottom: h * .008, top: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: w * .06, right: w * .06),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: const Color(0xFF8A47EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...ingredients.map((ingredient) => _buildIngredientTile(ingredient)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientTile(Ingredient ingredient) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF8A47EB)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(ingredient.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
          trailing: Checkbox(
            value: ingredient.isCheck,
            onChanged: (value) async {
              setState(() {
                ingredient.isCheck = value!;
              });
              await ingredient.save();
            },
          ),
        ),
      ),
    );
  }
}
