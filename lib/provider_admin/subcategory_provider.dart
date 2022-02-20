import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';

class SubcategoryProvider {
  // refAddress
  static final refSubcategory =
      MyRepo.ref.collection('Subcategory').doc('Category');

  static addSubcategory(
      {required String selectedCategory, required String subcategory}) async {
    await refSubcategory
        .collection(selectedCategory)
        .doc()
        .set({'name': subcategory}).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add subcategory successfully');
    });
  }
}
