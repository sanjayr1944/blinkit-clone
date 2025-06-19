import 'package:blinkit_clone/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // For SnackBar and loading indicator

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null); // Observable for our custom UserModel

  @override
  void onInit() {
    super.onInit();
    // Bind firebaseUser to auth state changes
    firebaseUser.bindStream(_auth.authStateChanges());

    // Listen to changes in firebaseUser and fetch corresponding UserModel from Firestore
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user != null) {
      // If user is logged in, try to fetch their data from Firestore
      await _fetchUserData(user.uid);
    } else {
      currentUser.value = null; // Clear current user data if logged out
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        currentUser.value = UserModel.fromDocumentSnapshot(doc);
        print("Fetched user data for ${currentUser.value?.email}, role: ${currentUser.value?.role}");
      } else {
        // This case should ideally not happen if user data is saved on registration
        print("User data not found for UID: $uid");
        // Optionally, force logout or handle error
        await logout();
      }
    } catch (e) {
      print("Error fetching user data: $e");
      Get.snackbar(
        'Error',
        'Failed to fetch user data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      await logout(); // Logout if user data cannot be fetched
    }
  }

  // --- User Registration ---
  Future<void> registerUser(String email, String password) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Save user data to Firestore upon successful registration
        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email,
          name: email.split('@')[0], // Basic name from email for now
          role: 'user', // Default role is 'user'
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
        currentUser.value = newUser; // Set the current user in the controller

        Get.snackbar(
          'Success',
          'Registration successful! You are now logged in.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      } else {
        errorMessage = 'Registration failed: ${e.message}';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- User Login ---
  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await _fetchUserData(user.uid); // Fetch user data after successful login
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- User Logout ---
  Future<void> logout() async {
    await _auth.signOut();
    currentUser.value = null; // Clear the current user model
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueGrey,
      colorText: Colors.white,
    );
  }
}