import 'package:flutter/material.dart';
import 'package:shokher_bari/screens/admin/add_brand.dart';
import 'package:shokher_bari/screens/admin/add_category.dart';
import 'package:shokher_bari/screens/admin/manage_orders.dart';

import 'add_product.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    String message = '';

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddCategory()));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddProduct()));
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
          //
        ],
      ),
    );
  }
}
