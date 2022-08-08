// import 'dart:convert';

class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessages;
  final String groupPic;
  final List<String> membersUid;
  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessages,
    required this.groupPic,
    required this.membersUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'name': name,
      'membersUid': membersUid,
      'lastMessages': lastMessages,
      'membersUid': membersUid,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] ?? '',
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessages: map['lastMessages'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
    );
  }
}
