import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/models/address_book.dart';

enum Label { home, office }

class NewAddress extends StatefulWidget {
  const NewAddress({Key? key}) : super(key: key);

  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  var label = Label.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            // name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Full Name'),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),

            // mobile
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Phone Number',
                counterText: "",
              ),
              keyboardType: TextInputType.number,
              maxLength: 11,
              validator: (value) => value!.isEmpty
                  ? 'Please enter some text'
                  : value.length < 11
                      ? 'Phone number must be 11 digits'
                      : null,
            ),

            // region
            TextFormField(
              controller: _regionController,
              decoration: const InputDecoration(hintText: 'Region'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),

            // city
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(hintText: 'City'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),

            // area
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(hintText: 'Area'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),

            // address
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Address'),
              keyboardType: TextInputType.streetAddress,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),

            const SizedBox(height: 16),

            // label
            Container(
              // color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  const Text('Select a label for effective delivery'),
                  const SizedBox(height: 12),

                  //
                  Row(
                    children: [
                      // home
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            label = Label.home;
                          });
                        },
                        label: Container(
                          constraints: const BoxConstraints(minWidth: 48),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text('Home'.toUpperCase(),
                              style: TextStyle(
                                  color: label == Label.home
                                      ? Colors.orange
                                      : Colors.grey,
                                  fontSize: 18)),
                        ),
                        icon: Icon(Icons.home,
                            color: label == Label.home
                                ? Colors.orange
                                : Colors.grey),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: label == Label.home
                                    ? Colors.orange
                                    : Colors.grey)),
                      ),

                      const SizedBox(width: 16),
                      // office
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            label = Label.office;
                          });
                        },
                        label: Container(
                          constraints: const BoxConstraints(minWidth: 56),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Office'.toUpperCase(),
                            style: TextStyle(
                                color: label == Label.office
                                    ? Colors.blue
                                    : Colors.grey,
                                fontSize: 18),
                          ),
                        ),
                        icon: Icon(Icons.style,
                            color: label == Label.office
                                ? Colors.blue
                                : Colors.grey),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: label == Label.office
                                    ? Colors.blue
                                    : Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            //
            ElevatedButton(
                onPressed: () {
                  if (_globalKey.currentState!.validate()) {
                    AddressBook _addressBook = AddressBook(
                      name: _nameController.text.trim(),
                      phone: _phoneController.text,
                      region: _regionController.text.trim(),
                      city: _cityController.text.trim(),
                      area: _areaController.text.trim(),
                      address: _addressController.text.trim(),
                    );
                    var address = _addressBook.toJson();

                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc('asifreyad1@gmail.com')
                        .collection('Address')
                        .doc(label.name)
                        .set(address)
                        .then(
                      (value) {
                        Fluttertoast.showToast(msg: 'Add address successfully');

                        //
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Save'),
                ))
          ],
        ),
      ),
    );
  }
}
