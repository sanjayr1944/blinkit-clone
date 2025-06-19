import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController()); // Get or create CartController

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 100, color: AppColors.borderColor),
                  const SizedBox(height: AppSizes.space_20),
                  Text(
                    'Your cart is empty!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Go back to browsing products
                    },
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.padding_10),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: AppSizes.margin_10),
                        elevation: AppSizes.elevation_2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radius_12)),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.padding_10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppSizes.radius_8),
                                child: item.product.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        item.product.imageUrl!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.image_not_supported, size: 60, color: AppColors.borderColor),
                                      )
                                    : Image.network(
                                        'https://placehold.co/80x80/CCCCCC/FFFFFF?text=No+Image',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: AppSizes.space_10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.font_16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSizes.space_8),
                                    Text(
                                      '\$${item.product.price.toStringAsFixed(2)} / item',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: AppSizes.font_14),
                                    ),
                                    Obx(() => Text(
                                      'Subtotal: \$${item.subtotal.toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.font_16),
                                    )),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryColor),
                                    onPressed: () => cartController.decreaseQuantity(item.product.id!),
                                  ),
                                  Obx(() => Text(
                                    '${item.quantity.value}',
                                    style: const TextStyle(fontSize: AppSizes.font_16, fontWeight: FontWeight.bold),
                                  )),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
                                    onPressed: () => cartController.increaseQuantity(item.product.id!),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: AppColors.errorColor),
                                onPressed: () => cartController.removeFromCart(item.product.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Cart Summary and Checkout Button
                Container(
                  padding: const EdgeInsets.all(AppSizes.padding_20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Items:', style: Theme.of(context).textTheme.bodyLarge),
                          Obx(() => Text('${cartController.totalItemsCount} items', style: Theme.of(context).textTheme.bodyLarge)),
                        ],
                      ),
                      const SizedBox(height: AppSizes.space_10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount:', style: Theme.of(context).textTheme.headlineSmall),
                          Obx(() => Text('\$${cartController.totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.primaryColor))),
                        ],
                      ),
                      const SizedBox(height: AppSizes.space_20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement checkout and order placement
                            Get.snackbar('Checkout', 'Proceeding to checkout... (Not yet implemented)');
                          },
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                      const SizedBox(height: AppSizes.space_10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            cartController.clearCart();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.errorColor),
                            foregroundColor: AppColors.errorColor,
                            padding: const EdgeInsets.symmetric(vertical: AppSizes.padding_15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radius_12),
                            ),
                            textStyle: const TextStyle(fontSize: AppSizes.font_18, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Clear Cart'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}