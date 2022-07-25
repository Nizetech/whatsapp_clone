import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);
  static const String routeName = '/otp-screen';
  final String verificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
      ref.read(authControllerProvider).verifyOTP(
            context,
            verificationId,
            userOTP,
          );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Veryfying your number'),
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              const Text(
                'We have sent an SMS with a code',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.length == 6) {
                      verifyOTP(ref, context, value.trim());
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
