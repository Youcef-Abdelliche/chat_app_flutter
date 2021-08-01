import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/conversation_info.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(User user) async {
    await _db
        .collection('users')
        .doc(user.uid)
        .set({'id': user.uid, 'name': user.displayName, 'email': user.email});
  }

  static Stream<List<UserModel>> streamUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot snap) => UserModel.fromMap(snap.data()))
            .toList())
        .handleError((dynamic e) {
      print(e);
    });
  }

  static Stream<List<ConversationGlobalInfo>> getConversationsList(
      String userId) {
    var list = _db
        .collection('messages')
        .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: userId)
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot snapshot) =>
                ConversationGlobalInfo.fromMap(snapshot.data()))
            .toList())
        .handleError((e) {
      print(e);
    });
    return list;
  }

  static Stream<List<Conversation>> getConversationMgs(
      String userId, String peerId) {
    String docId;
    if (userId.hashCode > peerId.hashCode)
      docId = userId + "_" + peerId;
    else
      docId = peerId + "_" + userId;

    print(docId);
    var conversations = _db
        .collection('messages')
        .doc(docId)
        .collection(docId)
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => Conversation.fromMap(snap.data())).toList())
        .handleError((e) {
      print(e);
    });
    return conversations;
  }

  static Stream<List<UserModel>> getUsersInfos(String userId) {
    // return _db.collection('messages').snapshots().map((list) => list.docs.c)

    var userModel = _db
        .collection('users')
        .where("id", isEqualTo: userId)
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => UserModel.fromMap(snap.data())).toList());
    return userModel;
  }

  static Stream<List<Conversation>> getConversation(
      String userId, String peerId) {
    return null;
  }

  static sendMessage(Conversation conversation, String userId, String peerId) {
    String docId;
    if (userId.hashCode > peerId.hashCode)
      docId = userId + "_" + peerId;
    else
      docId = peerId + "_" + userId;
    _db.collection('messages').doc(docId).set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'content': conversation.content,
        'idFrom': conversation.idFrom,
        'idTo': conversation.idTo,
        'read': false,
        'timestamp': conversation.timestamp,
      },
      'users': <String>[userId, peerId]
    }).then((success) => _db
            .collection('messages')
            .doc(docId)
            .collection(docId)
            .doc(conversation.timestamp)
            .set(<String, dynamic>{
          'content': conversation.content,
          'idFrom': conversation.idFrom,
          'idTo': conversation.idTo,
          'read': false,
          'timestamp': conversation.timestamp,
        }));
  }

  static void updateMessageStatus(
      String userId, String peerId, String idMessage) async {
    String docId;
    if (userId.hashCode > peerId.hashCode)
      docId = userId + "_" + peerId;
    else
      docId = peerId + "_" + userId;

    _db
        .collection('messages')
        .doc(docId)
        .collection(docId)
        .doc(idMessage)
        .set(<String, dynamic>{'read': true}, SetOptions(merge: true));
  }

  static void updateLastMessageStatus(String userId, String peerId) {
    String docId;
    if (userId.hashCode > peerId.hashCode)
      docId = userId + "_" + peerId;
    else
      docId = peerId + "_" + userId;

    _db.collection("messages").doc(docId).set(<String, dynamic>{
      "lastMessage": <String, dynamic>{'read': true},
    }, SetOptions(merge: true));
  }

  static Stream<Conversation> getLastmessageOfConv(
      String userId, String peerId) {
    String docId;
    if (userId.hashCode > peerId.hashCode)
      docId = userId + "_" + peerId;
    else
      docId = peerId + "_" + userId;

    return _db
        .collection("messages")
        .doc(docId)
        .snapshots()
        .map((list) => Conversation.fromMap(list.data()));
  }
}
