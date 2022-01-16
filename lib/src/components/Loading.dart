import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:write_only_twitter/src/theme/colors.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("home"),
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: const Color(0x55000000),
          child: Center(
              child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SpinKitRing(
              color: PrimaryTwitterBlue,
              size: 60.0,
            ),
          )),
        ));
  }
}
