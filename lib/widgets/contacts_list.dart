import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../common/widget/loader.dart';
import '../features/chat/screens/mobile_chatScreen.dart';
import '../Utils/info.dart';

class ContactList extends ConsumerWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (!snapshot.hasData) {
              return Center(
                child: Loader(),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContactData = snapshot.data![index];
                print(chatContactData);
                return Column(children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MobileChatScreen.routeName,
                          arguments: {
                            'user': chatContactData.name,
                            'uid': chatContactData.contactId,
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          chatContactData.name,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            chatContactData.lastMessage,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            chatContactData.profilePic,
                          ),
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatContactData.timeSent),
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
              Divider(
                    color: dividerColor,
                    indent: 85,
                  ),

                ]);
              },
            );
          }),
    );
  }
}
