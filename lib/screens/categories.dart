import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/screens/admin/provider_admin/category_provider.dart';
import 'package:shokher_bari/screens/category/product_category.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Text('Categories',
                    style: Theme.of(context).textTheme.headline6),
              ),

              // categories
              SizedBox(
                height: 140,
                child: StreamBuilder<QuerySnapshot>(
                    stream: CategoryProvider.refCategory.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var data = snapshot.data!.docs;

                      if (data.isEmpty) {
                        return const Center(child: Text("No category found"));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductCategory(
                                        category: data[index].get('name'))));
                          },
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(8),
                            // color: Colors.yellow,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade200,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          data[index].get('image'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //

                                const SizedBox(height: 8),
                                //
                                FittedBox(
                                    child: Text(
                                  '${data[index].get('name')}'.toUpperCase(),
                                )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        });
  }
}
