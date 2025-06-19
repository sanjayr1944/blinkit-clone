import 'package:blinkit_clone/constants/app_colors.dart';
import 'package:blinkit_clone/constants/app_sizes.dart';
import 'package:blinkit_clone/controllers/category_controller.dart';
import 'package:blinkit_clone/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // For category image URL

  CategoryModel? _editingCategory; // Keep track of the category being edited

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _imageUrlController.clear();
    setState(() {
      _editingCategory = null;
    });
  }

  void _submitCategory() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final name = _nameController.text.trim();
      final imageUrl = _imageUrlController.text.trim();

      if (_editingCategory == null) {
        // Add new category
        categoryController.addCategory(name: name, imageUrl: imageUrl);
      } else {
        // Update existing category
        _editingCategory!.name = name;
        _editingCategory!.imageUrl = imageUrl;
        categoryController.updateCategory(_editingCategory!);
      }
      _clearForm();
      Get.back(); // Pop the dialog
    }
  }

  void _showCategoryForm({CategoryModel? category}) {
    _clearForm(); // Clear form before showing for new entry or edit
    if (category != null) {
      _editingCategory = category;
      _nameController.text = category.name;
      _imageUrlController.text = category.imageUrl;
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
                    _editingCategory == null ? 'Add New Category' : 'Edit Category',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Category Name'),
                    validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  const SizedBox(height: AppSizes.space_20),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL (Optional)',
                      hintText: 'e.g., https://example.com/image.png',
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: AppSizes.space_30),
                  categoryController.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitCategory,
                          child: Text(_editingCategory == null ? 'Add Category' : 'Update Category'),
                        ),
                  const SizedBox(height: AppSizes.space_10),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      _clearForm();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showDeleteConfirmation(String categoryId) {
    Get.defaultDialog(
      title: 'Delete Category',
      middleText: 'Are you sure you want to delete this category?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.errorColor,
      cancelTextColor: AppColors.textPrimary,
      onConfirm: () {
        categoryController.deleteCategory(categoryId);
        Get.back(); // Close dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryForm(), // Show form to add new category
          ),
        ],
      ),
      body: Obx(
        () {
          if (categoryController.isLoading.value && categoryController.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (categoryController.categories.isEmpty) {
            return const Center(child: Text('No categories found. Add a new one!'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.padding_10),
              itemCount: categoryController.categories.length,
              itemBuilder: (context, index) {
                final category = categoryController.categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.margin_10),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.padding_15),
                    child: Row(
                      children: [
                        // Category Image/Icon
                        category.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(AppSizes.radius_8),
                                child: Image.network(
                                  category.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 50, color: AppColors.borderColor),
                                ),
                              )
                            : const Icon(Icons.folder, size: 60, color: AppColors.accentColor),
                        const SizedBox(width: AppSizes.space_10),
                        // Category Name
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.font_18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Action Buttons
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                              onPressed: () => _showCategoryForm(category: category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.errorColor),
                              onPressed: () => _showDeleteConfirmation(category.id!),
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