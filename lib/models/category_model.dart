import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  String name;
  String imageUrl; // Optional: for category icons/images

  CategoryModel({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory CategoryModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw StateError('Category document data is null for doc ID: ${doc.id}');
    }
    return CategoryModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }
}
