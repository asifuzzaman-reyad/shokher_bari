import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/models/product.dart';

import 'add_category.dart';

class AddBrand extends StatefulWidget {
  const AddBrand({Key? key}) : super(key: key);

  @override
  State<AddBrand> createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  bool isUpload = false;

  List categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getBrands();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Brand'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllCategory()));
              },
              icon: const Icon(Icons.widgets_outlined)),
        ],
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            //category
            DropdownButtonFormField(
              hint: const Text('Category'),
              items: categories
                  .map((item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              validator: (value) =>
                  value == null ? 'please select a category' : null,
            ),

            const SizedBox(height: 16),
            // name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Brand Name',
                label: Text('Brand Name'),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'please enter brand name' : null,
            ),

            const SizedBox(height: 16),

            //
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) {
                    String brandName = _nameController.text.trim();

                    var ref = FirebaseFirestore.instance
                        .collection('All Brand')
                        .doc('Brand')
                        .collection(_selectedCategory.toString())
                        .doc();
                    //
                    setState(() => isUpload = true);

                    await ref.set({'name': brandName});

                    //
                    // await FirebaseFirestore.instance
                    //     .collection('Brands')
                    //     .doc()
                    //     .set({
                    //   'category': _selectedCategory,
                    //   'name': brandName,
                    // }).then((value) {
                    //   Fluttertoast.cancel();
                    //   Fluttertoast.showToast(msg: 'Brand add successfully');
                    // });

                    setState(() => isUpload = false);
                  }
                },
                child: isUpload
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text('Add Brand'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  getCategory() {
    Product.refCategory
        .orderBy('name')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var category = doc.get('name');
        setState(() {
          categories.add(category);
        });
      }
    });
  }
}
