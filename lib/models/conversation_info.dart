import 'dart:convert';

import 'package:chat_app/models/conversation.dart';



class ConversationGlobalInfo {
  Conversation lastMessage;
  List<String> users;
  ConversationGlobalInfo({
    this.lastMessage,
    this.users,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'users': users,
    };
  }

  factory ConversationGlobalInfo.fromMap(Map<String, dynamic> map) {
    return ConversationGlobalInfo(
      lastMessage: Conversation.fromMap(map['lastMessage']),
      users: List<String>.from(map['users']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationGlobalInfo.fromJson(String source) => ConversationGlobalInfo.fromMap(json.decode(source));
}
