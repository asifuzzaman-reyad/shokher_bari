import 'package:flutter/material.dart';
import 'package:shokher_bari/models/product.dart';
import 'package:shokher_bari/provider/cart_provider.dart';

import '/constrains.dart';

//
class CartCard extends StatefulWidget {
  const CartCard({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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

                          // removeFromCart
                          GestureDetector(
                            onTap: () async {
                              //removeFromCart
                              CartProvider.removeFromCart(
                                  id: widget.product.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 18,
                              ),
                            ),
                          ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // price
                      Row(
                        children: [
                          // sale price
                          Text(
                            '$kTk ${widget.product.price}',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),

                          const SizedBox(width: 8),

                          // regular price
                          Text(
                            '$kTk ${widget.product.price + 20}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),

                      // qty
                      Row(
                        children: [
                          // remove
                          GestureDetector(
                              onTap: () {
                                //removeQuantity
                                CartProvider.removeQuantity(
                                  id: widget.product.id,
                                  quantity: widget.product.quantity,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: const Icon(
                                  Icons.remove,
                                  size: 20,
                                ),
                              )),

                          // qty text
                          Container(
                            constraints: const BoxConstraints(minWidth: 32),
                            alignment: Alignment.center,
                            child: Text(
                              '${widget.product.quantity}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          //add
                          GestureDetector(
                            onTap: () {
                              //addQuantity
                              CartProvider.addQuantity(
                                id: widget.product.id,
                                quantity: widget.product.quantity,
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
