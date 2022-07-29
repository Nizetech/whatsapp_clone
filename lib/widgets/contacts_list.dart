import 'package:flutter/material.dart';

import '../features/chat/screens/mobile_chatScreen.dart';
import '../Utils/info.dart';

class ContactList extends StatelessWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MobileChatScreen(
                        name: 'Abraham',
                        uid: '12345',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      info[index]['name'].toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        info[index]['message'].toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(info[index]['profilePic'].toString()),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
