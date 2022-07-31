import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/screen_contact/screens/select_contact_screens.dart';
import 'package:whatsapp_clone/widgets/error.dart';

import 'features/chat/screens/mobile_chatScreen.dart';
import 'features/auth/otp_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/user_information_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => LoginScreen(),
      );
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OtpScreen(verificationId: verificationId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => UserInformationScreen(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => SelectContactScreen(),
      );

    case MobileChatScreen.routeName:
      Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;

      final name = arguments['user'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreeen(error: 'This page doesn\'t exist'),
              ));
  }
}
