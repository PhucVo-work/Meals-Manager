import 'package:hive/hive.dart';
import 'package:meals_manager/Model/ingredients_model.dart';
import '../Model/recipe_model.dart';

class IngredientService {
  late final Box<Ingredient> ingredientBox;
  late final Box recipeBox;

  Future<void> init() async {
    ingredientBox = await Hive.openBox<Ingredient>('ingredients');
    recipeBox = await Hive.openBox('Save');

    // Lắng nghe thay đổi trong Box 'Save' để cập nhật nguyên liệu
    recipeBox.watch().listen((event) {
      processIngredientsFromRecipes();
    });
  }

  Future<void> processIngredientsFromRecipes() async {
    final List<Recipe> recipes = recipeBox.values.cast<Recipe>().toList();
    final Map<String, Ingredient> ingredientMap = {};

    // Tạo lại danh sách nguyên liệu từ các công thức hiện tại
    for (final recipe in recipes) {
      for (final ingredientName in recipe.ingredients) {
        if (ingredientMap.containsKey(ingredientName)) {
          // Cập nhật thông tin công thức vào nguyên liệu đã tồn tại
          final existingIngredient = ingredientMap[ingredientName]!;
          if (!existingIngredient.recipeIds.contains(recipe.id.toString())) {
            existingIngredient.recipeIds.add(recipe.id.toString());
            existingIngredient.recipeNames.add(recipe.name);
          }
          existingIngredient.isDuplicate = true;
        } else {
          // Tạo nguyên liệu mới nếu chưa tồn tại
          ingredientMap[ingredientName] = Ingredient(
            id: ingredientName,
            name: ingredientName,
            isDuplicate: false,
            recipeIds: [recipe.id.toString()],
            recipeNames: [recipe.name],
          );
        }
      }
    }

    // Cập nhật hoặc thêm nguyên liệu mới vào ingredientBox
    for (final ingredient in ingredientMap.values) {
      await ingredientBox.put(ingredient.id, ingredient);
    }

    // Xóa các nguyên liệu không còn liên kết với bất kỳ công thức nào
    final allIngredients = ingredientBox.values.toList();
    for (final ingredient in allIngredients) {
      // Kiểm tra nếu không còn liên kết với công thức nào, xóa nguyên liệu
      if (ingredient.recipeIds.every((id) => !recipes.any((recipe) => recipe.id.toString() == id))) {
        await ingredient.delete();
      }
    }
  }

  List<Ingredient> getIngredients() {
    return ingredientBox.values.toList();
  }

  Future<void> togglePurchase(String id, bool value) async {
    final ingredient = ingredientBox.get(id);
    if (ingredient != null) {
      ingredient.isCheck = value;
      await ingredient.save();
    }
  }
}

