import 'dart:io';

import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUploadPage extends StatefulWidget {
  ImageUploadPage({Key key}) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  String apiToken;
  File _imageFile;

  _ImageUploadPageState();

  final picker = ImagePicker();

  // Todo add image compression to save bandwidth
  Future pickImage({bool fromGallery = true}) async {
    final pickedFile = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  // https://stackoverflow.com/a/64764390/11751609
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    String uid = FirebaseAuth.instance.currentUser.uid;
    Reference firebaseStorageRef = storage.ref().child('user/$uid/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask.then((res) => {
          // btw this link has a token and is publicly accessible, thus this
          // the token should be removed before sending the link to the backend
          res.ref.getDownloadURL().then((value) => print("Done: $value"))
        });
  }

  void uploadImage({bool fromGallery = true}) async {
    await pickImage(fromGallery: fromGallery);
    await uploadImageToFirebase(this.context);
  }

  void getToken() async {
    // recipe = await RecipeController.getRecipe();
    apiToken = await TokenStore().getToken();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => uploadImage(fromGallery: false),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => uploadImage(fromGallery: true),
              )
            ],
          )
        ]));
  }
}
