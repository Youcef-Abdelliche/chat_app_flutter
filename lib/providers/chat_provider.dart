import 'package:flutter/cupertino.dart';

class ChatProvider extends ChangeNotifier {
  String messageToSend = "";

  updateMessage(String msg) {
    messageToSend = msg;
    notifyListeners();
  }

}