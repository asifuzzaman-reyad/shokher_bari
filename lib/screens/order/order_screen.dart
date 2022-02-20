import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/models/cart_product.dart';
import 'package:shokher_bari/provider/order_provider.dart';
import 'package:shokher_bari/screens/checkout/checkout_address/checkout_address.dart';

import '../../constrains.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        elevation: 0.1,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      // order body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // cart product
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: OrderProvider.refOrder
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                CartProduct cartProduct;
                return ListView.builder(
                    itemCount: data.length,
                    padding: const EdgeInsets.all(4),
                    itemBuilder: (context, index) {
                      List products = data[index].get('products');

                      //
                      return GestureDetector(
                        onLongPress: () {
                          //
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete from order'),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        var uid = data[index].get('uid');

                                        //removeFromOrder
                                        OrderProvider.removeFromOrder(uid: uid);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),

                                    const SizedBox(width: 8),

                                    //
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },

                        //
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // order, placed on
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //
                                        Text(
                                            'Order: ${data[index].get('uid')}'),

                                        //
                                        Text(
                                          // 'Placed',
                                          data[index].get('payment'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(color: Colors.orange),
                                        ),
                                      ],
                                    ),

                                    //
                                    Text(
                                        'Placed on: ${data[index].get('time').toDate()}'),
                                  ],
                                ),
                              ),

                              const Divider(),

                              // cart product list
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: products.length,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                itemBuilder: (context, index) {
                                  CartProduct cartProduct =
                                      CartProduct.fromJson(products[index]);
                                  // print(cartProduct.name);
                                  return OrderCard(cartProduct: cartProduct);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              ),

                              const Divider(),

                              //status, items, total
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // status
                                    Container(
                                      decoration: BoxDecoration(
                                        color: data[index].get('status') ==
                                                'Pending'
                                            ? Colors.red
                                            : data[index].get('status') ==
                                                    'Processing'
                                                ? Colors.blue
                                                : Colors.green, // Cancelled
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        '${data[index].get('status')}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    //
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        //items
                                        Text('${products.length} items, '),

                                        //title
                                        const Text('Total:'),

                                        const SizedBox(width: 8),

                                        // total
                                        Text(
                                          '$kTk ${data[index].get('total')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),
                              const Divider(height: 4),

                              if (data[index].get('payment') == 'Unpaid')
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 4, 12, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // cancel
                                      OutlinedButton(
                                        onPressed: () {},
                                        child: const Text('Cancel'),
                                      ),

                                      const SizedBox(width: 8),
                                      //pay
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      CheckoutAddress(
                                                        uid: data[index]
                                                            .get('uid'),
                                                        total: data[index]
                                                            .get('total'),
                                                      )));
                                        },
                                        child: const Text('Pay Now'),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

//
class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.cartProduct}) : super(key: key);
  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //image
        Container(
          height: 88,
          width: 88,
          decoration: BoxDecoration(
            color: Colors.pink.shade100.withOpacity(.2),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(cartProduct.image),
            ),
          ),
        ),

        const SizedBox(width: 4),

        // title , price
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //name
                Text(cartProduct.name,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),

                const SizedBox(height: 5),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // price, qty
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        // price
                        Text(
                          '$kTk ${cartProduct.offerPrice}',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),

                        const SizedBox(width: 4),
                        //item
                        Text('x ${cartProduct.quantity}'),
                      ],
                    ),

                    // total
                    // price
                    Text(
                      '$kTk ${cartProduct.offerPrice * cartProduct.quantity}',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
