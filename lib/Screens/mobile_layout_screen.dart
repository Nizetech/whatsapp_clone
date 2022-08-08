import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screen_contact/screens/select_contact_screens.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_contact_screen.dart';
import 'package:whatsapp_clone/repositories/auth_controller.dart';

import '../colors.dart';
import '../widgets/contacts_list.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserStae(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserStae(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(controller: tabBarController, children: [
          const ContactList(),
          StatusContactScreen(),
          const Text('Calls'),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (tabBarController.index == 0) {
                Navigator.pushNamed(context, SelectContactScreen.routeName);
              } else {
                File? pickedImage = await pickImageFromGallery(context);
                print(pickedImage);
                if (pickedImage != null) {
                  Navigator.pushNamed(
                    context,
                    ConfirmStatusScreen.routeName,
                    arguments: pickedImage,
                  );
                }
              }
            },
            backgroundColor: tabColor,
            child: Icon(
              Icons.comment,
              color: Colors.white,
            )),
      ),
    );
  }
}
