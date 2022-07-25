import 'package:flutter/material.dart';
import 'package:whatsapp_clone/widgets/error.dart';

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
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreeen(error: 'This page doesn\'t exist'),
              ));
  }
}
