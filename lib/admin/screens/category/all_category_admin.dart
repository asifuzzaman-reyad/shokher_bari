import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/admin/screens/category/add_category.dart';
import '/provider_admin/category_provider.dart';

class AllCategoryAdmin extends StatelessWidget {
  const AllCategoryAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCategory()));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: CategoryProvider.refCategory.snapshots(),
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
                itemBuilder: (context, index) {
                  //
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Row(
                          children: [
                            //category image
                            Image.network(
                              data[index].get('image'),
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),

                            const SizedBox(width: 8),

                            //
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //category name
                                    Text(
                                      data[index].get('name'),
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),

                                    // remove category
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        onPressed: () async {
                                          var id = data[index].id;
                                          var imageUrl =
                                              data[index].get('image');

                                          //removeFromCategory
                                          await CategoryProvider
                                              .removeFromCategory(id: id);

                                          //removeCategoryImage
                                          CategoryProvider.removeCategoryImage(
                                              imageUrl: imageUrl);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

//
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
