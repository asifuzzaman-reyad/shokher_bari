import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/constrains.dart';
import 'package:shokher_bari/models/product.dart';

import 'cart/cart.dart';
import 'home/components/featured_products.dart';
import 'home/home.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: .1,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
            );
          },
          child: const Text(kAppName),
        ),
        actions: [
          // cart
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Cart()));
              },
              icon: const Icon(Icons.shopping_cart)),
        ],
      ),

      //
      body: Column(
        children: [
          //
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                // product image
                SizedBox(
                  height: 300,
                  child: Carousel(
                    autoplay: false,
                    dotIncreasedColor: Colors.red,
                    dotBgColor: Colors.grey.shade300,
                    indicatorBgPadding: 8,
                    images: widget.product.images
                        .map((image) => Image.network(
                              image,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 8),

                // product info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name & price
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //brand
                          Text(
                            widget.product.brand,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),

                          //name
                          Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),

                          const SizedBox(height: 8),

                          // price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //sale price
                                  Text(
                                    '\$ ${widget.product.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),

                                  const SizedBox(width: 8),

                                  // regular price
                                  Text(
                                    '\$ ${widget.product.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough),
                                  ),
                                ],
                              ),

                              // add to favorite
                              StreamBuilder<DocumentSnapshot>(
                                  stream: Product.refFavourite
                                      .doc(widget.product.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade300,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        margin: const EdgeInsets.all(6),
                                        child: snapshot.hasData
                                            ? const Icon(Icons.favorite_border,
                                                color: Colors.red, size: 20)
                                            : const Icon(
                                                Icons.favorite_border_rounded,
                                                size: 20,
                                              ),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade300,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        margin: const EdgeInsets.all(6),
                                        child: snapshot.hasData
                                            ? const Icon(Icons.favorite_border,
                                                color: Colors.red, size: 20)
                                            : const Icon(
                                                Icons.favorite_border_rounded,
                                                size: 20,
                                              ),
                                      );
                                    }

                                    if (snapshot.data!.exists) {
                                      return GestureDetector(
                                        onTap: () {
                                          Product.deleteFromFavorite(
                                              widget.product);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade300,
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          margin: const EdgeInsets.all(6),
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      );
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        Product.addToFavorite(widget.product);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade300,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        margin: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.favorite_border_rounded,
                                          size: 20,
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // product description
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title
                          Text('Product Description',
                              style: Theme.of(context).textTheme.subtitle2),

                          const SizedBox(height: 4),

                          //description
                          Text(widget.product.description,
                              style: Theme.of(context).textTheme.bodyText2!
                              // .copyWith(color: Colors.grey),
                              )
                        ],
                      ),
                    ),
                  ],
                ),

                // similar product
                const FeaturedProducts(),
              ],
            ),
          ),

          //
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.white,
            child: Row(
              children: [
                // add to cart
                StreamBuilder<DocumentSnapshot>(
                    stream: Product.refCart.doc(widget.product.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return IconButton(
                          onPressed: () {},
                          icon: snapshot.hasData
                              ? const Icon(Icons.shopping_cart,
                                  color: Colors.red)
                              : const Icon(Icons.shopping_cart_outlined),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return IconButton(
                          onPressed: () {},
                          icon: snapshot.hasData
                              ? const Icon(Icons.shopping_cart,
                                  color: Colors.red)
                              : const Icon(Icons.shopping_cart_outlined),
                        );
                      }

                      if (snapshot.data!.exists) {
                        return IconButton(
                          onPressed: () {
                            Product.deleteFromCart(widget.product.id);
                          },
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.red),
                        );
                      }

                      return IconButton(
                        onPressed: () async {
                          //add to cart
                          Product.addToCart(widget.product);
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                      );
                    }),

                const SizedBox(width: 8),

                // buy now
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        // first => add to cart
                        await Product.addToCart(widget.product);

                        // then go to cart
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Cart()));
                      },
                      child: const Text('Buy Now'),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
