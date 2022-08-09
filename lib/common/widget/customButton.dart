import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: blackColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: tabColor,
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }
}
