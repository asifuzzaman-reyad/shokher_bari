import 'package:flutter/material.dart';
import 'package:shokher_bari/screens/admin/admin.dart';
import 'package:shokher_bari/screens/home/components/banner_home.dart';
import 'package:shokher_bari/screens/search/search.dart';

import '/constrains.dart';
import '/screens/categories.dart';
import 'components/all_products_home.dart';
import 'components/featured_products.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Admin()));
            },
            icon: const Icon(Icons.menu)),
        actions: [
          // search
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Search()));
              },
              icon: const Icon(Icons.search_outlined)),
        ],
      ),

      //
      body: ListView(
        shrinkWrap: true,
        children: const [
          // carousel
          BannerHome(),

          // category
          Categories(),

          // featured products
          FeaturedProducts(),

          //all products
          AllProductsHome(),
        ],
      ),
    );
  }
}
