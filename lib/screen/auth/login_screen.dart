import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

import 'registration_screen.dart'; // Import custom colors


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Get the AuthController instance
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      authController.loginUser(email, password); // Call login method from controller
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding_24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.network(
                  'https://placehold.co/150x150/FF6F00/FFFFFF?text=Blinkit',
                  height: AppSizes.image_height_150,
                  width: AppSizes.image_height_150,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.shopping_cart, size: AppSizes.icon_size_100, color: AppColors.primaryColor),
                ),
                const SizedBox(height: AppSizes.space_32),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.space_20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.space_30),

                Obx(() => // Obx observes the isLoading variable
                   ElevatedButton(
                    onPressed: authController.isLoading.value ? null : _loginUser, // Disable button while loading
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white) // Show loader
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: AppSizes.space_20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: AppSizes.font_16),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const RegistrationScreen()); // Use Get.to for navigation
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: AppSizes.font_16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}