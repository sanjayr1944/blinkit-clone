import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/auth_controller.dart';
import 'package:blinkit_clone/controllers/category_controller.dart';
import 'package:blinkit_clone/controllers/product_controller.dart';
import 'package:blinkit_clone/screen/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  Get.put(ProductController()); // Ensure ProductController is initialized here
  Get.put(CategoryController());
  runApp(const MyApp());
}

  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blinkit Clone',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: AppSizes.font_28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          headlineMedium: TextStyle(fontSize: AppSizes.font_24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          bodyLarge: TextStyle(fontSize: AppSizes.font_16, color: AppColors.textPrimary),
          bodyMedium: TextStyle(fontSize: AppSizes.font_14, color: AppColors.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding_30, vertical: AppSizes.padding_15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius_12),
            ),
            textStyle: const TextStyle(fontSize: AppSizes.font_18, fontWeight: FontWeight.bold),
            elevation: AppSizes.elevation_5,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius_12),
            borderSide: const BorderSide(color: AppColors.accentColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius_12),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: AppSizes.border_width_2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius_12),
            borderSide: const BorderSide(color: AppColors.borderColor, width: AppSizes.border_width_1),
          ),
          filled: true,
          fillColor: AppColors.fillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.padding_15, horizontal: AppSizes.padding_20),
          labelStyle: const TextStyle(color: AppColors.hintColor),
          hintStyle: const TextStyle(color: AppColors.hintColorLight),
        ),
        cardTheme: CardThemeData(
          elevation: AppSizes.elevation_4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius_15),
          ),
          margin: const EdgeInsets.all(AppSizes.margin_10),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBarBackground,
          foregroundColor: AppColors.appBarForeground,
          elevation: AppSizes.elevation_0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.appBarText, fontSize: AppSizes.font_22, fontWeight: FontWeight.bold
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}