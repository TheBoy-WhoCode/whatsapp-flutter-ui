import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/loader_provider.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/message_reply_preview.dart';
import 'package:whatsapp_ui/services/controller/http_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  bool isSus = false;
  final TextEditingController _messageController = TextEditingController();
  
  List<String> susWords = [
    "assasin",
    "kill",
    "rape",
    "gun",
    "abort",
    "attack",
    "weapon",
    "bomb",
    "sexual assault",
    "death",
    "mission",
    "theft",
    "murder",
    "disaster",
    "terror",
    "kidnap",
    "narcos",
    "drugs",
    "virus",
    "trafficking",
    "abuse",
    "torture",
    "grenade",
    "ak47",
    "pistol",
    "war",
    "military",
    "combact",
    "nuclear war",
    "cyber attack",
    "brush fire",
    "border attack",
    "nuclear",
    "radioactive",
    "smuggling",
    "chloroform",
    "narcotics",
    "terrorism",
    "assasination",
    "bombing",
    "car bomb",
    "suicide",
    "hazard",
    "threat",
    "nuclear threat",
    "mass kill",
    "biological weapon",
    "airport attack",
    "station attack",
    "assault",
  ];
  void sendTextMessage() async {
    if (!(_messageController.text == "" || _messageController.text == " ")) {
      for (int i = 0; i < susWords.length; i++) {
        if (_messageController.text
            .trim()
            .toLowerCase()
            .contains(susWords[i])) {
          isSus = true;
        }
      }

      ref.read(loaderProvider.notifier).state = true;
      if (isShowSendButton) {
        final currentUserData =
            await ref.read(authControllerProvider).getUserData();
        final receiverUserData = await ref
            .read(authControllerProvider)
            .getUserDataByID(widget.recieverUserId);

        final response =
            await ref.read(httpControllerProvider).storeDataToBlockchain(
                  attachment: "NONE",
                  message: _messageController.text.trim(),
                  sender: currentUserData!.uid,
                  receiver: receiverUserData!.uid,
                  isSpam: isSus.toString(),
                );

        if (response.code == 200) {
          ref.read(loaderProvider.notifier).state = false;
          ref.read(chatControllerProvider).sendTextMessage(
                context: context,
                text: _messageController.text.trim(),
                recieverUserId: widget.recieverUserId,
                blockId: response.id.toString(),
                isForwarded: false,
                messageForwardedCount: 0,
              );
        }

        setState(() {
          _messageController.text = "";
        });
      }
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) async {
    final currentUserData =
        await ref.read(authControllerProvider).getUserData();
    final receiverUserData = await ref
        .read(authControllerProvider)
        .getUserDataByID(widget.recieverUserId);

    final response =
        await ref.read(httpControllerProvider).storeDataToBlockchain(
              attachment: "NONE",
              message: _messageController.text.trim(),
              sender: currentUserData!.phoneNumber.toString(),
              receiver: receiverUserData!.phoneNumber.toString(),
              isSpam: isSus.toString(),
            );
    if (response.code == 200) {
      ref.read(chatControllerProvider).sendFileMessage(
            context: context,
            file: file,
            recieverUserId: widget.recieverUserId,
            messageEnum: messageEnum,
            blockId: response.id.toString(),
            isForwarded: false,
            messageForwardedCount: 0,
          );
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 2, left: 2),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton ? Icons.send : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
