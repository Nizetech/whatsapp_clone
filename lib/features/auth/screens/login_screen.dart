import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
// import 'package:riverpod/riverpod.dart';
import 'package:whatsapp_clone/common/widget/customButton.dart';
import 'package:whatsapp_clone/features/controller/auth_controller.dart';

import '../../../common/utils/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String countryCode = '91';
  final phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            countryCode = country.phoneCode;
          });
        });
  }

  void signInWithPhone() {
    String phoneNumber = phoneController.text.trim();
    if (countryCode != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+$countryCode$phoneNumber');
      // Widget ref => makes widget interact with the provider
      // "read" in provider is  => Provider.of<T>(context, listen: false) instead use context.read
    } else {
      showSnackBar(context: context, content: 'Please enter phone number');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enter your phone number'),
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('WhatsApp will need to verify your phone number'),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: pickCountry, child: const Text('Pick Country')),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (countryCode != null) Text('+${countryCode}'),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'phone number',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * .55),
                SizedBox(
                    width: 90,
                    child:
                        CustomButton(onPressed: signInWithPhone, text: 'Next'))
              ],
            ),
          ),
        ));
  }
}
