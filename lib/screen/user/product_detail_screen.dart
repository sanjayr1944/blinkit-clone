import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            product.imageUrl!.isNotEmpty
                ? Image.network(
                    product.imageUrl!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 150, color: AppColors.borderColor),
                  )
                : Image.network(
                    'https://placehold.co/250x250/CCCCCC/FFFFFF?text=No+Image',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.padding_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSizes.space_10),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: AppSizes.font_28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  Text(
                    'Description:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSizes.space_8),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  Text(
                    'Stock Available: ${product.stockQuantity}',
                    style: TextStyle(
                      fontSize: AppSizes.font_16,
                      color: product.stockQuantity > 0 ? AppColors.successColor : AppColors.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space_30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: product.stockQuantity > 0
                          ? () {
                              // TODO: Implement add to cart logic for detail screen
                              Get.snackbar('Add to Cart', '${product.name} added to cart!');
                            }
                          : null, // Disable button if out of stock
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(product.stockQuantity > 0 ? 'Add to Cart' : 'Out of Stock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product.stockQuantity > 0 ? AppColors.primaryColor : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
