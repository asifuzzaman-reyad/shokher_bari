import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  late int _isSelected = 0;
  String? _selectedCategory;
  String? _selectedBrand;
  String id = const Uuid().v1();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  final List<String> _categoryList = [
    "Food",
    "Bazar",
    "Stationary",
  ];
  final List<String> _brandList = [
    "Matedor",
    "Rfl",
    "Pran",
  ];

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  int _uploadItem = 0;
  bool _isUploadLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),

      //
      body: _isUploadLoading
          ? showLoading()
          : Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // list
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      children: [
                        //category, brand
                        Row(
                          children: [
                            //category
                            Flexible(
                              child: DropdownButtonFormField(
                                hint: const Text('Category'),
                                items: _categoryList
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item, child: Text(item)))
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(width: 8),

                            //category
                            Flexible(
                              child: DropdownButtonFormField(
                                hint: const Text('Brand'),
                                items: _brandList
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item, child: Text(item)))
                                    .toList(),
                                onChanged: (String? value) {
                                  _selectedBrand = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        // brand

                        const SizedBox(height: 8),

                        // name
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Product Name',
                            label: Text('Product Name'),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter product name' : null,
                        ),

                        const SizedBox(height: 8),

                        // description
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Product Description',
                            label: Text('Product Description'),
                          ),
                          minLines: 4,
                          maxLines: 12,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) => value!.isEmpty
                              ? 'Enter product description'
                              : null,
                        ),

                        const SizedBox(height: 8),

                        // price, quantity
                        Row(
                          children: [
                            // price
                            Flexible(
                              child: TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  hintText: 'Price',
                                  label: Text('Price'),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter price' : null,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // quantity
                            Flexible(
                              child: TextFormField(
                                controller: _quantityController,
                                decoration: const InputDecoration(
                                  hintText: 'Quantity',
                                  label: Text('Quantity'),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter quantity' : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // images
                        OutlinedButton.icon(
                            onPressed: () {
                              addImages();
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('Add Image'),
                            )),

                        const SizedBox(height: 8),

                        _selectedFiles.isEmpty
                            ? const Text(
                                'No Image Selected',
                                textAlign: TextAlign.center,
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: _selectedFiles.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) => Image.file(
                                  File(_selectedFiles[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),

                        const SizedBox(height: 8),

                        // featured, sale
                        Row(
                          children: [
                            // featured
                            Expanded(
                              child: RadioListTile<int>(
                                title: Text('Featured'.toUpperCase()),
                                value: 0,
                                groupValue: _isSelected,
                                onChanged: (value) =>
                                    setState(() => _isSelected = 0),
                              ),
                            ),

                            const SizedBox(width: 8),
                            // sale
                            Expanded(
                              child: RadioListTile<int>(
                                title: Text('Sale'.toUpperCase()),
                                value: 1,
                                groupValue: _isSelected,
                                onChanged: (value) =>
                                    setState(() => _isSelected = 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_globalKey.currentState!.validate() &&
                              _selectedCategory!.isNotEmpty &&
                              _selectedBrand!.isNotEmpty) {
                            if (_selectedFiles.isNotEmpty) {
                              //
                              uploadToFirebase();
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please Select Image');
                            }
                            // upload file
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please Select category/brand');
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Upload Product'),
                        )),
                  ),
                ],
              ),
            ),
    );
  }

  // add images
  Future<void> addImages() async {
    if (_selectedFiles.isNotEmpty) {
      _selectedFiles.clear();
    }

    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images! != null) {
        setState(() {
          _selectedFiles.addAll(images);
        });
        // print(_selectedFiles.length);
      }
    } catch (e) {
      print('something wrong$e');
    }
  }

  //loading
  Widget showLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LinearProgressIndicator(
            minHeight: 16,
            valueColor: const AlwaysStoppedAnimation(Colors.green),
            value: _uploadItem / (_selectedFiles.length),
          ),
        ),
        Text(
          'Uploading: $_uploadItem/${_selectedFiles.length}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // uploadImages
  Future uploadToFirebase() async {
    setState(() {
      _isUploadLoading = true;
    });

    var list = [];
    //
    for (var img in _selectedFiles) {
      Reference ref =
          FirebaseStorage.instance.ref('Products').child(id).child(img.name);

      //
      await ref.putFile(File(img.path)).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          list.add(value);
          setState(() {
            _uploadItem = list.length;
          });
        });
      });
    }

    //
    _uploadItem = 0;
    uploadToFirestore(list);
  }

  // uploadToFirestore
  uploadToFirestore(images) async {
    Product product = Product(
      category: _selectedCategory.toString(),
      brand: _selectedBrand.toString(),
      id: id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: int.parse(_priceController.text.trim()),
      quantity: int.parse(_quantityController.text.trim()),
      featured: _isSelected == 0 ? true : false,
      images: images,
    );
    await Product.addProduct(product, id).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Upload Product successfully');
      setState(() => _isUploadLoading = false);
    });
  }
}
