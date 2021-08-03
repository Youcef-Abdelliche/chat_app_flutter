import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final String imagePath;
  final String time;
  final String userId;
  final String idFrom;
  final String lastMessage;
  final bool read;
  final Function press;

  const ChatCard({
    Key key,
    this.imagePath,
    this.time,
    this.userId,
    this.idFrom,
    this.lastMessage,
    this.read,
    this.press,
  }) : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {

  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: StreamBuilder<Object>(
            stream: Database.getUsersInfos(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                List<UserModel> list = snapshot.data;
                return Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: AssetImage(widget.imagePath),
                        ),
                        if (list[0].isActive)
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                        style: BorderStyle.values[1]),
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                              ))
                      ],
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /*StreamBuilder<Object>(
                          stream: Database.getUsersInfos(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              List<UserModel> list = snapshot.data;
                              return Text(list[0].name,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold));
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) return Text("Loading...");
                            return CircularProgressIndicator();
                          }),*/
                          Text(list[0].name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Opacity(
                              opacity: 1,
                              child: (widget.userId != widget.idFrom)
                                  ? Text(
                                      "You: ${widget.lastMessage}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    )
                                  : Text(
                                      widget.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: (!widget.read)
                                          ? TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16,
                                            )
                                          : TextStyle(
                                              fontWeight: FontWeight.normal),
                                    ))
                        ],
                      ),
                    )),
                    Text(widget.time)
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
  
}
