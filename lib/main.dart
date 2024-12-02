import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meals_manager/router/app_router.dart';
import 'package:meals_manager/screens/onboarding_screen.dart';
import 'package:meals_manager/screens/home_screen.dart';
import 'package:meals_manager/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cấu hình giao diện edge-to-edge
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onBoarding,
      routes: routes,
    );
  }
}