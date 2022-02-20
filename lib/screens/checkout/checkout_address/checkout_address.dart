import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';

import '/models/address_book.dart';
import '/provider/address_provider.dart';
import '../checkout_payment/checkout_payment.dart';
import 'add_address.dart';

class CheckoutAddress extends StatefulWidget {
  const CheckoutAddress({
    Key? key,
    required this.uid,
    required this.total,
  }) : super(key: key);

  final String uid;
  final int total;

  @override
  State<CheckoutAddress> createState() => _CheckoutAddressState();
}

class _CheckoutAddressState extends State<CheckoutAddress> {
  String location = 'Hall';
  late AddressBookHall addressBookHall;
  late AddressBookHome addressBookHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout(1/2)')),

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
                        Icons.adjust,
                        color: Colors.orange,
                      ),
                      Icon(
                        Icons.adjust,
                        color: Colors.grey.shade500,
                      ),
                      Icon(
                        Icons.adjust,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Delivery address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Payment method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
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

          // select address
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Select Delivery Address'),

                const SizedBox(height: 16),

                // add new address
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AddAddress()));
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Add New Address'),
                  ),
                ),

                const SizedBox(height: 16),

                // hall
                StreamBuilder<DocumentSnapshot>(
                    stream: AddressProvider.refAddress.doc('Hall').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                          constraints: const BoxConstraints(minHeight: 100),
                        ));
                      }

                      if (!snapshot.data!.exists) {
                        return Container();
                      }

                      //
                      Map<String, Object?> data =
                          snapshot.data!.data() as Map<String, Object?>;
                      var user = AddressBookHall.fromJson(data);
                      addressBookHall = user;

                      return Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.account_balance,
                                  color: Colors.blue,
                                ),

                                const SizedBox(width: 8),

                                //
                                Text(
                                  'Hall'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: Colors.blue,
                                      ),
                                ),

                                const Spacer(),
                                //
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      location = 'Hall';
                                    });
                                  },
                                  child: Icon(
                                    location == 'Hall'
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked_rounded,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 10),
                            //
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: .5,
                                  ),
                            ),
                            Text(user.phone,
                                style: Theme.of(context).textTheme.subtitle2),
                            const SizedBox(height: 10),
                            Text(
                              'Room ${user.room}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              user.hall,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      );
                    }),

                const SizedBox(height: 8),

                // home
                StreamBuilder<DocumentSnapshot>(
                    stream: AddressProvider.refAddress.doc('Home').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                          constraints: const BoxConstraints(minHeight: 100),
                        ));
                      }

                      if (!snapshot.data!.exists) {
                        return Container();
                      }

                      //
                      Map<String, Object?> data =
                          snapshot.data!.data() as Map<String, Object?>;
                      var user = AddressBookHome.fromJson(data);
                      addressBookHome = user;

                      return Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.home,
                                  color: Colors.orange,
                                ),

                                const SizedBox(width: 8),

                                //
                                Text(
                                  'Home'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: Colors.orange,
                                      ),
                                ),

                                const Spacer(),
                                //
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      location = 'Home';
                                    });
                                  },
                                  child: Icon(
                                    location == 'Home'
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked_rounded,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 10),
                            //
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: .5,
                                  ),
                            ),
                            Text(user.phone,
                                style: Theme.of(context).textTheme.subtitle2),
                            const SizedBox(height: 10),
                            Text(
                              'Room ${user.address}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              '${user.area}, ${user.city}, ${user.division}.',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),

          //Proceed To Payment
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (location.isNotEmpty) {
                    if (location == 'Hall') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CheckoutPayment(
                                    uid: widget.uid,
                                    total: widget.total,
                                    location: location,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CheckoutPayment(
                                    uid: widget.uid,
                                    total: widget.total,
                                    location: location,
                                  )));
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'Please add/select address');
                  }
                },
                child: const Text('Proceed To Payment'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
