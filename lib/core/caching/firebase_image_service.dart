import 'package:cookable_flutter/ui/util/fb_storage_utils.dart';

import 'hive_service.dart';

class FirebaseImageService {
  final HiveService hiveService = HiveService();

  Future<String> getFirebaseImage(String imgRef) async {
    String downloadUrl =
        await hiveService.getElement(imgRef, "FirebaseImageUrls");
    if (downloadUrl != null) {
      print("load img from hive");
      return downloadUrl;
    } else {
      downloadUrl = await FBStorage.getFirebaseImgDownloadUrl(imgRef);
      hiveService.putElement(imgRef, downloadUrl, "FirebaseImageUrls");
      return downloadUrl;
    }
  }
}
