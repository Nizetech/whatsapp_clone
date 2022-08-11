import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/status/repositories/status_repositories.dart';
import '../../../models/status_model.dart';
import '../../auth/controller/auth_controller.dart';

// final statusControllerProvider = Provider((ref) {
//   return StatusController(read: ref.read);
// });

// class StatusController {
//   final Reader read;
//   StatusController({required this.read});

//   Future<void> addStatus(File file, BuildContext context) async {
//     final value = await read(userDataAuthProvider);
//     final statusRepository = read(statusRepositoryProvider);
//     statusRepository.uploadStatus(
//       username: value.name,
//       profilePic: value.profilePic,
//       phoneNumber: value.phoneNumber,
//       statusImage: file,
//       context: context,
//     );
//   }

//   Future<List<Status>> getStatus(BuildContext context) async {
//     List<Status> statuses = await statusRepository.getStatus(context);
//     return statuses;
//   }
// }

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(
    statusRepository: statusRepository,
    ref: ref,
  );
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
        context: context,
      );
    });
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
