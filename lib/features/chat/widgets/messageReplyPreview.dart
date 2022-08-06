import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.read(messageReplyProvider);
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.all(8),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Text(
                messageReply!.isMe ? 'Me' : 'Opposite',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              child: Icon(
                Icons.close,
                size: 16,
              ),
              onTap: () => cancelReply(ref),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        DisplayTextImageGIF(
            message: messageReply.message, type: messageReply.messageEnum)
      ]),
    );
  }
}
