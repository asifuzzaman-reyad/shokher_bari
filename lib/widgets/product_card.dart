import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:shokher_bari/provider/wishlist_provider.dart';
import 'package:shokher_bari/screens/product_details.dart';

import '../provider/cart_provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetails(product: widget.product)));
      },
      child: Container(
        width: width * .42,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 2),
                spreadRadius: 1,
                blurRadius: 5,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  // image
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      minHeight: 150,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(widget.product.images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
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
            ),

            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // brand
                  Text(
                    widget.product.brand,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  // name
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // price
                      Text(
                        '\$ ${widget.product.price}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade500,
                        ),
                      ),

                      // add to cart
                      StreamBuilder<DocumentSnapshot>(
                          stream: CartProvider.refCart
                              .doc(widget.product.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            //
                            if (snapshot.hasError) {
                              return GestureDetector(
                                onTap: () {},
                                child: snapshot.hasData
                                    ? const Icon(Icons.shopping_cart,
                                        color: Colors.red)
                                    : const Icon(Icons.shopping_cart_outlined),
                              );
                            }

                            //
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return GestureDetector(
                                onTap: () {},
                                child: snapshot.hasData
                                    ? const Icon(Icons.shopping_cart,
                                        color: Colors.red)
                                    : const Icon(Icons.shopping_cart_outlined),
                              );
                            }

                            //
                            if (snapshot.data!.exists) {
                              return GestureDetector(
                                onTap: () {
                                  //remove from cart
                                  CartProvider.removeFromCart(
                                      id: widget.product.id);
                                },
                                child: const Icon(Icons.shopping_cart,
                                    color: Colors.red),
                              );
                            }

                            return GestureDetector(
                              onTap: () async {
                                //add to cart
                                CartProvider.addToCart(product: widget.product);
                              },
                              child: const Icon(Icons.shopping_cart_outlined),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
