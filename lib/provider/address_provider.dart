import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';

class AddressProvider {
  // refAddress
  static final refAddress = MyRepo.ref
      .collection('Users')
      .doc(MyRepo.userEmail)
      .collection('Address');

  static addAddress(location, address) async {
    await refAddress.doc(location).set(address).then((value) {
      Fluttertoast.showToast(msg: 'Address add successfully');
    });
  }
}
