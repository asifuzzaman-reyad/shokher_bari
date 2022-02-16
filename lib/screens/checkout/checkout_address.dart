import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shokher_bari/models/address_book.dart';
import 'package:shokher_bari/screens/checkout/new_address.dart';

import 'checkout_payment.dart';

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
  var label = '';
  late AddressBook homeAddress;
  late AddressBook officeAddress;

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

                //
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const NewAddress()));
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Add New Address'),
                  ),
                ),

                const SizedBox(height: 16),

                // home
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc('asifreyad1@gmail.com')
                      .collection('Address')
                      .doc(Label.home.name)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Container());
                    }

                    if (snapshot.data!.id.isEmpty) {
                      return Container();
                    }

                    //
                    Map<String, Object?> data =
                        snapshot.data!.data() as Map<String, Object?>;
                    var user = AddressBook.fromJson(data);
                    homeAddress = user;

                    //
                    return Container(
                      constraints: const BoxConstraints(minHeight: 100),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    label = Label.home.name;
                                  });
                                },
                                child: Icon(
                                  label == Label.home.name
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked_rounded,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          //
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            user.phone,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.address,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            '${user.area}, ${user.city}, ${user.region}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc('asifreyad1@gmail.com')
                        .collection('Address')
                        .doc(Label.office.name)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Container());
                      }

                      if (snapshot.data!.id.isEmpty) {
                        return Container();
                      }

                      //
                      Map<String, Object?> data =
                          snapshot.data!.data() as Map<String, Object?>;
                      var user = AddressBook.fromJson(data);
                      officeAddress = user;

                      return Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.style,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),

                                //
                                Text(
                                  'Office'.toUpperCase(),
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
                                      label = Label.office.name;
                                    });
                                  },
                                  child: Icon(
                                    label == Label.office.name
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked_rounded,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            //
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              user.phone,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.address,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              '${user.area}, ${user.city}, ${user.region}',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      );
                    }),

                //
              ],
            ),
          ),

          //
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (label.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CheckoutPayment(
                                  uid: widget.uid,
                                  total: widget.total,
                                  address: label == Label.home.name
                                      ? homeAddress
                                      : officeAddress,
                                )));
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
