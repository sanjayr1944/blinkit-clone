import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid; // Firebase User ID
  String? email;
  String? name;
  String? role; // e.g., 'user', 'admin'
  String? phoneNumber;
  String? address;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.role,
    this.phoneNumber,
    this.address,
  });

  // Convert a UserModel object into a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // Create a UserModel object from a Firestore document snapshot
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>

    if (data == null) {
      throw StateError('User document data is null for doc ID: ${doc.id}');
    }

    return UserModel(
      uid: doc.id, // Document ID is the UID
      email: data['email'] as String?,
      name: data['name'] as String?,
      role: data['role'] as String? ?? 'user', // Default to 'user' if not specified
      phoneNumber: data['phoneNumber'] as String?,
      address: data['address'] as String?,
    );
  }

  // Create a UserModel object from a Map (e.g., from JSON decoding)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String? ?? 'user',
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
    );
  }
}