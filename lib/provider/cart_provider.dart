import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';

import '../models/product.dart';

class CartProvider {
  // refCart
  static final refCart =
      MyRepo.ref.collection('Cart').doc('Users').collection(MyRepo.userEmail);

  // addToCart
  static addToCart({required Product product}) async {
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
      Fluttertoast.showToast(msg: 'Add to cart');
    });
  }

  // removeFromCart
  static removeFromCart(
      {required String id, bool? disAbleToast = false}) async {
    await refCart.doc(id).delete().then((value) {
      if (disAbleToast == false) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Remove from cart');
      }
    });
  }

  //addQuantity
  static addQuantity({required String id, required int quantity}) async {
    await refCart.doc(id).update({'quantity': quantity + 1}).then((value) {});
  }

  //removeQuantity
  static removeQuantity({required String id, required int quantity}) async {
    if (quantity != 1) {
      await refCart.doc(id).update({'quantity': quantity - 1}).then((value) {});
    }
  }
}
