import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              focusColor: Colors.white,
            ),
          ),
        ),
      ),

      //
      body: const Center(
        child: Text('search'),
      ),
    );
  }
}
