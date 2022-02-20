import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/product.dart';
import '/provider_admin/product_provider.dart';
import '/screens/all_featured_products.dart';
import '/widgets/product_card.dart';

class FeaturedProductHome extends StatelessWidget {
  const FeaturedProductHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Text('Featured products',
                    style: Theme.of(context).textTheme.headline6),
              ),

              //
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AllFeaturedProducts()));
                  },
                  child: const Text('see more >'))
            ],
          ),

          //
          SizedBox(
            height: 250,
            child: StreamBuilder<QuerySnapshot>(
                stream: ProductProvider.refProduct
                    .where('featured', isEqualTo: true)
                    .limit(12)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var data = snapshot.data!.docs;
                  if (data.isEmpty) {
                    return const Center(child: Text('No product found'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                    itemBuilder: (_, index) {
                      Product product = Product.fromSnapshot(data[index]);
                      return Row(
                        children: [
                          ProductCard(product: product),
                          const SizedBox(width: 10),
                        ],
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
