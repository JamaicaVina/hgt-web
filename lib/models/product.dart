import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;

  // Constructor
  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  // Factory constructor to create Product from Firestore data (replace with your implementation)
  factory Product.fromFirestore(DocumentSnapshot doc) {
    return Product(
      id: doc.id,
      name: doc['p_name'] as String,
      imageUrl: doc['p_imgs'][0] as String,
      price: doc['p_price'] as String,
    );
  }
}
