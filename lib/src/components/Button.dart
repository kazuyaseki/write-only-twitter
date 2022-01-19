import 'package:flutter/material.dart';
import 'package:write_only_twitter/src/theme/colors.dart';

class Button extends StatelessWidget {
  const Button({required this.onPressed, required this.text, Key? key})
      : super(key: key);

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: PrimaryTwitterBlue,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          shape: const StadiumBorder()),
      onPressed: onPressed,
      child: Text(text),
    );
    // return ElevatedButton(
    //   onPressed: onPressed,
    //   child: Text(text),
    //   style: ElevatedButton.styleFrom(shape: StadiumBorder()),
    // );
  }
}
