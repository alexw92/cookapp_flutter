import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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
              "Login to access this page!",
            ),
            SignInButton(
              Buttons.Facebook,
              text: "Continue with Facebook",
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Google,
              text: "Continue with Google",
              onPressed: () {
                convertAnonymousToGoogle();
              },
            ),
            SignInButton(
              Buttons.Email,
              text: "Create Account",
              onPressed: () {},
            ),
            Text("or"),
            SignInButton(
              Buttons.Email,
              text: "Login with Account",
              onPressed: () {},
            ),
          ]));
    }
    else {
      return Container(
        child: Text("User is not anonymous. display profile page here"),
      );
    }
  }

  Future<void> convertAnonymousToGoogle() async {
    apiToken = await TokenStore().getToken();

    var credential = GoogleAuthProvider.credential(idToken: apiToken);
  }
}
