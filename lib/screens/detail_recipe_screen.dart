import 'dart:ui';
import 'package:flutter/material.dart';

class DetailRecipeScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const DetailRecipeScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> details = [
      {'icon': Icons.restaurant, 'text': '${recipe['servings']} servings'},
      {'icon': Icons.access_time, 'text': '${recipe['prepTimeMinutes']} min prep time'},
      {'icon': Icons.kitchen, 'text': '${recipe['cookTimeMinutes']} min cook time'},
      {'icon': Icons.stars, 'text': recipe['difficulty']},
      {'icon': Icons.flag, 'text': recipe['cuisine']},
      {'icon': Icons.local_dining, 'text': '${recipe['caloriesPerServing']} cal/serving'},
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // AppBar hiển thị ảnh
              SliverAppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: Container(
                      height: 20,
                      width: w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(80),
                        ),
                      ),
                    )),
                pinned: true,
                expandedHeight: h * 0.4, // Chiều cao ảnh
                automaticallyImplyLeading: false, // Ẩn nút back mặc định
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Ảnh nền
                      Image.network(
                        recipe['image'],
                        fit: BoxFit.cover,
                      ),
                      // Tấm kính mờ chứa tên món và đánh giá
                      Positioned(
                        bottom: 50,
                        left: 20,
                        right: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.black.withOpacity(0.3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      recipe['name'],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        recipe['rating'].toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Nút back tùy chỉnh
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8), // Cách mép
                    decoration: BoxDecoration(
                      color: Colors.white, // Nền trắng
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back, // Biểu tượng back
                      color: Colors.black, // Màu icon
                    ),
                  ),
                ),
              ),

              // Nội dung chi tiết
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recipe Details',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: List.generate(details.length, (index) {
                                final detail = details[index];
                                return _buildDetailCard(detail['icon'], detail['text']);
                              }),
                            ),
                            SizedBox(height: h * .024),
                            const Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...List.generate(
                              recipe['ingredients'].length,
                                  (index) => Padding(
                                padding: EdgeInsets.only(left: 20, bottom: h * 0.018),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}.', // The index/step number
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 21,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        recipe['ingredients'][index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Text(
                                'Instructions',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                              height: h * 0.018,
                            ),
                            ...List.generate(
                              recipe['instructions'].length,
                                  (index) => Padding(
                                padding: EdgeInsets.only(left: 20, bottom: h * 0.018),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}.', // The index/step number
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 21,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        recipe['instructions'][index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Nút cố định
          Positioned(
            right: 16,
            bottom: 40,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'save',
                  onPressed: () {
                    // Thêm sự kiện save tại đây
                  },
                  child: const Icon(Icons.bookmark,),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'heart',
                  onPressed: () {
                    // Thêm sự kiện heart tại đây
                  },
                  child: const Icon(Icons.favorite, color: Colors.redAccent,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF8A47EB).withOpacity(0.8), // Màu nền giống mẫu
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20), // Icon hiển thị
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
