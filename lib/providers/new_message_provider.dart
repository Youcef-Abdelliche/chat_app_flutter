import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chat/new_message_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessageProvider extends StatelessWidget {
  const NewMessageProvider({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel>>.value(
      value: Database.streamUsers(),
      initialData: [],
      child: NewMessageScreen(),
    );
  }
}