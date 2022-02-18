import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/models/address_book.dart';
import 'package:shokher_bari/models/product.dart';

import '../../constrains.dart';
import 'checkout_order.dart';
import 'components/bkash.dart';

class CheckoutPaymentDetails extends StatelessWidget {
  const CheckoutPaymentDetails({
    Key? key,
    required this.method,
    required this.uid,
    required this.total,
    required this.address,
  }) : super(key: key);

  final String method;
  final String uid;
  final int total;
  final AddressBook address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(method),
      ),

      //
      body: Column(
        children: [
          //
          method == 'bkash'
              ? Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    children: [
                      //title
                      const Text(
                          'You should follow some steps to complete your payment.'),
                      const SizedBox(height: 8),
                      const Text('* Payment with App'),

                      //instruction
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('1. open Bkash App'),
                            Text('2. Select Send Money'),
                            Text('3. Enter Number: 01704340860'),
                            Text('4. Enter Amount'),
                            Text('5. Enter Pin to Confirm'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      //
                      const Text('Send Money to: '),
                      const SizedBox(height: 4),

                      // number
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                                  const ClipboardData(text: '01704340860'))
                              .then((value) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                content: Text('Copy to clipboard'),
                              ));
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.copy, size: 20),

                            SizedBox(width: 4),
                            //
                            Text(
                              '01704340860',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // total block
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(12),
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

                            // charge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '*Cash out charge ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                                Text(
                                  '$kTk ${(total * 0.02).toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red),
                                )
                              ],
                            ),

                            const Divider(),

                            // subtotal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  '$kTk $total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red),
                                )
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
                                  '$kTk ' +
                                      (total + (total * 0.02))
                                          .toStringAsFixed(0),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red,
                                      ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    children: [
                      //title
                      const Text('Cash on Delivery'),
                      const SizedBox(height: 8),
                      const Text('* Address'),

                      //address
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address.name),
                            Text(address.phone),
                            const SizedBox(height: 8),
                            Text('${address.address}, ${address.area}'),
                            Text('${address.city}, ${address.region}'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // total block
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(12),
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
                                  '$kTk $total',
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
                    ],
                  ),
                ),

          // confirm payment
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (method == 'bkash') {
                    //
                    showDialog(
                        context: context,
                        builder: (context) => Bkash(
                              method: method,
                              uid: uid,
                              total: int.parse(
                                  (total + (total * 0.02)).toStringAsFixed(0)),
                              address: address,
                            ));
                  } else {
                    //
                    FirebaseFirestore.instance
                        .collection('Payments')
                        .doc('Users')
                        .collection('asifreyad1@gmail.com')
                        .doc(uid)
                        .set({
                      'uid': uid,
                      'total': total,
                      'phone': '',
                      'transaction': '',
                      'message': '',
                      'method': method,
                    }).then(
                      (value) {
                        Fluttertoast.showToast(
                            msg: 'Placed Order successfully');

                        // update order status

                        Product.refOrder.doc(uid).update({
                          'payment': 'Placed',
                        });

                        //
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CheckoutOrder(uid: uid)),
                            (_) => false);
                      },
                    );
                  }
                },
                child: const Text('Confirm Payment'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
