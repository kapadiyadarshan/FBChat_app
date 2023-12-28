import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app/utils/colors.util.dart';
import 'package:new_chat_app/utils/routes_utils.dart';

import '../../helpers/auth_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

bool selected = false;

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    selected = !selected;

    Timer.periodic(const Duration(seconds: 4), (timer) {
      Navigator.of(context).pushReplacementNamed(
        (AuthHelper.authHelper.firebaseAuth.currentUser != null)
            ? MyRoute.HomePage
            : MyRoute.LoginPage,
      );
      timer.cancel();
    });
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          height: selected ? 400 : 260,
          decoration: BoxDecoration(
            color: MyColor.color1,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: 230.0,
            child: DefaultTextStyle(
              style: GoogleFonts.philosopher(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: MyColor.color3,
              ),
              textAlign: TextAlign.center,
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText("SociaBay"),
                ],
                isRepeatingAnimation: false,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ),
        ),
      ),
      backgroundColor: MyColor.color3,
    );
  }
}
