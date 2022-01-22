import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class FBStorage{


  static Future<String> getFirebaseImgDownloadUrl(String imgRef) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
       // .ref('user/1Oh3tB7kM6hKfPc3ptsE2S0N7Ov2/recipeImgs/0714f324-e98c-444c-9be9-b7d5574ec97d.jpg')
        .ref(imgRef)
        .getDownloadURL();
    return downloadURL;
  }



}