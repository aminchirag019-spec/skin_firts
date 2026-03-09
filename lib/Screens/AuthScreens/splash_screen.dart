import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/global/app_string.dart';
import 'package:skin_firts/global/image_class.dart';
import 'package:skin_firts/router/router_class.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplash();
  }
  void startSplash() {
    Timer(const Duration(seconds: 5), () {
      context.go(RouterName.welcomeScreen.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2260FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/splash_image.png"),
            SizedBox(height: 15),
            Text(
              AppString.skin,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                fontSize: 48,
                height: 0.8,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 17),
            Text(
              AppString.dermetology,
              style: GoogleFonts.leagueSpartan(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
