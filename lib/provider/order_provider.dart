import 'package:flutter/foundation.dart';
import 'package:shokher_bari/models/product.dart';

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

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  void addOrder(List<Product> cartProducts, int total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        total: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
