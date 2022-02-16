import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/models/product.dart';

class BannerHome extends StatelessWidget {
  const BannerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: StreamBuilder<QuerySnapshot>(
        stream: Product.refCarousel.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return Container(
              height: 200,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.pink.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }

          return Carousel(
            dotPosition: DotPosition.bottomLeft,
            dotIncreasedColor: Colors.red,
            dotBgColor: Colors.transparent,
            // borderRadius: true,
            images: data
                .map(
                  (image) => Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(image.get('image')),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
