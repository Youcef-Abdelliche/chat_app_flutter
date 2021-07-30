import 'dart:convert';

class Chat {
  String name;
  String lastMessage;
  String image;
  String time;
  bool isActive;

  Chat({
    this.name,
    this.lastMessage,
    this.image,
    this.time,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'image': image,
      'time': time,
      'isActive': isActive,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      name: map['name'],
      lastMessage: map['lastMessage'],
      image: map['image'],
      time: map['time'],
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));
}
