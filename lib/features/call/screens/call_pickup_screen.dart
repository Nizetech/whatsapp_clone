import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/call/screens/call_sceeen.dart';

import '../../../../models/call.dart';
import '../controller/call_controller.dart';

class CallPickUpScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickUpScreen({Key? key, required this.scaffold}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled) {
            print('hasDialled');
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Icoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      call.callerName,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.call_end,
                              color: Colors.redAccent,
                            )),
                        SizedBox(
                          width: 25,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreen(
                                    call: call,
                                    channelId: call.callId,
                                    isGroupChat: false,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.call,
                              color: Colors.green,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
