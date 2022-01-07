import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({required this.onPressed, required this.text, Key? key}) : super(key: key);

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.blue,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
