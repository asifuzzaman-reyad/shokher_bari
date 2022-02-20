import 'package:flutter/material.dart';

import '/admin/admin.dart';
import '/constrains.dart';
import '/screens/home/components/banner_home.dart';
import '/screens/search/search.dart';
import 'components/all_products_home.dart';
import 'components/category_home.dart';
import 'components/featured_product_home.dart';

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
          CategoryHome(),

          // AllProductsHome
          FeaturedProductHome(),

          //AllProductsHome
          AllProductsHome(),
        ],
      ),
    );
  }
}
