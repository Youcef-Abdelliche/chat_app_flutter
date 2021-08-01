import 'package:chat_app/helpers/helper_functions.dart';
import 'package:chat_app/models/conversation_info.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/views/chat/chat_view.dart';
import 'package:chat_app/views/chat/new_message_screen.dart';
import 'package:chat_app/views/profile/profile_view.dart';
import 'package:chat_app/views/settings/settings_view.dart';
import 'package:chat_app/views/widgets/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({Key key}) : super(key: key);

  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  signOut() {
    FirebaseAuthService().signOut();
  }

  final User user = FirebaseAuth.instance.currentUser;
  int currentIndex = 1;
  int currentIndex2 = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Chat",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewMessageScreen()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                signOut();
              },
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(color: kPrimaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            currentIndex2 = 0;
                          });
                          print(currentIndex2);
                          _pageController.animateToPage(0,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.linear);
                          _pageController.jumpToPage(0);
                        },
                        child: Text("Messages",
                            style: TextStyle(color: Colors.white))),
                    if (currentIndex2 == 0)
                      Container(
                        height: 2,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            currentIndex2 = 1;
                          });
                          print(currentIndex2);
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.linear);
                          _pageController.jumpToPage(1);
                        },
                        child: Text("Groups",
                            style: TextStyle(color: Colors.white))),
                    if (currentIndex2 == 1)
                      Container(
                        height: 2,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            currentIndex2 = 2;
                          });
                          print(currentIndex2);
                          _pageController.animateToPage(2,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.linear);
                          _pageController.jumpToPage(2);
                        },
                        child: Text("Calls",
                            style: TextStyle(color: Colors.white))),
                    if (currentIndex2 == 2)
                      Container(
                        height: 2,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: PageView(
            onPageChanged: (value) {
              setState(() {
                currentIndex2 = value;
              });
            },
            controller: _pageController,
            children: [
              StreamBuilder(
                stream: Database.getConversationsList(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    List<ConversationGlobalInfo> list = snapshot.data;

                    return (list.isEmpty)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/email.png",
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                ),
                                SizedBox(height: 40),
                                Text("No Conversation",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text("You didn't made any conversation yet.",
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(height: 10),
                                TextButton(
                                    onPressed: () {},
                                    child: Text("Chat People"))
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final peerId = HelperFunctions.getPeerId(
                                  user.uid, list[index].lastMessage);
                              return ChatCard(
                                userId: peerId,
                                imagePath: chatsData[index].image,
                                time: HelperFunctions.lastMessageTime(
                                    list[index].lastMessage.timestamp),
                                lastMessage: list[index].lastMessage.content,
                                read: list[index].lastMessage.read,
                                idFrom: list[index].lastMessage.idFrom,
                                press: () {
                                  print(
                                      "Chating with ${chatsData[index].name}");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            // chat: chatsData[index],
                                            userId: user.uid,
                                            peerId: peerId,
                                            idFrom:
                                                list[index].lastMessage.idFrom,
                                            read: list[index].lastMessage.read,
                                          )));
                                },
                              );
                            });
                  }
                  return Center(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/groups.png",
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    SizedBox(height: 40),
                    Text("No Group Chat",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("You didn't made any conversation yet.",
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    TextButton(onPressed: () {}, child: Text("Create Group"))
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/calling.png",
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    SizedBox(height: 40),
                    Text("No Phone Call",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("You didn't made any conversation yet.",
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    TextButton(onPressed: () {}, child: Text("Make Phone Call"))
                  ],
                ),
              )
            ],
          )),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          switch (value) {
            case 0:
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
              break;

            case 1:
              break;

            case 2:
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
              break;
            default:
          }
        },
        showUnselectedLabels: false,
        showSelectedLabels: false,
        elevation: 4,
        backgroundColor: Colors.grey[100],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Person"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
