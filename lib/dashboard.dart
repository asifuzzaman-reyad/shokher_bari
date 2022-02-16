import 'package:flutter/material.dart';
import 'package:shokher_bari/screens/cart/cart.dart';
import 'package:shokher_bari/screens/favorite/favorite.dart';
import 'package:shokher_bari/screens/home/home.dart';
import 'package:shokher_bari/screens/orders/orders.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List _screen = [
    const Home(),
    const Favorite(),
    const Cart(),
    const Orders(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          //
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Orders',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      //
      body: _screen[_selectedIndex],
    );
  }
}
