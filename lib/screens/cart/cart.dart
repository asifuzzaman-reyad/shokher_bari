import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/models/cart_product.dart';
import 'package:shokher_bari/provider/order_provider.dart';
import 'package:shokher_bari/screens/checkout/checkout_address/checkout_address.dart';

import '/models/product.dart';
import '../../provider/cart_provider.dart';
import 'components/cart_card.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        elevation: 0.1,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      // cart body
      body: StreamBuilder<QuerySnapshot>(
          stream: CartProvider.refCart.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;
            if (data.isEmpty) {
              return const Center(child: Text('No product found'));
            }

            //
            int total = 0;
            var cartList = [];
            var idList = [];
            for (var doc in snapshot.data!.docs) {
              total += doc.get('price') * doc.get('quantity') as int;
              //
              idList.add(doc.get('id'));

              var cartProduct = CartProduct(
                id: doc.get('id'),
                brand: doc.get('brand'),
                name: doc.get('name'),
                price: doc.get('price'),
                quantity: doc.get('quantity'),
                image: doc.get('images')[0],
              );

              cartList.add(cartProduct.toJson());
              // print(cartList);
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (_, index) {
                      Product product = Product.fromSnapshot(data[index]);
                      return CartCard(product: product);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(height: 4),
                  ),
                ),

                // total & check out
                if (data.isNotEmpty)
                  Column(
                    children: [
                      //
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // delivery
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Delivery charge',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text('Free',
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),

                            const Divider(),

                            // total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  '\$ $total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      //
                      const SizedBox(height: 8),

                      // check out
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              //uid
                              String uid = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();

                              // addToOrder
                              OrderProvider.addToOrder(
                                uid: uid,
                                total: total,
                                cartList: cartList,
                                idList: idList,
                              ).then((value) {
                                // go to address screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CheckoutAddress(
                                            uid: uid, total: total)));
                              });
                            },
                            child: const Text('Checkout'),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          }),
    );
  }
}
