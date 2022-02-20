import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/provider_admin/product_provider.dart';
import '../../../constrains.dart';
import '../../../models/product.dart';
import 'add_product.dart';

class AllProductAdmin extends StatelessWidget {
  const AllProductAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProduct()));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: ProductProvider.refProduct.snapshots(),
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
                  Product product = Product.fromSnapshot(data[index]);

                  //
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          //image
                          Expanded(
                            flex: 3,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 116,
                              ),
                              child: Image.network(
                                product.images[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // info
                          Expanded(
                            flex: 8,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                //
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 8, 8, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //category name
                                      Row(
                                        children: [
                                          //category
                                          Text(
                                            '${product.category} > ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),

                                          //subcategory
                                          Text(
                                            product.subcategory,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),

                                      //product name
                                      Text(
                                        product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),

                                      // price
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //price
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //offer price
                                              Text(
                                                '$kTk ${product.offerPrice}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),

                                              const SizedBox(width: 8),

                                              // regular price
                                              if ('${product.regularPrice}'
                                                  .isNotEmpty)
                                                Text(
                                                  '$kTk ${product.regularPrice}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      //product qty
                                      Row(
                                        children: [
                                          //qty title
                                          Text(
                                            'Qty:  ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),

                                          //qty
                                          Text(
                                            '${product.quantity}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                //remove product
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () async {
                                      var id = data[index].id;
                                      var images = data[index].get('images');

                                      //removeFromProduct
                                      await ProductProvider.removeProduct(
                                          id: id);

                                      //removeProductImage
                                      for (var imageUrl in images) {
                                        await ProductProvider
                                            .removeProductImage(
                                                imageUrl: imageUrl);
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            ),
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
