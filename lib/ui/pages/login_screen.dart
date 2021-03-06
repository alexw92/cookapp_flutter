import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUserSignIn(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _authUserSignup(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Foodict',
      logo: 'assets/icon_sample2.PNG',
      // logoTag: Constants.logoTag,
      // titleTag: Constants.titleTag,
      onLogin: _authUserSignIn,
      onSignup: _authUserSignup,
      showDebugButtons: false,

      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            // await FirebaseAuth.instance
            //     .sign()
            //     .then((UserCredential user) => {TokenStore().getToken()});
            await signInWithGoogle()
                .then((UserCredential user) => {TokenStore().getToken()});
            FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
            String token = await _firebaseMessaging.getToken();

            UserController.submitFirebaseDeviceRegistrationToken(token)
                .then((value) => null);
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          label: 'Facebook',
          callback: () async {
            print('start facebook sign in');
            await Future.delayed(loginTime);
            print('stop facebook sign in');
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.userSecret,
          label: AppLocalizations.of(context).withoutLogin,
          callback: () async {
            print('start anonymous sign in');
            await signInAnonymously()
                .then((UserCredential user) => {TokenStore().getToken()});
            FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
            String token = await _firebaseMessaging.getToken();

            UserController.submitFirebaseDeviceRegistrationToken(token)
                .then((value) => null);
            print('end anonymous sign in');
            return null;
          },
        )
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}

Future<UserCredential> signInAnonymously() async {
  return await FirebaseAuth.instance.signInAnonymously();
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
