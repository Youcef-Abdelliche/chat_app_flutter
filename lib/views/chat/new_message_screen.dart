import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chat/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({Key key}) : super(key: key);

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Contact"),
        ),
        body: StreamBuilder(
          stream: Database.streamUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              List<UserModel> list = snapshot.data;
              print(user.photoURL);
              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => (user.email !=
                          list[index].email)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          userId: user.uid,
                                          peerId: list[index].id)));
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user.photoURL),
                                  radius: 26,
                                ),
                                SizedBox(width: 10),
                                Text(list[index].email),
                              ],
                            ),
                          ),
                        )
                      : Container());
            }
            return CircularProgressIndicator();
          },
        ));
  }
}
