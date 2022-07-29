// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CommonFirebaseStorageRipository(
      firebaseStorage: FirebaseStorage.instance),
);

class CommonFirebaseStorageRipository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageRipository({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}
