import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meals_manager/Model/ingredients_model.dart';
import 'package:meals_manager/router/app_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meals_manager/service/ingredient_service.dart';
import 'Model/recipe_model.dart';
import 'package:path_provider/path_provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(IngredientAdapter()); // Đăng ký adapter cho Ingredient

  await Hive.initFlutter();
  await Hive.openBox('Save');
  await Hive.openBox<Ingredient>('ingredients'); // Box lưu nguyên liệu

  // Khởi tạo service
    final ingredientService = IngredientService();
    await ingredientService.init();
    await ingredientService.processIngredientsFromRecipes();

  //firebase login
  await Firebase.initializeApp();
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