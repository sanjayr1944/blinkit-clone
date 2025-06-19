import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AuthController instance
    final AuthController authController = Get.find<AuthController>();
    // Access the current user from the AuthController's reactive variable
    final user = authController.firebaseUser.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blinkit Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout(); // Call logout method from controller
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
              const Icon(Icons.check_circle_outline, size: AppSizes.icon_size_80, color: AppColors.successColor),
              const SizedBox(height: AppSizes.space_20),
              Text(
                'Welcome, ${user?.email ?? 'Guest'}!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.space_10),
              const Text(
                'You are successfully logged in.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: AppSizes.font_18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSizes.space_30),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar( // Use Get.snackbar for messages
                    'Info',
                    'Navigating to app features... (not implemented yet)',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blueGrey,
                    colorText: Colors.white,
                  );
                },
                child: const Text('Go to App Features'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}