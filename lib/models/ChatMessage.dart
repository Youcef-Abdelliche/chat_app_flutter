import 'dart:convert';

enum ChatMessageType { text, image, audio, video }
enum MessageStatus { not_sent, not_viewed, viewed }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  ChatMessage({
    this.text,
    this.messageType,
    this.messageStatus,
    this.isSender,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      //'messageType': messageType.toMap(),
      //'messageStatus': messageStatus.toMap(),
      'isSender': isSender,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      //messageType: ChatMessageType.fromMap(map['messageType']),
      //messageStatus: MessageStatus.fromMap(map['messageStatus']),
      isSender: map['isSender'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));
}
