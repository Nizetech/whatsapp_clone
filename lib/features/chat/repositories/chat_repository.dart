import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enum/message_enums.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/meessage.dart';

import '../../../common/providers/message_reply_provider.dart';
import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy(
          'timestamp',
          //  descending: true
        )
        .snapshots()
        .asyncMap((event) async {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
        // print(messages);
      }
      return messages;
    });
  }

  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    // RECEIVER"S END-----
    // Users -> reciever user id -> chats -> current user id -> set data
    var receieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receieverChatContact.toMap());
    // SENDER"S END-----
    // Users -> current user id -> chats -> reciever user id -> set data
    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String receiverUsername,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required String receiverUserName,
  }) async {
    final message = Message(
      messageId: messageId,
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      timeSent: timeSent,
      isSeen: false,
      type: messageType,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : receiverUsername,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
// Users --> sender id --> reciever id --> message -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
// Users --> reciever id --> sender id --> message -> message id -> store message
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receivedUserId,
    required UserModel senderUserData,
    required MessageReply? messageReply,
  }) async {
// Users --> sender id --> reciever id --> message -> message id -> store message
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receivedUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      // Users -> reciever user id -> chats -> current user id -> set data
      //contact Sub-collection
      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
        senderUserData,
        receiverUserData,
        text,
        timeSent,
        receivedUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receivedUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUserData.name,
        messageReply: messageReply,
        receiverUserName: receiverUserData.name,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

// sharing image message
  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receivedUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$receivedUserId/$messageId',
              file);
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receivedUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵Photo';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDataToContactSubCollection(
        senderUserData,
        receiverUserData,
        contactMsg,
        timeSent,
        receivedUserId,
      );
      _saveMessageToMessageSubCollection(
        receiverUserId: receivedUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageType: messageEnum,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUserData.name,
        messageReply: messageReply,
        receiverUserName: receiverUserData.name,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receivedUserId,
    required UserModel senderUserData,
    required MessageReply? messageReply,
  }) async {
// Users --> sender id --> reciever id --> message -> message id -> store message
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receivedUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      // Users -> reciever user id -> chats -> current user id -> set data
      //contact Sub-collection
      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
        senderUserData,
        receiverUserData,
        'GIF',
        timeSent,
        receivedUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receivedUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUserData.name,
        messageReply: messageReply,
        receiverUserName: receiverUserData.name,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
