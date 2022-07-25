import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp_clone/Screens/mobile_layout_screen.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/otp_screen.dart';

import '../../models/user_model.dart';
import 'screens/user_information_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    firebaseStorage: FirebaseStorage.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  AuthRepository(
      {required this.auth,
      required this.firestore,
      required this.firebaseStorage});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          // push named file
          Navigator.pushNamed(context, OtpScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
        context,
        UserInformationScreen.routeName,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
    // ProviderRef is one provider that is used to get the current user from the authRepository Provider. and its also used to interact with another provider
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
        // UploadTask uploadTask =
        //     firebaseStorage.ref().child('profilePic/$uid').putFile(profilePic);
        // TaskSnapshot snap = await uploadTask;
        // photoUrl = await snap.ref.getDownloadURL();
      }

      // return photoUrl;
      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.uid,
        groupId: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileLayoutScreen(),
          ),
          (route) => false);
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
