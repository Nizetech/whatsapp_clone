import 'package:flutter/material.dart';

class ErrorScreeen extends StatelessWidget {
  final String error;
  const ErrorScreeen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
