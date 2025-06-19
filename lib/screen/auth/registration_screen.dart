import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX 

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Get the AuthController instance
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        Get.snackbar( // Use Get.snackbar for messages
          'Error',
          'Passwords do not match!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        return;
      }
      authController.registerUser(email, password); // Call register method from controller
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                  'https://placehold.co/150x150/FF6F00/FFFFFF?text=Register',
                  height: AppSizes.image_height_150,
                  width: AppSizes.image_height_150,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person_add, size: AppSizes.icon_size_100, color: AppColors.primaryColor),
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
                const SizedBox(height: AppSizes.space_20),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: Icon(Icons.lock_open, color: AppColors.primaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.space_30),

                Obx(() => // Obx observes the isLoading variable
                   ElevatedButton(
                    onPressed: authController.isLoading.value ? null : _registerUser, // Disable button while loading
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white) // Show loader
                        : const Text('Register'),
                  ),
                ),
                const SizedBox(height: AppSizes.space_20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: AppSizes.font_16),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(); // Use Get.back() to pop current screen
                      },
                      child: const Text(
                        'Login Here',
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