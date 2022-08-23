import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_ui/features/chat/widgets/display_text_image_gif.dart';
import 'package:whatsapp_ui/models/message.dart';

class MyMessageCard extends ConsumerStatefulWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  final bool isForwarded;
  final String senderId;
  final String receiverId;
  final String messageId;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
    required this.isForwarded,
    required this.senderId,
    required this.receiverId,
    required this.messageId,
  }) : super(key: key);

  @override
  ConsumerState<MyMessageCard> createState() => _MyMessageCardState();
}

class _MyMessageCardState extends ConsumerState<MyMessageCard> {
  bool isMessageSelected = false;

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
  Widget build(BuildContext context) {
    final isReplying = widget.repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: widget.onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: InkWell(
            onLongPress: () => onLongPressMessage(
              receiverId: widget.receiverId,
              senderId: widget.senderId,
              messageId: widget.messageId,
              ref: ref,
              context: context,
            ),
            onTap: onTapMessage,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: isMessageSelected ? Colors.blue : messageColor,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: widget.type == MessageEnum.text
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
                            widget.username,
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
                              message: widget.repliedText,
                              type: widget.repliedMessageType,
                              isForwarded: widget.isForwarded,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                        DisplayTextImageGif(
                          message: widget.message,
                          type: widget.type,
                          isForwarded: widget.isForwarded,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          widget.date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          widget.isSeen ? Icons.done_all : Icons.done,
                          size: 20,
                          color: widget.isSeen ? Colors.blue : Colors.white60,
                        ),
                      ],
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
