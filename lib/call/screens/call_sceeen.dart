import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/call/controller/call_controller.dart';
import 'package:whatsapp_clone/common/widget/loader.dart';
import 'package:whatsapp_clone/config/agora_config.dart';
import 'package:whatsapp_clone/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    Key? key,
    required this.call,
    required this.channelId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  final String baseUrl = '';

  @override
  void initState() {
    super.initState();
    agoraConnectionData:
    AgoraConnectionData(
      appId: ArgoraConfig.appId,
      channelName: widget.channelId,
      tokenUrl: baseUrl,
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
              children: [
                AgoraVideoViewer(client: client!),
                AgoraVideoButtons(
                  client: client!,
                  disconnectButtonChild: IconButton(
                    onPressed: () async {
                      await client!.engine.leaveChannel();
                      ref.read(callControllerProvider).endCall(
                            widget.call.callerId,
                            widget.call.receiverId,
                            context,
                          );
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.call_end),
                  ),
                )
              ],
            )),
    );
  }
}
