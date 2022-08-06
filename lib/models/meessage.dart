import 'package:whatsapp_clone/common/enum/message_enums.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  // final String repliedMessage;
  // final String repliedTo;
  // final MessageEnum repliedMessageType;
  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    // required this.repliedMessage,
    // required this.repliedTo,
    // required this.repliedMessageType,
  });
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.microsecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      // 'repliedMessage': repliedMessage,
      // 'repliedTo': repliedTo,
      // 'repliedMessageType': repliedMessageType,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'],
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMicrosecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      // repliedMessage: map['replieMessage'] ?? '',
      // repliedTo: map['repliedTo'] ?? '',
      // repliedMessageType: (map['repliedMessageTyoe'] as String).toEnum(),
    );
  }
}
