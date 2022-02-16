import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({Key? key}) : super(key: key);

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),

      //
      body: buildStreamBuilder(message),
    );
  }

  //
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder(message) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Payments')
            .doc('Users')
            .collection('asifreyad1@gmail.com')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var snap = snapshot.data!.docs;

          return ListView.separated(
              shrinkWrap: true,
              itemCount: snap.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                var data = snap[index];

                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice: ${data.get('uid')}'),
                      Row(
                        children: [
                          //
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total: ${data.get('total')}'),
                              Text('Phone: ${data.get('phone')}'),
                              Text('Transaction: ${data.get('transaction')}'),
                            ],
                          ),

                          const SizedBox(width: 8),

                          //
                          if (data.get('message').isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total: ${getTotal(data.get('message'))}'),
                                Text('Phone: ${getPhone(data.get('message'))}'),
                                Text(
                                    'Transaction: ${getTransaction(data.get('message'))}'),
                              ],
                            ),
                        ],
                      ),
                      // checkStatus(data),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //
                          checkStatus(data)
                              ? ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Confirm Now'))
                              : ElevatedButton(
                                  onPressed: () {
                                    //
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Upload Message'),
                                              content: TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'Paste message here',
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 8,
                                                  ),
                                                ),
                                                minLines: 5,
                                                maxLines: 8,
                                                onChanged: (newValue) {
                                                  message = newValue;
                                                },
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      //
                                                      if (message.isNotEmpty &&
                                                          message
                                                                  .split(' ')
                                                                  .length >=
                                                              18) {
                                                        //
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Payments')
                                                            .doc('Users')
                                                            .collection(
                                                                'asifreyad1@gmail.com')
                                                            .doc(
                                                                data.get('uid'))
                                                            .update({
                                                          'message': message
                                                        }).then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Please enter message first');
                                                      }
                                                    },
                                                    child: const Text('upload'))
                                              ],
                                            ));
                                  },
                                  child: const Text('verify')),

                          //
                          if ('${data.get('message')}'.isNotEmpty)
                            Chip(
                              label: Text(checkStatus(data)
                                  ? 'Verified'
                                  : 'Not verified'),
                              backgroundColor: checkStatus(data)
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 8));
        });
  }

  getTotal(String text) {
    if (text.isNotEmpty) {
      List line = text.split(' ');
      var total = double.parse(line[4]).toStringAsFixed(0);
      return total;
    }
  }

  getPhone(String text) {
    if (text.isNotEmpty) {
      List line = text.split(' ');
      var phoneString = line[6].toString();
      var phone = phoneString.substring(0, phoneString.length - 1);
      return phone;
    }
  }

  getTransaction(String text) {
    if (text.isNotEmpty) {
      List line = text.split(' ');
      var transaction = line.length > 18 ? line[16] : line[14];
      return transaction;
    }
  }

  checkStatus(QueryDocumentSnapshot data) {
    if (data.get('total').toString() ==
            getTotal(data.get('message').toString()) &&
        data.get('phone') == getPhone(data.get('message')) &&
        data.get('transaction') == getTransaction(data.get('message'))) {
      return true;
    } else {
      return false;
    }
  }
}
