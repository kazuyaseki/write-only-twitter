import 'package:flutter/material.dart';
import 'package:write_only_twitter/src/Widgets/Button.dart';
import 'package:write_only_twitter/src/screens/HomeScreen.dart';
import 'package:write_only_twitter/src/theme/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryTwitterBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Write Only", style: TextStyle(
              color: WhiteText,
            )),
            const Text("Twitter", style: TextStyle(
              color: WhiteText,
            )),
            Button(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                text: "Login with Twitter")
          ],
        ),
      ),
    );
  }
}
