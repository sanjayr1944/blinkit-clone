import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/category_controller.dart';
import 'package:blinkit_clone/controllers/product_controller.dart';
import 'package:blinkit_clone/models/category_model.dart';
import 'package:blinkit_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  XFile? _pickedImage;
  String? _selectedCategoryId; // For dropdown
  ProductModel? _editingProduct; // Keep track of the product being edited

  @override
  void initState() {
    super.initState();
    // Ensure categories are fetched when this screen initializes
    categoryController.fetchCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedFile;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    setState(() {
      _pickedImage = null;
      _selectedCategoryId = null;
      _editingProduct = null;
    });
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final price = double.parse(_priceController.text.trim());
      final stockQuantity = int.parse(_stockController.text.trim());

      if (_selectedCategoryId == null) {
        Get.snackbar(
          'Error',
          'Please select a category.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        return;
      }

      if (_editingProduct == null) {
        // Add new product
        productController.addProduct(
          name: name,
          description: description,
          price: price,
          categoryId: _selectedCategoryId!,
          stockQuantity: stockQuantity,
          imageFile: _pickedImage,
        );
      } else {
        // Update existing product
        _editingProduct!.name = name;
        _editingProduct!.description = description;
        _editingProduct!.price = price;
        _editingProduct!.categoryId = _selectedCategoryId!;
        _editingProduct!.stockQuantity = stockQuantity;
        productController.updateProduct(_editingProduct!, newImageFile: _pickedImage);
      }
      _clearForm();
      Get.back(); // Pop the dialog
    }
  }

  void _showProductForm({ProductModel? product}) {
    _clearForm(); // Clear form before showing for new entry or edit
    if (product != null) {
      _editingProduct = product;
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _stockController.text = product.stockQuantity.toString();
      _selectedCategoryId = product.categoryId;
      // _pickedImage will remain null unless a new image is picked
      // The current image is loaded via NetworkImage in the display
    }

    Get.bottomSheet(
      Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radius_15)),
          ),
          padding: const EdgeInsets.all(AppSizes.padding_24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _editingProduct == null ? 'Add New Product' : 'Edit Product',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Product Name'),
                    validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                    validator: (value) {
                      if (value!.isEmpty) return 'Price cannot be empty';
                      if (double.tryParse(value) == null) return 'Invalid price';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Stock Quantity'),
                    validator: (value) {
                      if (value!.isEmpty) return 'Stock quantity cannot be empty';
                      if (int.tryParse(value) == null) return 'Invalid quantity';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categoryController.categories.map((CategoryModel category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategoryId = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  // Image Picker
                  Column(
                    children: [
                      _pickedImage != null
                          ? Image.file(
                              File(_pickedImage!.path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : (_editingProduct != null && _editingProduct!.imageUrl!.isNotEmpty
                              ? Image.network(
                                  _editingProduct!.imageUrl!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported, size: 80, color: AppColors.borderColor),
                                )
                              : const Icon(Icons.image, size: 80, color: AppColors.borderColor)),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Pick Image'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.space_30),
                  productController.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitProduct,
                          child: Text(_editingProduct == null ? 'Add Product' : 'Update Product'),
                        ),
                  const SizedBox(height: AppSizes.space_10),
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close the bottom sheet
                      _clearForm(); // Clear form on close
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true, // Allows content to be scrollable
    );
  }

  void _showDeleteConfirmation(String productId) {
    Get.defaultDialog(
      title: 'Delete Product',
      middleText: 'Are you sure you want to delete this product?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.errorColor,
      cancelTextColor: AppColors.textPrimary,
      onConfirm: () {
        productController.deleteProduct(productId);
        Get.back(); // Close dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductForm(), // Show form to add new product
          ),
        ],
      ),
      body: Obx(
        () {
          if (productController.isLoading.value && productController.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (productController.products.isEmpty) {
            return const Center(child: Text('No products found. Add a new one!'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.padding_10),
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.margin_10),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.padding_15),
                    child: Row(
                      children: [
                        // Product Image
                        product.imageUrl != null && product.imageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(AppSizes.radius_8),
                                child: Image.network(
                                  product.imageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported, size: 60, color: AppColors.borderColor),
                                ),
                              )
                            : const Icon(Icons.image, size: 80, color: AppColors.borderColor),
                        const SizedBox(width: AppSizes.space_10),
                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.font_18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Price: ₹${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: AppSizes.font_16),
                              ),
                              Text(
                                'Stock: ${product.stockQuantity}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: AppSizes.font_14),
                              ),
                              Obx(() {
                                // Find category name
                                final category = categoryController.categories
                                    .firstWhereOrNull((cat) => cat.id == product.categoryId);
                                return Text(
                                  'Category: ${category?.name ?? 'Unknown'}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: AppSizes.font_14),
                                );
                              }),
                            ],
                          ),
                        ),
                        // Action Buttons
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                              onPressed: () => _showProductForm(product: product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.errorColor),
                              onPressed: () => _showDeleteConfirmation(product.id!),
                            ),
                          ],
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
    );
  }
}
