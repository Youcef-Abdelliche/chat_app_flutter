import 'package:chat_app/constants.dart';
import 'package:chat_app/helpers/helper_functions.dart';
import 'package:chat_app/models/Chat.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String peerId;
  final String idFrom;
  final bool read;
  const ChatScreen(
      {Key key, @required this.userId, @required this.peerId, this.idFrom, this.read})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userId != widget.idFrom && !widget.read)
      Database.updateLastMessageStatus(widget.userId, widget.peerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: Database.getConversationMgs(widget.userId, widget.peerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                var list = snapshot.data;
                print(list.length);
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => MessageContainer(
                          userId: user.uid,
                          message: list[index],
                        ));
              }
              return Center(child: CircularProgressIndicator());
            },
          )),
          ChatAppField(userId: widget.userId, peerId: widget.peerId)
        ],
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  final String userId;
  final Conversation message;
  final Chat chat;
  const MessageContainer({
    Key key,
    this.message,
    this.chat,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: (HelperFunctions.isSender(userId, message))
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!HelperFunctions.isSender(userId, message))
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          Column(
            crossAxisAlignment: (HelperFunctions.isSender(userId, message))
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: (HelperFunctions.isSender(userId, message))
                          ? BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16))
                          : BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16)),
                      color: (HelperFunctions.isSender(userId, message))
                          ? kPrimaryColor
                          : Color(0xffecf8fe)),
                  child: Text(
                    message.content,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: (HelperFunctions.isSender(userId, message))
                            ? Colors.white
                            : Colors.black),
                  )),
              SizedBox(height: 4),
              Text(HelperFunctions.messageTime(message.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey))
            ],
          ),
        ],
      ),
    );
  }
}

class ChatAppField extends StatelessWidget {
  final String userId;
  final String peerId;
  const ChatAppField({
    Key key,
    this.userId,
    this.peerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var msgController = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: SafeArea(
          child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color(0xFFe1ebee), shape: BoxShape.circle),
                child: Icon(
                  Icons.add_rounded,
                  color: kPrimaryColor,
                  size: 34,
                )),
          ),
          SizedBox(width: 10),
          Expanded(
              flex: 5,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color(0xFFe1ebee),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        controller: msgController,
                        onChanged: (value) {
                          Provider.of<ChatProvider>(context, listen: false)
                              .updateMessage(value);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type your message",
                        ),
                        maxLines: 3,
                      ),
                    )),
                    SizedBox(width: 6),
                    Container(
                      child: IconButton(
                        disabledColor: Colors.grey,
                        onPressed: () {
                          Conversation conversation = Conversation(
                            content: Provider.of<ChatProvider>(context,
                                    listen: false)
                                .messageToSend,
                            idFrom: userId,
                            idTo: peerId,
                            timestamp: Timestamp.fromDate(DateTime.now())
                                .seconds
                                .toString(),
                            read: true,
                          );
                          Database.sendMessage(conversation, userId, peerId);
                          msgController.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      )),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("chat.name"),
        SizedBox(height: 4),
        Text(
          "Active Now",
          style: TextStyle(fontSize: 14),
        ),
      ],
    ),
    actions: [
      IconButton(
          icon: Icon(Icons.call),
          onPressed: () {
            // print("Call : ${chat.name}");
          }),
      IconButton(
          icon: Icon(Icons.video_call_sharp),
          onPressed: () {
            //    print("Video call: ${chat.name}");
          }),
      IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            //print("Info: ${chat.name}");
          }),
      SizedBox(width: 10)
    ],
  );
}
