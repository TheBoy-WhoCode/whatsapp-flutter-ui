import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/providers/loader_provider.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_ui/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_ui/models/message.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/services/controller/http_controller.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = "/mobile-chat-screen";

  final String name;
  final String uid;
  final Message? message;
  final bool isForwarded;

  const MobileChatScreen({
    Key? key,
    required this.message,
    required this.isForwarded,
    required this.name,
    required this.uid,
  }) : super(key: key);

  void forwardMessage({
    required BuildContext context,
    required WidgetRef ref,
    required Message message,
    required String recieverUserId,
  }) async {
    
    final response =
        await ref.read(httpControllerProvider).forwardMessageToBlockchain(
              blockId: message.blockId,
              senderId: message.senderId,
              receiverId: message.recieverId,
            );
    if (response.code == 200) {
     
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: message.text,
            recieverUserId: recieverUserId,
            blockId: message.blockId,
            messageId: message.messageId,
            isForwarded: true,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isForwarded) {
      forwardMessage(
        ref: ref,
        context: context,
        message: message!,
        recieverUserId: uid,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(
                    snapshot.data!.isOnline ? 'online' : 'offline',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ref.watch(loaderProvider)
                ? const Loader()
                : ChatList(
                    recieverUserId: uid,
                  ),
          ),
          BottomChatField(
            recieverUserId: uid,
          ),
        ],
      ),
    );
  }
}
