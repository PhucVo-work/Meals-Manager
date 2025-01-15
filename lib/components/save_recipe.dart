import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_manager/Model/recipe_model.dart';
import 'package:hive/hive.dart';
import 'package:meals_manager/router/app_router.dart';
import 'package:meals_manager/components/convertToJson.dart';


class SaveRecipe extends StatefulWidget {
  final Recipe recipe; // Tham chiếu đến model Recipe
  const SaveRecipe({super.key, required this.recipe});

  @override
  State<SaveRecipe> createState() => _SaveRecipeState();
}

class _SaveRecipeState extends State<SaveRecipe> {


  void _deleteRecipe() async {
    final box = await Hive.openBox('Save'); // Mở Hive box 'Save'
    final user = FirebaseAuth.instance.currentUser; // Lấy thông tin người dùng hiện tại

    try {
      // Nếu người dùng đã đăng nhập
      if (user != null) {
        final uid = user.uid; // ID người dùng
        final userRecipesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('recipes'); // Tham chiếu tới Firestore

        // Xóa công thức khỏi Firestore
        await userRecipesRef.doc(widget.recipe.id.toString()).delete();
        print('Công thức "${widget.recipe.name}" đã được xóa khỏi Firestore.');
      }

      // Xóa công thức khỏi Hive
      box.delete(widget.recipe.id);
      print('Công thức "${widget.recipe.name}" đã được xóa khỏi Hive.');
    } catch (e) {
      print('Lỗi khi xóa công thức: $e');
    }

    setState(() {}); // Cập nhật UI sau khi xóa
  }


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final recipe = widget.recipe;

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
          context,
          AppRoutes.detailFoodRecipe,
          arguments: {'recipe': convertRecipeToJson(recipe)},
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.020),
        child: Padding(
          padding: EdgeInsets.all( w * 0.034),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh và đánh giá
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh món ăn
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      recipe.image, // URL ảnh từ Recipe model
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nội dung chính
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên và thời gian
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                recipe.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Đánh giá (rating)
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              recipe.rating.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Nguyên liệu
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: recipe.ingredients.map((ingredient) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      ingredient,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              // Nút xóa
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _deleteRecipe,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text("Delete", style: TextStyle(fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    minimumSize: const Size(80, 36),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
