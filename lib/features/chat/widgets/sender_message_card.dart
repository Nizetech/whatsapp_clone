import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image.dart';

import '../../../common/enum/message_enums.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  // final VoidCallback onRightSwipe;
  // final String repliedText;
  // final String userName;
  // final MessageEnum repliedMessageType;
  const SenderMessageCard({
    Key? key,
    required this.type,
    required this.message,
    required this.date,
    // required this.onRightSwipe,
    // required this.repliedText,
    // required this.userName,
    // required this.repliedMessageType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: () {
        print('right swipe');
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: senderMessageColor,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10, right: 30, top: 5, bottom: 20)
                      : const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 25),
                  child: Column(
                    children: [
                      // if (isReplying) ...{
                      //   Text(
                      //     username,
                      //     style: TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      //   SizedBox(height: 3),
                      //   Container(
                      //     padding: EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //       color: backgroundColor.withOpacity(0.5),
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     child: DisplayTextImageGIF(
                      //       message: message,
                      //       type: type,
                      //     ),
                      //   ),
                      //   SizedBox(height: 8),
                      // },
                      DisplayTextImageGIF(
                        message: message,
                        type: type,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  left: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.done_all, color: Colors.white60),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
