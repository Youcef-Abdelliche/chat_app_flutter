import 'package:chat_app/views/chat/chat_list_view.dart';
import 'package:chat_app/views/welcome/welcome_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream:
            FirebaseAuth.instanceFor(app: Firebase.app()).authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user != null) {
              return ChatsListScreen();
            } else {
              return WelcomeScreen();
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
