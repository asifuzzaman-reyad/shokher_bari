import 'package:flutter/material.dart';
import 'package:shokher_bari/screens/admin/add_brand.dart';
import 'package:shokher_bari/screens/admin/manage_orders.dart';
import 'package:shokher_bari/screens/admin/screens/banner/all_banner_admin.dart';
import 'package:shokher_bari/screens/admin/screens/category/all_category_admin.dart';
import 'package:shokher_bari/screens/admin/screens/product/all_product_admin.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // add category
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllCategoryAdmin()));
            },
            leading: const Icon(Icons.add),
            title: const Text('Add Category'),
          ),

          const Divider(),

          // add brand
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddBrand()));
            },
            leading: const Icon(Icons.add),
            title: const Text('Add Brand'),
          ),

          const Divider(),

          // add product
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllProductAdmin()));
            },
            leading: const Icon(Icons.add),
            title: const Text('Add Product'),
          ),

          const Divider(),

          // manage orders
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageOrders()));
            },
            leading: const Icon(Icons.add),
            title: const Text('Manage Orders'),
          ),

          const Divider(),

          // add banner
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllBannerAdmin()));
            },
            leading: const Icon(Icons.add),
            title: const Text('Add Banner'),
          ),
        ],
      ),
    );
  }
}
