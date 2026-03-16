import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../global/app_string.dart';
import '../../global/coustom_widgets.dart';
import '../../global/image_class.dart';
import '../../Utilities/media_query.dart';

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
          SizedBox(height: AppSize.height(context) * 0.130), // 110
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(context) * 0.051,
              ), // 20
              child: Column(
                children: [
                  const Image(
                    image: AssetImage("assets/images/welcome_image.png"),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.016), // 14
                  Text(
                    AppString.skin,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: AppSize.width(context) * 0.123, // 48
                      height: 0.8,
                      fontWeight: FontWeight.w200,
                      color: const Color(0xff2260FF),
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.020), // 17
                  Text(
                    AppString.dermetology,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: AppSize.width(context) * 0.043, // 17
                      color: const Color(0xff2260FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.082), // 70
                  Text(
                    AppString.Loreum,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: AppSize.width(context) * 0.035, // 14
                      height: 0.9,
                      letterSpacing: -0.6,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff070707),
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.035), // 30
                  customButton(
                    context,
                    text: AppString.logIn,
                    width: AppSize.width(context) * 0.512, // 200
                    backgroundColor: const Color(0xff2260FF),
                    textColor: Colors.white,
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.009), // 8
                  customButton(
                    context,
                    width: AppSize.width(context) * 0.512, // 200
                    text: AppString.signUp,
                    backgroundColor: const Color(0xffCAD6FF),
                    textColor: const Color(0xff2260FF),
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
