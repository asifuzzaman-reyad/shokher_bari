import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/constrains.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:shokher_bari/provider/cart_provider.dart';
import 'package:shokher_bari/provider/wishlist_provider.dart';

import 'cart/cart.dart';
import 'home/components/featured_product_home.dart';
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
                  height: 280,
                  child: Carousel(
                    autoplay: false,
                    dotIncreasedColor: Colors.red,
                    dotBgColor: Colors.grey.withOpacity(.5),
                    indicatorBgPadding: 10,
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
                          //subcategory
                          Text(
                            widget.product.subcategory,
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
                                  //offer price
                                  Text(
                                    '$kTk ${widget.product.offerPrice}',
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
                                  if ('${widget.product.regularPrice}'
                                      .isNotEmpty)
                                    Text(
                                      '$kTk ${widget.product.regularPrice}',
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
                                  stream: WishlistProvider.refWishlist
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
                                          //removeFromWishList
                                          WishlistProvider.removeFromWishList(
                                              id: widget.product.id);
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
                                        //addToWishList
                                        WishlistProvider.addToWishList(
                                            product: widget.product);
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
                        minHeight: 150,
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
                const FeaturedProductHome(),
              ],
            ),
          ),

          //
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.white,
            child: Row(
              children: [
                // buy now
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        // first => add to cart
                        CartProvider.addToCart(product: widget.product);

                        // then go to cart
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Cart()));
                      },
                      child: const Text('Buy Now'),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // add to cart
                StreamBuilder<DocumentSnapshot>(
                    stream:
                        CartProvider.refCart.doc(widget.product.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        //
                        return IconButton(
                          onPressed: () {},
                          icon: snapshot.hasData
                              ? const Icon(Icons.shopping_cart,
                                  color: Colors.red)
                              : const Icon(Icons.shopping_cart_outlined),
                        );
                      }

                      //
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4)),
                          child: IconButton(
                            onPressed: () {},
                            icon: snapshot.hasData
                                ? const Icon(Icons.shopping_cart,
                                    color: Colors.red)
                                : const Icon(Icons.shopping_cart_outlined),
                          ),
                        );
                      }

                      //
                      if (snapshot.data!.exists) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4)),
                          child: IconButton(
                            onPressed: () {
                              //remove from cart
                              CartProvider.removeFromCart(
                                  id: widget.product.id);
                            },
                            icon: const Icon(Icons.shopping_cart,
                                color: Colors.red),
                          ),
                        );
                      }

                      //
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4)),
                        child: IconButton(
                          onPressed: () async {
                            //add to cart
                            CartProvider.addToCart(product: widget.product);
                          },
                          icon: const Icon(Icons.shopping_cart_outlined),
                        ),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
