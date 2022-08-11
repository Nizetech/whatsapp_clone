import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import '../controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-information-screen';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.add_a_photo),
                  ),
                ),
              ]),
              Row(
                children: [
                  Container(
                    width: size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData,
                    icon: Icon(
                      Icons.done,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
