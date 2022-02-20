class CartProduct {
  final String id;
  final String name;
  final int offerPrice;
  final int quantity;
  final String image;

  CartProduct({
    required this.id,
    required this.name,
    required this.offerPrice,
    required this.quantity,
    required this.image,
  });

  //fetch
  CartProduct.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
          offerPrice: json['offer_price']! as int,
          quantity: json['quantity']! as int,
          image: json['image']! as String,
        );

  // upload
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'offer_price': offerPrice,
      'quantity': quantity,
      'image': image,
    };
  }
}
