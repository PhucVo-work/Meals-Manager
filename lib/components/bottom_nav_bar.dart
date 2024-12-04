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
        padding: EdgeInsets.only(left: w *.04, right: w *.036, bottom: h * .022, top: h * .010),
        child: GNav(
          gap: 10,
          tabBorderRadius: 100,
          backgroundColor: Colors.white,
          activeColor: const Color(0xFF7200b5),
          color: Colors.black,
          tabBackgroundColor: const Color(0xFF8A47EB).withOpacity(0.2),
          iconSize: 38,
          textSize: 18,
          padding: EdgeInsets.symmetric(horizontal: w * .028, vertical: h * .01),
          tabs: const [
            GButton(icon: Icons.home_outlined, text: 'Home',),
            GButton(icon: Icons.search_outlined, text:'Search'),
            GButton(icon: Icons.note_alt_rounded, text: 'Save meal',),
            GButton(icon: Icons.shopping_bag_outlined, text: 'Grocery list',)
          ],
          onTabChange: widget.onTap,
          selectedIndex: widget.SelectedItem
        ),
      ),
    );
  }
}