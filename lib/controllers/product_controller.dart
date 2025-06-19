
import 'package:blinkit_clone/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // No longer directly using dart:io.File
import 'package:flutter/material.dart'; // For SnackBar

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxList<ProductModel> products = <ProductModel>[].obs; // Observable list of products
  RxBool isLoading = false.obs; // Loading indicator for operations

  @override
  void onInit() {
    super.onInit();
    // Fetch products automatically when the controller is initialized
    fetchProducts();
  }

  // --- Fetch Products ---
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('products').get();
      products.value = snapshot.docs.map((doc) => ProductModel.fromDocumentSnapshot(doc)).toList();
      print('Products fetched: ${products.length}');
    } catch (e) {
      print('Error fetching products: $e'); // Added detailed logging
      Get.snackbar(
        'Error',
        'Failed to fetch products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- Add Product ---
  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String categoryId,
    required int stockQuantity,
    XFile? imageFile, // Use XFile from image_picker
  }) async {
    isLoading.value = true;
    String? imageUrl;
    try {
      if (imageFile != null) {
        // Upload image to Firebase Storage
        final fileName = 'products/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
        final ref = _storage.ref().child(fileName);
        // Use putData with bytes from XFile for cross-platform compatibility
        await ref.putData(await imageFile.readAsBytes());
        imageUrl = await ref.getDownloadURL();
        print('Image uploaded: $imageUrl');
      }

      final newProduct = ProductModel(
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl ?? '', // Use uploaded URL or empty string
        categoryId: categoryId,
        stockQuantity: stockQuantity,
      );

      final docRef = await _firestore.collection('products').add(newProduct.toJson());
      newProduct.id = docRef.id; // Set the ID from Firestore
      products.add(newProduct); // Add to the observable list

      Get.snackbar(
        'Success',
        'Product added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error adding product: $e'); // Added detailed logging
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- Update Product ---
  Future<void> updateProduct(ProductModel product, {XFile? newImageFile}) async {
    isLoading.value = true;
    String? imageUrl = product.imageUrl; // Keep existing image URL by default
    try {
      if (newImageFile != null) {
        // Delete old image if exists and new image is provided
        if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
          try {
            await _storage.refFromURL(product.imageUrl!).delete();
            print('Old image deleted: ${product.imageUrl}');
          } catch (e) {
            print('Error deleting old image from storage: $e'); // Log error but don't stop update
          }
        }
        // Upload new image
        final fileName = 'products/${DateTime.now().millisecondsSinceEpoch}_${newImageFile.name}';
        final ref = _storage.ref().child(fileName);
        // Use putData with bytes from XFile for cross-platform compatibility
        await ref.putData(await newImageFile.readAsBytes());
        imageUrl = await ref.getDownloadURL();
        print('New image uploaded: $imageUrl');
      }

      final updatedData = product.toJson();
      updatedData['imageUrl'] = imageUrl; // Update imageUrl in data

      await _firestore.collection('products').doc(product.id).update(updatedData);

      // Update the product in the local observable list
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        product.imageUrl = imageUrl; // Update the model instance's image URL
        products[index] = product; // Replace with the updated model
      }

      Get.snackbar(
        'Success',
        'Product updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating product: $e'); // Added detailed logging
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- Delete Product ---
  Future<void> deleteProduct(String productId) async {
    isLoading.value = true;
    try {
      final productToDelete = products.firstWhereOrNull((p) => p.id == productId);

      // Delete image from storage if it exists
      if (productToDelete != null && productToDelete.imageUrl != null && productToDelete.imageUrl!.isNotEmpty) {
        try {
          await _storage.refFromURL(productToDelete.imageUrl!).delete();
          print('Image deleted from storage: ${productToDelete.imageUrl}');
        } catch (e) {
          print('Error deleting product image from storage: $e'); // Log but continue with document deletion
        }
      }

      await _firestore.collection('products').doc(productId).delete();
      products.removeWhere((p) => p.id == productId); // Remove from observable list

      Get.snackbar(
        'Success',
        'Product deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting product: $e'); // Added detailed logging
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
