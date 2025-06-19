import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  String productId;
  String productName;
  int quantity;
  double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OrderModel {
  String? id;
  String userId;
  List<OrderItem> items;
  double totalAmount;
  String status; // e.g., 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
  Timestamp orderDate; // Use Timestamp for dates in Firestore
  String deliveryAddress;
  String? paymentMethod;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(), // Convert list of OrderItem to list of Maps
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw StateError('Order document data is null for doc ID: ${doc.id}');
    }

    // Safely cast items list
    List<OrderItem> orderItems = [];
    if (data['items'] is List) {
      orderItems = (data['items'] as List)
          .map((itemJson) => OrderItem.fromJson(itemJson as Map<String, dynamic>))
          .toList();
    }

    return OrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      items: orderItems,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'pending',
      orderDate: data['orderDate'] as Timestamp? ?? Timestamp.now(),
      deliveryAddress: data['deliveryAddress'] as String? ?? '',
      paymentMethod: data['paymentMethod'] as String?,
    );
  }
}