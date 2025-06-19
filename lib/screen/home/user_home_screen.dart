import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/auth_controller.dart';
import 'package:blinkit_clone/controllers/category_controller.dart';
import 'package:blinkit_clone/controllers/product_controller.dart';
import 'package:blinkit_clone/screen/user/cart_screen.dart';
import 'package:blinkit_clone/screen/user/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ProductController productController = Get.find<ProductController>();
    final CategoryController categoryController = Get.find<CategoryController>();

    final user = authController.currentUser.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blinkit App'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(() => const CartScreen()); // Navigate to Cart Screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: AppSizes.padding_30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: AppSizes.icon_size_30, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: AppSizes.space_10),
                  Text(
                    user?.name ?? user?.email ?? 'Guest User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.font_22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: AppSizes.font_14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Get.back(); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('My Orders'),
              onTap: () {
                Get.back(); // Close drawer
                Get.snackbar('Info', 'My Orders (Coming Soon!)');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Wishlist'),
              onTap: () {
                Get.back(); // Close drawer
                Get.snackbar('Info', 'Wishlist (Coming Soon!)');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Get.back(); // Close drawer
                Get.snackbar('Info', 'Settings (Coming Soon!)');
              },
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.errorColor),
              title: const Text('Logout', style: TextStyle(color: AppColors.errorColor)),
              onTap: () {
                authController.logout();
                Get.back(); // Close drawer
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            Padding(
              padding: const EdgeInsets.all(AppSizes.padding_15),
              child: Text('Categories', style: Theme.of(context).textTheme.headlineMedium),
            ),
            Obx(
              () {
                if (categoryController.isLoading.value && categoryController.categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (categoryController.categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.padding_15),
                    child: Text('No categories available yet.'),
                  );
                } else {
                  return SizedBox(
                    height: 120, // Height for horizontal category list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryController.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryController.categories[index];
                        return GestureDetector(
                          onTap: () {
                            // TODO: Filter products by category
                            Get.snackbar('Category Clicked', 'Tapped on ${category.name}');
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: AppSizes.margin_10, vertical: AppSizes.margin_5),
                            elevation: AppSizes.elevation_2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radius_12)),
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  category.imageUrl.isNotEmpty
                                      ? Image.network(
                                          category.imageUrl,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.folder_open, size: 50, color: AppColors.accentColor),
                                        )
                                      : const Icon(Icons.folder_open, size: 50, color: AppColors.accentColor),
                                  const SizedBox(height: AppSizes.space_8),
                                  Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: AppSizes.font_14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: AppSizes.space_20),

            // Products Section
            Padding(
              padding: const EdgeInsets.all(AppSizes.padding_15),
              child: Text('All Products', style: Theme.of(context).textTheme.headlineMedium),
            ),
            Obx(
              () {
                if (productController.isLoading.value && productController.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productController.products.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.padding_15),
                    child: Text('No products available yet. Please add some from admin panel.'),
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true, // Important for nested scroll views
                    physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                    padding: const EdgeInsets.all(AppSizes.padding_10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: AppSizes.space_10,
                      mainAxisSpacing: AppSizes.space_10,
                      childAspectRatio: 0.69, // Adjusted from 0.75 to 0.6 to fix overflow
                    ),
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      final product = productController.products[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ProductDetailScreen(product: product));
                        },
                        child: Card(
                          elevation: AppSizes.elevation_2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radius_12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radius_12)),
                                child: product.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        product.imageUrl!,
                                        height: 120, // Fixed height for product image
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.image_not_supported, size: 80, color: AppColors.borderColor),
                                      )
                                    : Image.network(
                                        'https://placehold.co/120x120/CCCCCC/FFFFFF?text=No+Image', // Placeholder for no image
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(AppSizes.padding_10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.font_16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSizes.space_8),
                                    Text(
                                      '₹${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: AppSizes.font_18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: AppSizes.space_8),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Obx(() => ElevatedButton(
                                        onPressed: productController.isLoading.value ? null : () {
                                          // TODO: Implement add to cart logic
                                          Get.snackbar('Add to Cart', '${product.name} added to cart!');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding_15, vertical: AppSizes.padding_8),
                                          minimumSize: Size.zero, // Important to constrain button size
                                        ),
                                        child: const Text('Add'),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}