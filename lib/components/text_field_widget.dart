import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onSubmitted; // Xử lý khi nhấn Enter
  final VoidCallback? onSearchPressed; // Xử lý khi nhấn nút tìm kiếm

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSubmitted,
    this.onSearchPressed,
  });

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
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 0,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: w * .04, color: Colors.black),
        onSubmitted: (value) {
          if (onSubmitted != null) onSubmitted!(value.trim());
        },  // Gọi khi nhấn Enter
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black54, fontSize: w * .034),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8A47EB), width: 1.5),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search_outlined, color: Colors.black, size: w * .06),
            onPressed: onSearchPressed,  // Gọi khi nhấn nút tìm kiếm
          ),
        ),
      ),
    );
  }
}
