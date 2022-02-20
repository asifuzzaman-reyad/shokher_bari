import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/admin/screens/category/all_category_admin.dart';
import '/provider_admin/category_provider.dart';
import '/provider_admin/subcategory_provider.dart';

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
                        builder: (context) => const AllCategoryAdmin()));
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
                hintText: 'Subcategory',
                label: Text('Subcategory'),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'please enter subcategory' : null,
            ),

            const SizedBox(height: 16),

            //
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) {
                    setState(() => isUpload = true);
                    //
                    String subcategory = _nameController.text.trim();

                    //addBrand
                    await SubcategoryProvider.addSubcategory(
                        selectedCategory: _selectedCategory.toString(),
                        subcategory: subcategory);

                    setState(() => isUpload = false);
                    Navigator.pop(context);
                  }
                },
                child: isUpload
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text('Add Subcategory'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  getCategory() {
    CategoryProvider.refCategory
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
