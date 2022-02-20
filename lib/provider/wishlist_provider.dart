import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';

import '../models/product.dart';

class WishlistProvider {
  //refWishlist
  static final refWishlist = MyRepo.ref
      .collection('Wishlist')
      .doc('Users')
      .collection(MyRepo.userEmail);

  //addToWishList
  static addToWishList({required Product product}) async {
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

    await refWishlist.doc(product.id).set(cartProduct.toJson()).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add to wishList');
    });
  }

  //removeFromWishList
  static removeFromWishList({required String id}) async {
    await refWishlist.doc(id).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from wishList');
    });
  }
}
