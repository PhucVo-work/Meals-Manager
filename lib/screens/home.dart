  import 'package:flutter/material.dart';
  import 'package:meals_manager/components/bottom_nav_bar.dart';
  import 'package:meals_manager/screens/home_screen.dart';
  import 'package:meals_manager/screens/search_screen.dart';
  import 'package:meals_manager/screens/favorite_screen.dart';
  import 'package:meals_manager/screens/meal_plan_screen.dart';
  import 'package:meals_manager/screens/grocery_list_screen.dart';

  class Home extends StatefulWidget {
    const Home({Key? key}) : super(key: key);

    @override
    State<Home> createState() => _HomeState();
  }

  class _HomeState extends State<Home> {
    int currentIndex = 0;
    String searchQuery = ''; // Lưu query để truyền qua SearchScreen

    void handleSearch(String query) {
      setState(() {
        searchQuery = query;
        onPageChange(1); // Chuyển qua trang SearchScreen
      });
    }


    void onPageChange(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        bottomNavigationBar: BottomNavBar(
          onTap: onPageChange,
          SelectedItem: currentIndex,
        ),
        body: IndexedStack(
          index: currentIndex,  // Hiển thị trang dựa trên currentIndex
          children: [
            HomePage(onSearch: handleSearch),
            SearchScreen(
                key: ValueKey(searchQuery), // Tái tạo SearchScreen khi query thay đổi
                searchQuery: searchQuery
            ),
            const FavoriteScreen(),
            const MealPlanScreen(),
            const GroceryListScreen(),
          ],
        ),
      );
    }
  }


