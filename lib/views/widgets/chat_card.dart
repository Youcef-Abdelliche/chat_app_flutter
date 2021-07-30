import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String imagePath;
  final String time;
  final String userId;
  final String lastMessage;
  final Function press;

  const ChatCard({
    Key key,
    this.imagePath,
    this.time,
    this.userId,
    this.lastMessage,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage(imagePath),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder<Object>(
                      stream: Database.getUsersInfos(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                              List<UserModel> list = snapshot.data;
                          return Text(list[0].name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold));
                        }
                        return CircularProgressIndicator();
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Opacity(
                    opacity: 0.64,
                    child: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )),
            Text(time)
          ],
        ),
      ),
    );
  }
}
