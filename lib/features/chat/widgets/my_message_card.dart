import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enum/message_enums.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  const MyMessageCard(
      {Key? key, required this.date, required this.message, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
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
                  padding:
                      EdgeInsets.only(left: 10, right: 30, top: 5, bottom: 20),
                  child: DisplayTextImageGIF(
                    message: message,
                    type: type,
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
                    Icon(Icons.done_all, color: Colors.white60),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}