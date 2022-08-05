import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/common/enum/message_enums.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

import '../../../colors.dart';
import '../../../common/utils/utils.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({
    required this.receiverUserId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isShowEmoji = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    } else {
      var temDir = await getTemporaryDirectory();
      var path = '${temDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(
        image,
        MessageEnum.image,
      );
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(
        video,
        MessageEnum.video,
      );
    }
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmoji = true;
    });
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      print(gif);
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url,
            widget.receiverUserId,
          );
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmoji = false;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiContainer() {
    if (isShowEmoji) {
      hideEmojiContainer();
      showKeyboard();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: toggleEmojiContainer,
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectGIF,
                          icon: Icon(
                            Icons.gif,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
              child: CircleAvatar(
                backgroundColor: Color(0xff128c7e),
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        isShowEmoji
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                    textEditingController: _messageController,
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        _messageController.text =
                            _messageController.text + emoji.emoji;
                      });

                      if (!isShowSendButton) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      }
                    }),
              )
            : const SizedBox(),
      ],
    );
  }
}
