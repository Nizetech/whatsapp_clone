import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/enum/message_enums.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  // final VoidCallback onLeftSwipe;
  // final String repliedText;
  // final String userName;
  // final MessageEnum repliedMessageType;
  final bool isSeen;
  const MyMessageCard({
    Key? key,
    required this.date,
    required this.message,
    required this.type,
    // required this.onLeftSwipe,
    // required this.repliedText,
    // required this.userName,
    // required this.repliedMessageType
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: () {
        print('left swipe');
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
            // maxHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: messageColor,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: type == MessageEnum.text
                        ? EdgeInsets.only(
                            left: 10, right: 30, top: 5, bottom: 20)
                        : EdgeInsets.only(
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
                    )),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 13, color: Colors.white60),
                      ),
                      SizedBox(width: 5),
                      Icon(isSeen ? Icons.done_all : Icons.done,
                          color: isSeen ? Colors.blue : Colors.white60),
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
