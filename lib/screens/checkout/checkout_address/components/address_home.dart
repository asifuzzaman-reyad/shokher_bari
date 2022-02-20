import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../models/address_book.dart';

class AddressHome extends StatefulWidget {
  const AddressHome({Key? key}) : super(key: key);

  @override
  _AddressHomeState createState() => _AddressHomeState();
}

class _AddressHomeState extends State<AddressHome> {
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          //
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
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

                const SizedBox(height: 8),

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

                const SizedBox(height: 8),

                // city
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(hintText: 'Room No'),
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter some text' : null,
                ),

                const SizedBox(height: 8),

                // room
                TextFormField(
                  controller: _regionController,
                  decoration: const InputDecoration(hintText: 'Hall'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter some text' : null,
                ),

                const SizedBox(height: 8),

                // area
                TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(hintText: 'Area'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter some text' : null,
                ),

                const SizedBox(height: 8),

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
                // buildAddressLabel(),
              ],
            ),
          ),

          // save
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                  onPressed: () {
                    if (_globalKey.currentState!.validate()) {
                      AddressBookHome _addressBook = AddressBookHome(
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
                          .doc()
                          .set(address)
                          .then(
                        (value) {
                          Fluttertoast.showToast(
                              msg: 'Add address successfully');

                          //
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  child: const Text('Save')),
            ),
          ),
        ],
      ),
    );
  }
}
