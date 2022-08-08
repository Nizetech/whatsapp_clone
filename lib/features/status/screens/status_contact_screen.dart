import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widget/loader.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';
import 'package:whatsapp_clone/features/status/screens/status_screen.dart';

import '../../../models/status_model.dart';

class StatusContactScreen extends ConsumerWidget {
  StatusContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, StatusScreen.routeName,
                        arguments: statusData);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                        style: TextStyle(fontSize: 18),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: dividerColor,
                  indent: 85,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
