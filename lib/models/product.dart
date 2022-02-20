import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String category;
  final String brand;
  final String id;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final bool featured;
  final List<dynamic> images;

  Product({
    required this.category,
    required this.brand,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.featured,
    required this.images,
  });

  // upload
  Map<String, dynamic> toJson() => {
        'category': category,
        'brand': brand,
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'featured': featured,
        'images': images,
      };

  // download
  static fromSnapshot(QueryDocumentSnapshot<Object?> json) => Product(
        category: json['category']! as String,
        brand: json['brand']! as String,
        id: json['id']! as String,
        name: json['name']! as String,
        description: json['description']! as String,
        price: json['price']! as int,
        quantity: json['quantity']! as int,
        featured: json['featured']! as bool,
        images: json['images']! as List<dynamic>,
      );
}
