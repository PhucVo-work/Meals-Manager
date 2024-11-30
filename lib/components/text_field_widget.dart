import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // Màu bóng nhẹ hơn
            offset: Offset(0, 4),  // Dịch bóng sang phải và xuống dưới
            blurRadius: 8,        // Bóng mờ hơn
            spreadRadius: 0,      // Lan rộng nhẹ bóng
          )
        ],
      ),
      child: TextField(
        style: TextStyle(
          fontSize: w * .04,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Type any ingredients to get a recipe",
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: w * .034,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFF8A47EB), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 1),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Icon(
              Icons.search_outlined,
              color: Colors.black,
              size: w * .06,
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: w * .05,
            minHeight: w * .05,
          ),
        ),
      ),
    );
  }
}
