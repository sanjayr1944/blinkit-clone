import 'package:blinkit_clone/controllers/auth_controller.dart';
import 'package:blinkit_clone/screen/auth/login_screen.dart';
import 'package:blinkit_clone/screen/home/admin_home_screen.dart';
import 'package:blinkit_clone/screen/home/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// New User Home Screen

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    // Obx observes both firebaseUser and currentUser.
    // It will rebuild when either the authentication state changes OR
    // when the UserModel (and thus role) is fetched/updated.
    return Obx(() {
      // If there's no Firebase user (not authenticated)
      if (authController.firebaseUser.value == null) {
        return const LoginScreen();
      } else {
        // If there's a Firebase user, but their custom data (like role) is still loading
        if (authController.currentUser.value == null) {
          // You could show a more specific loading screen here
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // User is logged in and their data is loaded. Route based on role.
          if (authController.currentUser.value!.role == 'admin') {
            return const AdminHomeScreen();
          } else {
            return const UserHomeScreen();
          }
        }
      }
    });
  }
}
