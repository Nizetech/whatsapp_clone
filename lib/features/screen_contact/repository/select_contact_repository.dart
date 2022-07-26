import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chatScreen.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

import '../../../../models/user_model.dart';

final selectContactRepositoryProvider = Provider((ref) {
  return SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  );
});

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          print(userData.name);
          // print(userData);
          print(userData.uid);
          print(userData.phoneNumber);
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            // arguments: userData.uid,
            arguments: {
              'user': userData.name,
              'uid': userData.uid,
            },
          );
        }
      }
      print(selectContact.phones[0].number);
      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This PhoneNumber Does Not Exist on This App',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
