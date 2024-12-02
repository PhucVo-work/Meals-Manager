import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final VoidCallback onSavePressed;
  final VoidCallback onLikePressed;
  final bool isSearchScreen;
  final Map<String, dynamic> recipe;
  final Function onTap;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onSavePressed,
    required this.onLikePressed,
    this.isSearchScreen = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: w * .60,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    recipe['image'],
                    height: isSearchScreen ? h *.25 : h * .18,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Recipe Details
                Padding(
                  padding: isSearchScreen ? const EdgeInsets.all(18) : const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Name
                      Text(
                        recipe['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Cuisine Type
                      Text(
                        recipe['cuisine'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Time and Difficulty
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${recipe['prepTimeMinutes']}-${recipe['cookTimeMinutes']} minutes',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.work_outline,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipe['difficulty'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Save Button (Positioned in Stack)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: onSavePressed,
                icon: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                ),
                iconSize: 30,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            // Like Button (Positioned at the bottom right)
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                onPressed: onLikePressed,
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                iconSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
