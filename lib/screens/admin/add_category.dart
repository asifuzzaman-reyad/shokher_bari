import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? selectedImage;
  bool isUpload = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Category Name',
                label: Text('Category Name'),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'Enter category name' : null,
            ),

            const SizedBox(height: 16),

            //
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                //
                selectedImage == null
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Text('No image selected'),
                      )
                    : SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),

                //
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: FloatingActionButton(
                    onPressed: () async {
                      addImage();
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            //
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) {
                    if (selectedImage == null) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'No image selected');
                    } else {
                      String categoryName = _nameController.text.trim();
                      //
                      setState(() => isUpload = true);
                      await uploadImage(categoryName);
                      setState(() => isUpload = false);
                    }
                  }
                },
                child: isUpload
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text('Add Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //add image
  addImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  //upload image
  uploadImage(categoryName) async {
    String id = const Uuid().v1();

    //
    var ref = FirebaseStorage.instance
        .ref('Categories')
        .child(categoryName)
        .child('$id.jpg');
    //
    await ref.putFile(selectedImage!).whenComplete(() async {
      var imageUrl = await ref.getDownloadURL();

      // add category
      await Product.addCategory(id, categoryName, imageUrl);
      Navigator.pop(context);
    });
  }
}

class AllCategory extends StatelessWidget {
  const AllCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Category'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: Product.refCategory.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No product found'));
            }

            return ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CategoryDetails(data: data[index])));
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      leading: SizedBox(
                        width: 80,
                        child: Image.network(
                          data[index].get('image'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data[index].get('name')),
                          IconButton(
                            onPressed: () {
                              Product.refCategory
                                  .doc(data[index].id)
                                  .delete()
                                  .then((value) {
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(
                                    msg: 'Remove from category');
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.get('name')),
      ),

      //
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('All Brand')
              .doc('Brand')
              .collection(data.get('name'))
              .get(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: snapshot.data!.docs
                      .map((item) => Card(
                            child: ListTile(
                              title: Text(item.get('name')),
                            ),
                          ))
                      .toList()),
            );
          }),
    );
  }
}
