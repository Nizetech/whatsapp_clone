import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/utils/colors.dart';
import '../../../common/widget/loader.dart';
import '../../../models/user_model.dart';
import '../../../widgets/chat_list.dart';
import '../../auth/controller/auth_controller.dart';
import '../../call/controller/call_controller.dart';
import '../../call/screens/call_pickup_screen.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile_chat_screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickUpScreen(
      scaffold: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: isGroupChat
                ? Text(name)
                : StreamBuilder<UserModel>(
                    stream: ref.read(authControllerProvider).userDataById(uid),
                    builder: (context, snapshot) {
                      print('no data');
                      if (!snapshot.hasData) {
                        return Loader();
                      }
                      return Column(
                        children: [
                          Text(
                            name,
                          ),
                          Text(
                            snapshot.data!.isOnline ? 'Online' : 'Offline',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }),
            centerTitle: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.video_call),
                onPressed: () => makeCall(ref, context),
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
                  isGroupChat: isGroupChat,
                ),
              ),
              BottomChatField(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ],
          )),
    );
  }
}
