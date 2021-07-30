import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/views/chat/chat_list_view.dart';
import 'package:chat_app/views/settings/settings_view.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                FirebaseAuthService().signOut();
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(color: kPrimaryColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14),
            child: Column(
              children: [
                Container(
                  //height: 100,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/user_2.png"),
                              radius: 30,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Youcef Abdellihe",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text("Mobile Developer",
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(height: 6, thickness: 2, color: Colors.grey[100]),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "It is a long established fact that is a reader will be the distracted by the readable content of a page when its looking at its layout.",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                        child: Container()//ListView.builder(itemBuilder: (context, index)=>Text("data $index")),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          switch (value) {
            case 0:
              break;

            case 1:
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ChatsListScreen()));
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
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
