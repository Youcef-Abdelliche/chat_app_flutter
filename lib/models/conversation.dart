import 'dart:convert';

class Conversation {
  String content;
  String idFrom;
  String idTo;
  bool read;
  String timestamp;
  Conversation({
    this.content,
    this.idFrom,
    this.idTo,
    this.read,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'idFrom': idFrom,
      'idTo': idTo,
      'read': read,
      'timestamp': timestamp,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      content: map['content'],
      idFrom: map['idFrom'],
      idTo: map['idTo'],
      read: map['read'],
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source));
}
