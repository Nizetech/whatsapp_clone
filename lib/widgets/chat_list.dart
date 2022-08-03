import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/models/meessage.dart';
import 'package:intl/intl.dart';
import '../Utils/info.dart';
import '../common/widget/loader.dart';
import '../features/chat/controller/chat_controller.dart';
import '../features/chat/widgets/my_message_card.dart';
import '../features/chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({Key? key, required this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Loader(),
            );
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(
              messageController.position.maxScrollExtent,
              // duration: Duration(milliseconds: 300),
              // curve: Curves.easeOut,
            );
          });
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messagData = snapshot.data![index];
              print(messagData.text);
              var timeSent = DateFormat.Hm().format(messagData.timeSent);
              if (messagData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messagData.text,
                  date: timeSent,
                  type: messagData.type,
                );
              }
              return SenderMessageCard(
                message: messagData.text,
                date: timeSent,
              );
            },
          );
        });
  }
}
