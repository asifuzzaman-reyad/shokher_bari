import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';
import 'package:uuid/uuid.dart';

class CategoryProvider {
  //refCategory
  static final refCategory = MyRepo.ref.collection('Category');

  // addCategory
  static addCategory(
      {required String uid,
      required String categoryName,
      required String imageUrl}) {
    String id = const Uuid().v1();

    //
    refCategory.doc(id).set({
      'name': categoryName,
      'image': imageUrl,
    }).then((value) {
      Fluttertoast.showToast(msg: 'Upload category successfully');
    });
  }

  //removeFromCategory
  static removeFromCategory({required String id}) async {
    await CategoryProvider.refCategory.doc(id).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from category');
    });
  }

  //removeCategoryImage
  static removeCategoryImage({required String imageUrl}) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }
}
