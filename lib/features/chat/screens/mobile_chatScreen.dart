import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/repositories/auth_controller.dart';

import '../../../Utils/info.dart';
import '../../../colors.dart';
import '../../../common/widget/loader.dart';
import '../../../models/user_model.dart';
import '../../../widgets/chat_list.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile_chat_screen';
  final String name;
  final String uid;
  const MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: StreamBuilder<UserModel>(
              stream: ref.read(authControllerProvider).userDataById(uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loader();
                }
                return Column(
                  children: [
                    Text(
                      name,
                      // 'Fortune'
                    ),
                    Text(
                      snapshot.data!.isOnline ? 'Online' : 'Offline',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              }),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverUserId: uid,
              ),
            ),
            BottomChatField(
              receiverUserId: uid,
            ),
          ],
        ));
  }
}
