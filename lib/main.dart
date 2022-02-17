import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shokher_bari/constrains.dart';
import 'package:shokher_bari/dashboard.dart';
import 'package:shokher_bari/provider/order_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MaterialApp(
        title: kAppName,
        theme: ThemeData(
          // primarySwatch: Colors.red,
          fontFamily: 'poppins',
          appBarTheme: const AppBarTheme(
            elevation: 0.1,
            centerTitle: true,
          ),
          // scaffoldBackgroundColor: Colors.yellow,
          // scaffoldBackgroundColor: const Color(0xFFF6FBFF),
          buttonTheme: const ButtonThemeData(alignedDropdown: true),
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder()),
        ),
        home: const Dashboard(),
      ),
    );
  }
}
