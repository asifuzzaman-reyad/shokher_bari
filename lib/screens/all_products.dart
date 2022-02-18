import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:shokher_bari/widgets/product_card.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Products')),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: Product.refProduct.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .8,
              ),
              itemCount: data.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, index) {
                Product product = Product.fromSnapshot(data[index]);
                return ProductCard(product: product);
              },
            );
          }),
    );
  }
}
