import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String apiToken;

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
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if (user.isAnonymous) {
      return Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              AppLocalizations.of(context).loginToAccessThisPage,
            ),
            SignInButton(
              Buttons.Facebook,
              text: AppLocalizations.of(context).continueWithFacebook,
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Google,
              text: AppLocalizations.of(context).continueWithGoogle,
              onPressed: () {
                convertAnonymousToGoogle();
              },
            ),
            SignInButton(
              Buttons.Email,
              text: AppLocalizations.of(context).createAccount,
              onPressed: () {},
            ),
            Text("or"),
            SignInButton(
              Buttons.Email,
              text: AppLocalizations.of(context).loginWithAccount,
              onPressed: () {},
            ),
          ]));
    } else {
      return Container(
        child: Text(AppLocalizations.of(context).userNotAnonymous),
      );
    }
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
        onError: (error) =>
            {print("Error while upgrading user: " + error.toString())});
  }
}
