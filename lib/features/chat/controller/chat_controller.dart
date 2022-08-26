import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_ui/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Future<Message?> getMessageByID({
    required String messageId,
    required String senderId,
    required String receiverId,
  }) async {
    final message = chatRepository.getMessageByID(
      messageId: messageId,
      senderId: senderId,
      receiverId: receiverId,
    );
    return message;
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required String blockId,
    String? messageId,
    required  bool isForwarded,
    required int messageForwardedCount,
    required bool isSpam,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            blockId: blockId,
            msgId: messageId,
            isForwarded: isForwarded,
            messageForwardedCount: messageForwardedCount,
            isSpam: isSpam,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required MessageEnum messageEnum,
    required String blockId,
    required bool isForwarded,
    required int messageForwardedCount,
    required bool isSpam,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            blockId: blockId,
            isForwarded: isForwarded,
            messageForwardedCount: messageForwardedCount,
            isSpam: isSpam,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.chatMesssageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}
