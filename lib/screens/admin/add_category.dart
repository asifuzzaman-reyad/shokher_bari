import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shokher_bari/models/product.dart';

class AddNew extends StatefulWidget {
  const AddNew({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      //
      body: // name
          Form(
        key: _globalKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
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

            const SizedBox(height: 16),

            //
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                //
                _image == null
                    ? Container(
                        height: 200,
                        color: Colors.green,
                      )
                    : Image.file(
                        _image!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),

                //
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FloatingActionButton.small(
                    onPressed: () async {
                      final image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image == null) return;
                      final tempImage = File(image.path);

                      setState(() {
                        _image = tempImage;
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            //
            ElevatedButton(
                onPressed: () {
                  if (_globalKey.currentState!.validate()) {
                    if (widget.title == 'Add Category') {
                      Product.addCategory(_nameController.text.trim());
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(widget.title),
                ))
          ],
        ),
      ),
    );
  }
}
