import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String name;
  String description;
  double price;
  String imageUrl;
  String categoryId; // Reference to CategoryModel
  int stockQuantity;
  bool isAvailable;
  // Add more fields as needed, e.g., weight, unit (kg, piece), brand etc.

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.stockQuantity,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
    };
  }

  factory ProductModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw StateError('Product document data is null for doc ID: ${doc.id}');
    }
    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      stockQuantity: (data['stockQuantity'] as num?)?.toInt() ?? 0,
      isAvailable: data['isAvailable'] as bool? ?? true,
    );
  }
}