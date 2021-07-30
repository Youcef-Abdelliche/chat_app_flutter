import 'package:chat_app/constants.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/views/widgets/google_signin_button.dart';
import 'package:flutter/material.dart';

class SigninOrSignupScreen extends StatelessWidget {
  const SigninOrSignupScreen({Key key}) : super(key: key);

  Future<void> _signInWithGoogle() async {
    try {
      await FirebaseAuthService().signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            Image.asset(
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? "assets/images/Logo_light.png"
                  : "assets/images/Logo_dark.png",
              height: MediaQuery.of(context).size.height / 5,
            ),
            Spacer(flex: 3),
            GoogleSigninButton(press: () {
              _signInWithGoogle();
              /* Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChatsListScreen()));*/
            }),
            /*PrimaryButton(
              text: "Sign In",
              press: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChatsListScreen()));
              },
            ),*/
            Spacer(flex: 2),
          ],
        ),
      )),
    );
  }
}
