import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
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
  }
  return image;
}
