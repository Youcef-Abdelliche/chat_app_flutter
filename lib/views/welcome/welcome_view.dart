
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/views/widgets/google_signin_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          Image.asset("assets/images/welcome_image.png"),
          Spacer(flex: 2),
          Text(
            "Welcome to our freedom \nmessaging app",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Spacer(flex: 1),
          Text("With Freedom talk to any person of your \nmother language",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(0.64))),
          Spacer(flex: 3),
          GoogleSigninButton(
            press: () => _signInWithGoogle(),
          ),
          /*TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SigninOrSignupScreen())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Skip",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.8)),
                ),
                SizedBox(width: kDefaultPadding / 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(0.64),
                )
              ],
            ),
          ),*/
          Spacer(flex: 1),
        ],
      )),
    );
  }
}
