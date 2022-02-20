import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/provider_admin/category_provider.dart';
import '/screens/category/product_category.dart';

class CategoryHome extends StatelessWidget {
  const CategoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child:
              Text('Categories', style: Theme.of(context).textTheme.headline6),
        ),

        // categories
        SizedBox(
          height: 140,
          child: StreamBuilder<QuerySnapshot>(
              stream: CategoryProvider.refCategory.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  itemBuilder: (context, index) =>
                      categoryCard(context, data, index),
                );
              }),
        ),
      ],
    );
  }

  //categoryCard
  GestureDetector categoryCard(BuildContext context,
      List<QueryDocumentSnapshot<Object?>> data, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductCategory(category: data[index].get('name'))));
      },
      child: Container(
        width: 108,
        padding: const EdgeInsets.symmetric(vertical: 2),
        // color: Colors.yellow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //category image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 2))
                  ],
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

            //category name
            FittedBox(
              child: Text(
                '${data[index].get('name')}'.toUpperCase(),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
