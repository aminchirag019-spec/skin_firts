import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../global/app_string.dart';
import '../../global/coustom_widgets.dart';
import '../../global/image_class.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 110),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image(image: AssetImage("assets/images/welcome_image.png")),
                  SizedBox(height: 14),
                  Text(
                    AppString.skin,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 48,
                      height: 0.8,
                      fontWeight: FontWeight.w200,
                      color: Color(0xff2260FF),
                    ),
                  ),
                  SizedBox(height: 17),
                  Text(
                    AppString.dermetology,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 17,
                      color: Color(0xff2260FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 70),
                  Text(
                    AppString.Loreum,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      height: 0.9,
                      letterSpacing: -0.6,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff070707),
                    ),
                  ),
                  SizedBox(height: 30),
                  customButton(
                    text: AppString.logIn,
                    width: 200,
                    backgroundColor: Color(0xff2260FF),
                    textColor: Colors.white,
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                  ),
                  SizedBox(height: 8),
                  customButton(
                    width: 200,
                    text: AppString.signUp,
                    backgroundColor: Color(0xffCAD6FF),
                    textColor: Color(0xff2260FF),
                    onPressed: () => context.go(RouterName.signupScreen.path),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
