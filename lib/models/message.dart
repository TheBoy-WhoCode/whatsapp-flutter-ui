import 'package:whatsapp_ui/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;
  final String blockId;
  final bool isForwarded;
  final int messageForwardedCount;

  Message({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
    required this.blockId,
    required this.isForwarded,
    required this.messageForwardedCount,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'senderId': senderId,
  //     'recieverId': recieverId,
  //     'text': text,
  //     'type': type.type,
  //     'timeSent': timeSent.millisecondsSinceEpoch,
  //     'messageId': messageId,
  //     'isSeen': isSeen,
  //     'repliedMessage': repliedMessage,
  //     'repliedTo': repliedTo,
  //     'repliedMessageType': repliedMessageType.type,
  //   };
  // }

  // factory Message.fromMap(Map<String, dynamic> map) {
  //   return Message(
  //     senderId: map['senderId'] ?? '',
  //     recieverId: map['recieverId'] ?? '',
  //     text: map['text'] ?? '',
  //     type: (map['type'] as String).toEnum(),
  //     timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
  //     messageId: map['messageId'] ?? '',
  //     isSeen: map['isSeen'] ?? false,
  //     repliedMessage: map['repliedMessage'] ?? '',
  //     repliedTo: map['repliedTo'] ?? '',
  //     repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
      'blockId': blockId,
      'isForwarded': isForwarded,
      'messageForwardedCount' : messageForwardedCount,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverId: map['recieverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      repliedMessage: map['repliedMessage'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
      blockId: map['blockId'] ?? '',
      isForwarded: map['isForwarded'] ?? false,
      messageForwardedCount : map['messageForwardedCount'] ?? 0,
    );
  }
}
