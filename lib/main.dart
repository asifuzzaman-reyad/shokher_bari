import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:shokher_bari/constrains.dart';
import 'package:shokher_bari/screens/dashboard/dashboard.dart';

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
    return MaterialApp(
      title: kAppName,
      theme: buildThemeData(),
      home: const UserAuthScreen(),
    );
  }

  //
  ThemeData buildThemeData() {
    return ThemeData(
      // primarySwatch: Colors.red,
      fontFamily: 'poppins',
      appBarTheme: const AppBarTheme(
        elevation: 0.1,
        centerTitle: true,
      ),
      // scaffoldBackgroundColor: Colors.yellow,
      scaffoldBackgroundColor: const Color(0xFFF6FBFF),
      inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
    );
  }
}

// auth
class UserAuthScreen extends StatelessWidget {
  const UserAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //sign in
            return const Dashboard();
          } else {
            //is not sign in
            return SignInScreen(
                headerBuilder: (context, constraints, _) {
                  return Center(
                    child: Text(
                      'Welcome to ' + kAppName,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  );
                },
                providerConfigs: const [
                  EmailProviderConfiguration(),
                ]);
          }
        });
  }
}
