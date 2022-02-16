import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/product.dart';
import '../product_details.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        centerTitle: true,
        elevation: 0.1,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      // cart body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // cart product
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Product.refFavourite.snapshots(),
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
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (_, index) {
                      Product product = Product.fromSnapshot(data[index]);
                      return FavoriteCard(product: product);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

//
class FavoriteCard extends StatefulWidget {
  const FavoriteCard({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetails(product: widget.product)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //image
              Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                    color: Colors.pink.shade100.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.product.images[0]),
                    )),
              ),

              const SizedBox(width: 4),

              // title , price
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //brand
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product.brand,
                                style: const TextStyle(color: Colors.grey),
                              ),

                              // delete
                              GestureDetector(
                                  onTap: () async {
                                    await Product.refFavourite
                                        .doc(widget.product.id)
                                        .delete()
                                        .then((value) {
                                      Fluttertoast.cancel();
                                      Fluttertoast.showToast(
                                          msg: 'Delete successfully');
                                    });
                                  },
                                  child: const Icon(Icons.delete_outline,
                                      size: 18))
                            ],
                          ),

                          //name
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              widget.product.name,
                              maxLines: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // sale price
                      Row(
                        children: [
                          // sale price
                          Text(
                            '\$ ${widget.product.price}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.red),
                          ),

                          const SizedBox(width: 8),

                          // regular price
                          Text(
                            '\$ ${widget.product.price + 20}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                          ),
                        ],
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
  }
}
