import 'package:blinkit_clone/models/product_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // For SnackBar

class CartItem {
  ProductModel product;
  RxInt quantity; // Reactive quantity for immediate UI updates

  CartItem({required this.product, required int quantity}) : quantity = quantity.obs;

  double get subtotal => product.price * quantity.value;
}

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs; // Observable list of cart items

  // Total amount of items in the cart
  double get totalAmount => cartItems.fold(0.0, (sum, item) => sum + item.subtotal);

  // Total number of items (count, not quantity) in the cart
  int get totalItemsCount => cartItems.length;

  // Add a product to the cart
  void addToCart(ProductModel product) {
    final existingItemIndex = cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      // If product already in cart, increment quantity
      cartItems[existingItemIndex].quantity.value++;
      Get.snackbar(
        'Cart Updated',
        'Quantity of ${product.name} increased.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Add new product to cart
      cartItems.add(CartItem(product: product, quantity: 1));
      Get.snackbar(
        'Item Added',
        '${product.name} added to cart.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Remove a product from the cart
  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    Get.snackbar(
      'Item Removed',
      'Product removed from cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Increase quantity of a product in the cart
  void increaseQuantity(String productId) {
    final item = cartItems.firstWhereOrNull((item) => item.product.id == productId);
    if (item != null) {
      item.quantity.value++;
    }
  }

  // Decrease quantity of a product in the cart
  void decreaseQuantity(String productId) {
    final item = cartItems.firstWhereOrNull((item) => item.product.id == productId);
    if (item != null && item.quantity.value > 1) {
      item.quantity.value--;
    } else if (item != null && item.quantity.value == 1) {
      removeFromCart(productId); // Remove if quantity becomes 0
    }
  }

  // Clear the entire cart
  void clearCart() {
    cartItems.clear();
    Get.snackbar(
      'Cart Cleared',
      'All items removed from cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}