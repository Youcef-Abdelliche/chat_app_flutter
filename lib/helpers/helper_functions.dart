import 'package:chat_app/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelperFunctions {
  static String getConvoID(String uid, String pid) {
    return uid.hashCode <= pid.hashCode ? uid + '_' + pid : pid + '_' + uid;
  }

  static DateTime timestampToDateTime(String timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  }

  static bool isSender(String userId, Conversation conv) {
    return (userId == conv.idFrom) ? true : false;
  }

  static String getPeerId(String userId, Conversation conv) {
    return (userId == conv.idFrom) ? conv.idTo : conv.idFrom;
  }

  static String lastMessageTime(String timestamp) {
    final time =
        Timestamp.fromDate(DateTime.now()).seconds - int.parse(timestamp);
        print(time);
    if (time > 86400 * 7)
      return (time ~/ 86400 * 7 == 1)
          ? (time ~/ 86400 * 7).toString() + " week"
          : (time ~/ 86400 * 7).toString() + " weeks";
    else if (time > 86400)
      return (time ~/ 86400 == 1)
          ? (time ~/ 86400).toString() + " day"
          : (time ~/ 86400).toString() + " days";
    else if (time > 3600)
      return (time ~/ 3600 == 1)
          ? (time ~/ 3600).toString() + " hour"
          : (time ~/ 3600).toString() + " hours";
    else if (time > 60)
      return (time ~/ 60 == 1)
          ? (time ~/ 60).toString() + " min"
          : (time ~/ 60).toString() + " mins";
    else
      return time.toString() + " seconds";
  }

  static String messageTime(String timestamp) {
    var dateTime = timestampToDateTime(timestamp);

    var todayDateTime = DateTime.now();

    if (todayDateTime.year == dateTime.year &&
        todayDateTime.month == dateTime.month &&
        todayDateTime.day == dateTime.day) {
      String hour = (dateTime.hour <= 9)
          ? "0" + dateTime.hour.toString()
          : dateTime.hour.toString();
      String min = (dateTime.minute <= 9)
          ? "0" + dateTime.minute.toString()
          : dateTime.minute.toString();
      return "$hour:$min";
    } else {
      String hour = (dateTime.hour <= 9)
          ? "0" + dateTime.hour.toString()
          : dateTime.hour.toString();
      String min = (dateTime.minute <= 9)
          ? "0" + dateTime.minute.toString()
          : dateTime.minute.toString();

      int year = dateTime.year;
      int month = dateTime.month;
      int day = dateTime.day;

      return "$day/$month/$year $hour:$min";
    }
  }
}
