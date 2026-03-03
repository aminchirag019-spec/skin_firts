import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/global/coustom_widgets.dart';
import 'package:skin_firts/global/image_class.dart';
import 'package:skin_firts/screens/authScreens/login_screen.dart';

import '../../global/app_string.dart';
import '../../router/router_class.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController passController = TextEditingController();
    TextEditingController passController1 = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async{
        context.go(RouterName.loginScreen1.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: [
                topRow(
                  context,
                  onPressed: () {
                    context.go(RouterName.loginScreen.path);
                  },
                  text: "Set Password",
                ),
                SizedBox(height: 10),
                Text(
                  AppString.loreum,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 15,
                    letterSpacing: -1.0,
                    height: 0.9,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff070707),
                  ),
                ),
                SizedBox(height: 20),
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
                coustomTextField(hintText: "••••••••",image: AssetImage("assets/images/obsecure_image.png")),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      AppString.confirmPass,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                coustomTextField(hintText: "••••••••",image: AssetImage("assets/images/obsecure_image.png")),
                SizedBox(height: 30),
                customButton(
                  text: "Create New Password",
                  fontSize: 23,
                  backgroundColor: Color(0xff2260FF),
                  width: 280,
                  textColor: Colors.white,
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    context.go(RouterName.loginScreen1.path);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
