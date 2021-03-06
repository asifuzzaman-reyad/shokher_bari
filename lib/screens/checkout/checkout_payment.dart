import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shokher_bari/models/address_book.dart';
import 'package:shokher_bari/screens/checkout/checkour_payment_details.dart';

class CheckoutPayment extends StatelessWidget {
  const CheckoutPayment({
    Key? key,
    required this.address,
    required this.uid,
    required this.total,
  }) : super(key: key);

  final String uid;
  final int total;
  final AddressBook address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout (2/3)')),

      //
      body: Column(
        children: [
          // stepper
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: IconStepper(
                    enableNextPreviousButtons: false,
                    activeStepBorderWidth: 2,
                    stepColor: Colors.transparent,
                    activeStepColor: Colors.transparent,
                    activeStepBorderColor: Colors.transparent,
                    activeStepBorderPadding: 0,
                    lineColor: Colors.grey,
                    lineLength: 85,
                    lineDotRadius: 2,
                    icons: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.black87,
                      ),
                      const Icon(
                        Icons.adjust,
                        color: Colors.orange,
                      ),
                      Icon(
                        Icons.adjust,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Delivery address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Payment method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Order placed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Divider(),

          // select payment method
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                //
                const Text('Select a payment method'),

                const SizedBox(height: 16),

                //bkash
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CheckoutPaymentDetails(
                                  method: 'bkash',
                                  uid: uid,
                                  total: total,
                                  address: address,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // logo
                        Container(
                          child: Image.asset(
                            'assets/logo/bkash.jpg',
                            height: 32,
                            width: 56,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),

                        //name & sub
                        Text(
                          'BKash',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                //cash on delivery
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CheckoutPaymentDetails(
                                  method: 'cash',
                                  uid: uid,
                                  total: total,
                                  address: address,
                                )));
                    //
                    // FirebaseFirestore.instance
                    //     .collection('Payments')
                    //     .doc('Users')
                    //     .collection('asifreyad1@gmail.com')
                    //     .doc(uid)
                    //     .set({
                    //   'uid': uid,
                    //   'total': total,
                    //   'phone': '',
                    //   'transaction': '',
                    //   'message': '',
                    // }).then(
                    //   (value) {
                    //     Fluttertoast.showToast(
                    //         msg: 'Placed Order successfully');
                    //
                    //     // update order status
                    //     Product.refOrder.doc(uid).update({
                    //       'payment': 'Placed',
                    //     });

                    //
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => CheckoutOrder(uid: uid)));
                    // },
                    // );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // logo
                        Image.asset(
                          'assets/logo/kash.jpg',
                          height: 32,
                          width: 56,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),

                        //name & sub
                        Text(
                          'Cash On Delivery',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
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
                    Text('Free', style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),

                const Divider(),

                // total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      '\$ $total',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.red),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
