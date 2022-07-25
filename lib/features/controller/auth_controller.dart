import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp_clone/features/auth/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
// Provider.of<AuthRepository>(context)
  return AuthController(authRepository: authRepository, ref: ref);
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilepic) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilepic, ref: ref, context: context);
  }
}
