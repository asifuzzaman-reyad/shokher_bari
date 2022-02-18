import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

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

  static final ref = FirebaseFirestore.instance;
  static final refProduct = ref.collection('Products');
  static final refCategory = ref.collection('Category');
  static final refCarousel = ref.collection('Carousel');
  static final refCart =
      ref.collection('Cart').doc('Users').collection(Product.user);
  static final refFavourite =
      ref.collection('Favourite').doc('Users').collection(Product.user);
  static final refOrder =
      ref.collection('Orders').doc('Users').collection(Product.user);

  //
  static String user = 'asifreyad1@gmail.com';

  //
  static deleteProduct(id) {
    refProduct
        .doc(id)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: 'Deleted'));
  }

  // addToCart
  static addToCart(Product product) async {
    Product cartProduct = Product(
      category: product.category,
      brand: product.brand,
      id: product.id,
      name: product.name,
      description: '',
      price: product.price,
      quantity: 1,
      featured: false,
      images: [product.images[0]],
    );

    await refCart.doc(product.id).set(cartProduct.toJson()).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add to Cart');
    });
  }

  // deleteFromCart
  static deleteFromCart(String id) async {
    await Product.refCart.doc(id).delete().then((value) {});
  }

  // addToFavorite
  static addToFavorite(Product product) async {
    Product cartProduct = Product(
      category: product.category,
      brand: product.brand,
      id: product.id,
      name: product.name,
      description: '',
      price: product.price,
      quantity: 1,
      featured: false,
      images: [product.images[0]],
    );

    await refFavourite.doc(product.id).set(cartProduct.toJson()).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add to favorite');
    });
  }

  //deleteFromFavorite
  static deleteFromFavorite(Product product) async {
    await Product.refFavourite.doc(product.id).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from favorite');
    });
  }

  // addOrder
  static addToOrder(int total) async {
    String uid = const Uuid().v1();

    await ref
        .collection('Orders')
        .doc('Users')
        .collection(Product.user)
        .doc(uid)
        .set({
      'id': uid,
      'total': total,
      'status': 'To Pay',
      'products': [
        Product(
            category: 'category',
            brand: 'brand',
            id: 'id',
            name: 'name',
            description: 'description',
            price: 100,
            quantity: 1,
            featured: false,
            images: ['images'])
      ],
    }).then((value) {
      Fluttertoast.showToast(msg: 'Add to orders');
    });
  }

  //deleteFrom order
  static deleteFromOrder(uid) async {
    await Product.refOrder.doc(uid).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Delete from orders');
    });
  }

  // add product
  static addProduct(Product product, id) async {
    //
    await refProduct.doc(id).set(product.toJson());
  }

  // addCategory
  static addCategory(String id, String categoryName, String imageUrl) {
    String id = const Uuid().v1();

    //
    refCategory
        .doc(id)
        .set({'name': categoryName, 'image': imageUrl}).then((value) {
      Fluttertoast.showToast(msg: 'Upload category successfully');
    });
  }

  // addCarousel
  static addCarousel() {
    String id = const Uuid().v1();

    //
    refCarousel.doc(id).set({
      'name': '',
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHw%3D&w=1000&q=80',
    }).then((value) {
      Fluttertoast.showToast(msg: 'Upload category');
    });
  }
}
