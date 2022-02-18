import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/models/cart_product.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:shokher_bari/screens/checkout/checkout_address.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

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
              stream: Product.refOrder
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
                              title: const Text('Delete from orders'),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Product.deleteFromOrder(
                                            data[index].get('uid'));
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
                              //
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Order: ${data[index].get('uid')}'),
                                        Text(
                                            'Placed on: ${data[index].get('time').toDate()}'),
                                      ],
                                    ),

                                    // payment
                                    data[index].get('payment') == 'Unpaid'
                                        ? OutlinedButton(
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
                                            child: const Text(
                                              'Unpaid',
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Placed',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),

                              const Divider(),

                              //
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

                              //
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 2, 12, 10),
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
                                          '\$ ${data[index].get('total')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                color: Colors.red,
                                                fontSize: 17,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                fit: BoxFit.contain, image: NetworkImage(cartProduct.image)),
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
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //brand
                    Text(
                      cartProduct.brand,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                //name
                Text(
                  cartProduct.name,
                  // widget.product.get('name'),
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 5),

                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // price
                    Text(
                      '\$ ${cartProduct.price}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.red, fontSize: 17),
                    ),

                    const SizedBox(height: 4),
                    //item
                    Text('${cartProduct.quantity} x'),
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
