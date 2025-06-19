import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/auth_controller.dart';
import 'package:blinkit_clone/controllers/category_controller.dart';
import 'package:blinkit_clone/controllers/product_controller.dart';
import 'package:blinkit_clone/screen/admin/manage_catagories_screen.dart';
import 'package:blinkit_clone/screen/admin/manage_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final user = authController.currentUser.value;

    // Initialize ProductController and CategoryController when AdminHomeScreen is built
    Get.put(ProductController());
    Get.put(CategoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding_20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: AppSizes.icon_size_80, color: AppColors.primaryColor),
              const SizedBox(height: AppSizes.space_20),
              Text(
                'Welcome, Admin ${user?.name ?? user?.email ?? 'Guest'}!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.space_10),
              const Text(
                'This is your administration panel.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: AppSizes.font_18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSizes.space_30),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const ManageProductsScreen()); // Navigate to product management
                },
                icon: const Icon(Icons.category),
                label: const Text('Manage Products'),
              ),
              const SizedBox(height: AppSizes.space_20),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const ManageCategoriesScreen()); // Navigate to category management
                },
                icon: const Icon(Icons.class_),
                label: const Text('Manage Categories'),
              ),
              const SizedBox(height: AppSizes.space_20),
              ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Info',
                    'Manage Orders (Coming Soon!)',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blueGrey,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('Manage Orders'),
              ),
              const SizedBox(height: AppSizes.space_20),
              ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Info',
                    'Manage Users (Coming Soon!)',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blueGrey,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.people),
                label: const Text('Manage Users'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}