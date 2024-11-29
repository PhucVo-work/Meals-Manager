import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  final int SelectedItem;
  final Function(int) onTap;
  const BottomNavBar({super.key, required this.onTap, required this.SelectedItem});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w *.07, vertical: h * .022),
        child: GNav(
          gap: 10,
          tabBorderRadius: 100,
          backgroundColor: Colors.white,
          activeColor: const Color(0xFF7200b5),
          color: Colors.black,
          tabBackgroundColor: Colors.purple.withOpacity(0.2),
          iconSize: 38,
          textSize: 18,
          padding: EdgeInsets.symmetric(horizontal: w * .01, vertical: h * .01),
          tabs: const [
            GButton(icon: Icons.home_outlined, text: 'Home',),
            // GButton(icon: Icons.edit_note, text: 'Meal Plan',), phát triển trong tương lai
            GButton(icon: Icons.search_outlined, text:'Search'),
            // GButton(icon: Icons.favorite_border, text: 'Favorite recipe',),
            GButton(icon: Icons.note_alt_rounded, text: 'Meal Recipe',),
            GButton(icon: Icons.shopping_bag_outlined, text: 'Grocecy List',)
          ],
          onTabChange: widget.onTap,
            selectedIndex: 0,
        ),
      ),
    );
  }
}