import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/global/app_string.dart';
import 'package:skin_firts/router/router_class.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';

import '../../global/coustom_widgets.dart';

class LoginScreen_1 extends StatelessWidget {
  const LoginScreen_1({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.go(RouterName.signupScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  topRow(
                    text: "Hello!",
                    context,
                    onPressed: () => context.go(RouterName.loginScreen.path),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        AppString.welcome,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2260FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        AppString.loginLabel,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  coustomTextField(hintText: AppString.emailExample, size: 20),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        AppString.passwordLable,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  coustomTextField(hintText: "••••••••",image: AssetImage("assets/images/obsecure_image.png")),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppString.forgotPass,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2260FF),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 30),
                  customButton(
                    text: AppString.logIn,
                    backgroundColor: Color(0xff2260FF),
                    textColor: Colors.white,
                    onPressed: () {
                      context.go(RouterName.setPasswordScreen.path);
                    },
                    width: 200,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          AppString.signupOptionTitle,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  loginRow(

                    icons: [LoginRow(svgPath: "assets/images/finger_svg.svg",)],
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.dontHaveAccount,
                        style: GoogleFonts.leagueSpartan(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        AppString.signUp,
                        style: GoogleFonts.leagueSpartan(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff2260FF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
