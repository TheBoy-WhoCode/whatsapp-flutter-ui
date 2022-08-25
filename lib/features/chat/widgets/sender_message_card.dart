import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_ui/features/chat/widgets/display_text_image_gif.dart';
import 'package:whatsapp_ui/models/message.dart';
import 'package:whatsapp_ui/services/controller/http_controller.dart';

class SenderMessageCard extends ConsumerWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.messageId,
    required this.isForwarded,
    required this.messageForwardCount,
    
  }) : super(key: key);

  final String message;
  final String senderId;
  final String receiverId;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final String messageId;
  final bool isForwarded;
  final int messageForwardCount;

  void forwardMessage(BuildContext context, Message message) {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ContactsList(
            message: message,
            isForwarded: true,
          );
        });
  }

  void reportMessage({
    required BuildContext context,
    required Message message,
    required WidgetRef ref,
  }) async {
    logger.d("report message function called");
    final response =
        await ref.read(httpControllerProvider).reportMessage(message.blockId);
    if (response.code == 200) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Message Reported Successfully.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
    }
  }

  void onLongPressMessage({
    required WidgetRef ref,
    required String messageId,
    required String receiverId,
    required String senderId,
    required BuildContext context,
  }) async {
    final message = await ref.read(chatControllerProvider).getMessageByID(
          messageId: messageId,
          senderId: senderId,
          receiverId: receiverId,
        );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.share),
              title: const Text('Forward'),
              onTap: () {
                forwardMessage(context, message!);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.exclamation),
              title: const Text('Report'),
              onTap: () => reportMessage(
                context: context,
                ref: ref,
                message: message!,
              ),
            ),
            const ListTile(
              leading: Icon(Icons.copy),
              title: Text('Copy'),
            ),
          ],
        );
      },
    );
  }

  void onTapMessage() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: InkWell(
            onLongPress: () => onLongPressMessage(
              receiverId: receiverId,
              senderId: senderId,
              messageId: messageId,
              ref: ref,
              context: context,
            ),
            onTap: onTapMessage,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: senderMessageColor,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                            bottom: 30,
                          ),
                    child: Column(
                      children: [
                        if (isReplying) ...[
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            child: DisplayTextImageGif(
                              message: repliedText,
                              type: repliedMessageType,
                              isForwarded: isForwarded,
                              messageForwardCount: messageForwardCount,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                        DisplayTextImageGif(
                          message: message,
                          type: type,
                          isForwarded: isForwarded,
                           messageForwardCount: messageForwardCount,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 10,
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
