import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:shokher_bari/screens/admin/provider_admin/product_provider.dart';
import 'package:shokher_bari/screens/all_products.dart';
import 'package:shokher_bari/widgets/product_card.dart';

class AllProductsHome extends StatelessWidget {
  const AllProductsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 250,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Text('All products',
                    style: Theme.of(context).textTheme.headline6),
              ),

              //
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AllProducts()));
                  },
                  child: const Text('see more >'))
            ],
          ),

          //
          Container(
            constraints: const BoxConstraints(
              minHeight: 200,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: ProductProvider.refProduct.limit(30).snapshots(),
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

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: .8,
                  ),
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemBuilder: (_, index) {
                    Product product = Product.fromSnapshot(data[index]);
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
