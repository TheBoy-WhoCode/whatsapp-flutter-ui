import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isForwarded;
  const DisplayTextImageGif({
    Key? key,
    required this.message,
    required this.type,
    required this.isForwarded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isForwarded
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.share,
                          size: 14,
                        ),
                        Text(
                          " forwarded",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
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
