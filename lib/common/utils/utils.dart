import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text(
        content,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // duration: const Duration(seconds: 2),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImaage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImaage != null) {
      return File(pickedImaage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
    print(e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      return File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
    print(e.toString());
  }
  return video;
}

pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
        apiKey: 'v1itNRQwnnV2cr96xNr1Uj0yL4mZllpI', context: context);
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
    print(e.toString());
  }
  return gif;
}
