import 'package:blinkit_clone/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // For SnackBar


class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<CategoryModel> categories = <CategoryModel>[].obs; // Observable list of categories
  RxBool isLoading = false.obs; // Loading indicator for operations

  @override
  void onInit() {
    super.onInit();
    // Fetch categories automatically when the controller is initialized
    fetchCategories();
  }

  // --- Fetch Categories ---
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('categories').get();
      categories.value = snapshot.docs.map((doc) => CategoryModel.fromDocumentSnapshot(doc)).toList();
      print('Categories fetched: ${categories.length}');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- Add Category ---
  Future<void> addCategory({required String name, String imageUrl = ''}) async {
    isLoading.value = true;
    try {
      final newCategory = CategoryModel(name: name, imageUrl: imageUrl);
      final docRef = await _firestore.collection('categories').add(newCategory.toJson());
      newCategory.id = docRef.id; // Set the ID from Firestore
      categories.add(newCategory); // Add to the observable list

      Get.snackbar(
        'Success',
        'Category added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add category: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- Update Category ---
  Future<void> updateCategory(CategoryModel category) async {
    isLoading.value = true;
    try {
      await _firestore.collection('categories').doc(category.id).update(category.toJson());

      // Update the category in the local observable list
      final index = categories.indexWhere((cat) => cat.id == category.id);
      if (index != -1) {
        categories[index] = category; // Replace with the updated model
      }

      Get.snackbar(
        'Success',
        'Category updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update category: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- Delete Category ---
  Future<void> deleteCategory(String categoryId) async {
    isLoading.value = true;
    try {
      // Optional: Add logic to check if products are associated with this category
      // before deleting to prevent orphaned products or enforce category deletion restriction.

      await _firestore.collection('categories').doc(categoryId).delete();
      categories.removeWhere((cat) => cat.id == categoryId); // Remove from observable list

      Get.snackbar(
        'Success',
        'Category deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete category: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}