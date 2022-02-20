import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';
import 'package:shokher_bari/models/product.dart';

import 'cart_provider.dart';

class OrderItem {
  final String id;
  final int total;
  final List<Product> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.total,
    required this.products,
    required this.dateTime,
  });
}

//
class OrderProvider {
  static final refOrder =
      MyRepo.ref.collection('Order').doc('Users').collection(MyRepo.userEmail);

  // addToOrder
  static addToOrder({
    required String uid,
    required int total,
    required List cartList,
    required List idList,
  }) async {
    await refOrder.doc(uid).set({
      'uid': uid,
      'total': total,
      'payment': 'Unpaid',
      'status': 'Pending',
      'time': DateTime.now(),
      'products': cartList,
    }).then((value) {
      //
      for (var id in idList) {
        //remove from cart using product id
        CartProvider.removeFromCart(id: id, disAbleToast: true);
      }

      //
      Fluttertoast.showToast(msg: 'Add to order');
    });
  }

  //deleteFrom order
  static removeFromOrder({required String uid}) async {
    await refOrder.doc(uid).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from order');
    });
  }
}
