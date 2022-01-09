import 'package:flutter/material.dart';
import 'package:write_only_twitter/src/screens/HomeScreen.dart';
import 'package:write_only_twitter/src/screens/LoginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Write Only Twitter',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFF)
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
