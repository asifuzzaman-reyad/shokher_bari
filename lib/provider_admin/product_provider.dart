import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';

import '/models/product.dart';

class ProductProvider {
  // ref products
  static final refProduct = MyRepo.ref.collection('Product');

  // addProduct
  static addProduct({required Product product, required String uid}) async {
    //
    await refProduct.doc(uid).set(product.toJson()).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Upload product successfully');
    });
  }

  //removeProduct
  static removeProduct({required String id}) {
    refProduct.doc(id).delete().then(
        (value) => Fluttertoast.showToast(msg: 'Delete product successfully'));
  }

  //removeProductImage
  static removeProductImage({required String imageUrl}) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete().then((value) {
      print('remove product images');
    });
  }
}
