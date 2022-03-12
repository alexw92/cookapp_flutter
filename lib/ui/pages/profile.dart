import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/caching/user_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/signin_signout.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/pages/profile-name-edit-dialog.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String apiToken;
  final picker = ImagePicker();
  bool showProgressIndicatorImage = false;
  Future<ReducedUser> userFuture;
  String usernameOrig;
  UserService userService = UserService();
  ReducedUser user;

  _ProfilePageState();

  void getToken() async {
    // recipe = await RecipeController.getRecipe();
    apiToken = await TokenStore().getToken();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getToken();
    getUser();
  }

  getUser({bool reload = false}) {
    userFuture = userService.getUser(reload: reload);
    userFuture.then((value) => {
          usernameOrig = value.displayName,
          user = value,
          if (reload) userService.addOrUpdateUser(user)
        });
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return FutureBuilder(
        future: userFuture,
        builder: (context, AsyncSnapshot<ReducedUser> snapshot) {
          return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.teal,
                    title: Text(
                      AppLocalizations.of(context).profile,
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      // AppLocalizations.of(context).logout
                      // AppLocalizations.of(context).settings
                      PopupMenuButton(
                        onSelected: (result) {
                          switch (result) {
                            case 0:
                              _openSettings();
                              break;
                            case 1:
                              _signOut();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              child:
                                  Text(AppLocalizations.of(context).settings),
                              value: 0),
                          PopupMenuItem(
                              child: Text(AppLocalizations.of(context).logout),
                              value: 1)
                        ],
                        icon: Icon(Icons.settings, color: Colors.white),
                      )
                    ],
                  ),
                  body: (!snapshot.hasData)
                      ? Container()
                      : user.isAnonymous
                          ? Center(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .loginToAccessThisPage,
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SignInButton(
                                          Buttons.Facebook,
                                          text: AppLocalizations.of(context)
                                              .continueWithFacebook,
                                          onPressed: () {},
                                        ),
                                        SignInButton(
                                          Buttons.Google,
                                          text: AppLocalizations.of(context)
                                              .continueWithGoogle,
                                          onPressed: () {
                                            convertAnonymousToGoogle();
                                          },
                                        ),
                                        SignInButtonBuilder(
                                          icon: Icons.email,
                                          iconColor: Colors.white,
                                          backgroundColor: Colors.teal,
                                          onPressed: () {},
                                          text: AppLocalizations.of(context)
                                              .createAccount,
                                        ),
                                        Text("or"),
                                        SignInButtonBuilder(
                                          icon: Icons.email,
                                          iconColor: Colors.white,
                                          backgroundColor: Colors.teal,
                                          onPressed: () {},
                                          text: AppLocalizations.of(context)
                                              .loginWithAccount,
                                        )
                                      ])))
                          : Column(children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 20, right: 0, left: 0),
                                  child: Row(
                                    children: [
                                      Stack(children: [
                                        showProgressIndicatorImage
                                            ? Container(
                                                width: 144,
                                                height: 144,
                                                child:
                                                    CircularProgressIndicator())
                                            : (snapshot.data.fbUploadedPhoto ==
                                                        null &&
                                                    snapshot.data
                                                            .providerPhoto ==
                                                        null)
                                                ? CircleAvatar(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 92,
                                                    ),
                                                    radius: 72,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: CachedNetworkImageProvider(
                                                        (snapshot.data
                                                                    .fbUploadedPhoto ==
                                                                null)
                                                            ? snapshot.data
                                                                .providerPhoto
                                                            : snapshot.data
                                                                .fbUploadedPhoto,
                                                        imageRenderMethodForWeb:
                                                            ImageRenderMethodForWeb
                                                                .HttpGet,
                                                    maxHeight: 300,
                                                    maxWidth: 300),
                                                    // backgroundColor: Colors.transparent,
                                                    radius: 72,
                                                  ),
                                        Positioned(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.teal,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(8)),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: 150,
                                                  margin: EdgeInsets.all(20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .profileImage,
                                                            style: TextStyle(
                                                                fontSize: 24),
                                                          )
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Wrap(
                                                              crossAxisAlignment:
                                                                  WrapCrossAlignment
                                                                      .center,
                                                              direction:
                                                                  Axis.vertical,
                                                              children: [
                                                                ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .white,
                                                                      shape:
                                                                          CircleBorder(),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              14),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      _editProfileImg(
                                                                          false);
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .camera_alt,
                                                                      size: 26,
                                                                      color: Colors
                                                                          .teal,
                                                                    )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(AppLocalizations.of(
                                                                        context)
                                                                    .camera)
                                                              ]),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Wrap(
                                                              crossAxisAlignment:
                                                                  WrapCrossAlignment
                                                                      .center,
                                                              direction:
                                                                  Axis.vertical,
                                                              children: [
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary:
                                                                            Colors
                                                                                .white,
                                                                        shape:
                                                                            CircleBorder(),
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                14)),
                                                                    onPressed:
                                                                        () {
                                                                      _editProfileImg(
                                                                          true);
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 26,
                                                                      color: Colors
                                                                          .teal,
                                                                    )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(AppLocalizations.of(
                                                                        context)
                                                                    .gallery)
                                                              ])
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          bottom: 0,
                                          right: -8,
                                        )
                                      ])
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  )),
                              Wrap(alignment: WrapAlignment.center, children: [
                                Text(
                                  this.user.displayName,
                                  style: TextStyle(
                                      fontSize: 24,
                                      height: 2,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () => openChangeNameDialog(),
                                )
                              ]),
                            ])));
        });
  }

  Future<void> openChangeNameDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new ChangeProfileNameDialog(user);
      },
    ).then((newName) => {
          if (newName != "ERROR" && newName != null)
            {
              user.displayName = newName,
              userService.addOrUpdateUser(user),
              setState(() {}),
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${AppLocalizations.of(context).profileNameUpdated}"),
                ),
              ),
            }
          else if (newName == null)
            {}
          else
            {
              // error
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${AppLocalizations.of(context).errorDuringProfileNameChange}"),
                ),
              ),
            }
        });
  }

  _editProfileImg(bool fromGallery) async {
    var image = await pickImage(fromGallery: fromGallery);
    setState(() {
      showProgressIndicatorImage = true;
    });

    UserController.updateProfileImage(image).then(
        (value) async => {
              getUser(reload: true),
              Navigator.pop(context),
              setState(() {
                showProgressIndicatorImage = false;
              }),
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${AppLocalizations.of(context).profileImageUpdated}"),
                ),
              )
            },
        onError: (error) => {
              setState(() {
                showProgressIndicatorImage = false;
              }),
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${AppLocalizations.of(context).errorDuringImageUpload}"),
                ),
              )
            });
  }

  Future<File> pickImage({bool fromGallery = true}) async {
    final pickedFile = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 80);
    return File(pickedFile.path);
  }

  Future<void> convertAnonymousToGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    String newIdToken;
    FirebaseAuth.instance.currentUser.linkWithCredential(credential).then(
        (user) async => {
              // getting a new token seems to be necessary here to avoid the audience not recognized error in the backend
              newIdToken =
                  await FirebaseAuth.instance.currentUser.getIdToken(true),
              TokenStore()
                  .putToken(FirebaseAuth.instance.currentUser.uid, newIdToken),
              print(
                  "Anonymous account successfully upgraded: " + user.toString())
            },
        onError: (error) async => {
              // linking to google did not work because registered acc already exists with this google account
              // so just log in and assume the user wanted to login
              await FirebaseAuth.instance.signInWithCredential(credential),
              clearUserSpecificData(),
              getUser(),
              getToken()
            });
  }

  Future<void> _signOut() async {
    signOut(context);
  }

  Future<void> _openSettings() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }
}
