class CartProduct {
  final String id;
  final String brand;
  final String name;
  final int price;
  final int quantity;
  final String image;

  CartProduct({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  //fetch
  CartProduct.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          brand: json['brand']! as String,
          name: json['name']! as String,
          price: json['price']! as int,
          quantity: json['quantity']! as int,
          image: json['image']! as String,
        );

  // upload
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'brand': brand,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }
}
