import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meals_manager/screens/onboarding_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Sử dụng chế độ edge-to-edge
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Thanh trạng thái trong suốt
        systemNavigationBarColor: Colors.transparent, // Thanh điều hướng trong suốt
        systemNavigationBarIconBrightness: Brightness.light, // Icon màu trắng
        statusBarIconBrightness: Brightness.dark, // Icon thanh trạng thái màu trắng
      ),
    );

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
    );
  }
}
