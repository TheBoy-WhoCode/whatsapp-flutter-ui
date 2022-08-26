import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isForwarded;
  final int messageForwardCount;
  final bool isSpam;
  const DisplayTextImageGif({
    Key? key,
    required this.message,
    required this.type,
    required this.isForwarded,
    required this.messageForwardCount,
    required this.isSpam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isForwarded || isSpam
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isSpam && isForwarded
                            ? Row(
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.triangleExclamation,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.share,
                                    size: 14,
                                  ),
                                ],
                              )
                            : isForwarded
                                ? const FaIcon(
                                    FontAwesomeIcons.share,
                                    size: 14,
                                  )
                                : isSpam
                                    ? const FaIcon(
                                        FontAwesomeIcons.triangleExclamation,
                                        size: 14,
                                        color: Colors.red,
                                      )
                                    : const SizedBox(),
                        messageForwardCount >= 5
                            ? const Text(
                                " forwarded many times",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            : isForwarded
                                ? const Text(
                                    " forwarded",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )
                                : const SizedBox(),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 8,
              ),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : CachedNetworkImage(imageUrl: message);
  }
}
