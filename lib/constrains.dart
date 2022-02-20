import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const kAppName = 'Shokher Bari';
const kTk = '৳';

class MyRepo {
  static User user = FirebaseAuth.instance.currentUser!;
  //user
  static String userEmail = user.email.toString();

  // firestore
  static final ref = FirebaseFirestore.instance;
}
