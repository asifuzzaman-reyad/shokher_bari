import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String category;
  final String subcategory;
  final String id;
  final String name;
  final String description;
  final int regularPrice;
  final int offerPrice;
  final int quantity;
  final bool featured;
  final List<dynamic> images;

  Product({
    required this.category,
    required this.subcategory,
    required this.id,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.offerPrice,
    required this.quantity,
    required this.featured,
    required this.images,
  });

  // upload
  Map<String, dynamic> toJson() => {
        'category': category,
        'subcategory': subcategory,
        'id': id,
        'name': name,
        'description': description,
        'regular_price': regularPrice,
        'offer_offer': offerPrice,
        'quantity': quantity,
        'featured': featured,
        'images': images,
      };

  // download
  static fromSnapshot(QueryDocumentSnapshot<Object?> json) => Product(
        category: json['category']! as String,
        subcategory: json['subcategory']! as String,
        id: json['id']! as String,
        name: json['name']! as String,
        description: json['description']! as String,
        regularPrice: json['regular_price']! as int,
        offerPrice: json['offer_offer']! as int,
        quantity: json['quantity']! as int,
        featured: json['featured']! as bool,
        images: json['images']! as List<dynamic>,
      );
}
