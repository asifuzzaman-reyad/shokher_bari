import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/constrains.dart';

class BannerProvider {
  static final refBanner = MyRepo.ref.collection('Banner');

  // addBanner
  static addBanner({
    required String uid,
    required String bannerTitle,
    required String imageUrl,
  }) {
    //
    refBanner.doc(uid).set({
      'name': bannerTitle,
      'image': imageUrl,
    }).then((value) {
      Fluttertoast.showToast(msg: 'Upload banner successfully');
    });
  }

  //removeBanner
  static removeBanner({required String id}) {
    BannerProvider.refBanner.doc(id).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from banner');
    });
  }

  //removeBannerImage
  static removeBannerImage({required String imageUrl}) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }
}
