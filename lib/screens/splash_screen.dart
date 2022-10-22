import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/log_in_screen.dart';
import 'package:todo_app/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, LogInScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: getHeight(context),
        width: getWidth(context),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xff2A2A2E),
              Color(0xff2B125A),
              Color(0xff2A2A2E)
            ])),
        child: const Center(
            child: Text(
          'on.time',
          style: TextStyle(
              fontSize: 40, color: Colors.white, fontWeight: FontWeight.w700),
        )),
      ),
    );
  }
}
