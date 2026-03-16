import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Screens/ProfileScreen/add_doctor_screen.dart';

import '../../Global/app_string.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';

class PasswordManagerScreen extends StatelessWidget {
  const PasswordManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.go(RouterName.settingScreen.path);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.064, // 25
              vertical: AppSize.height(context) * 0.023,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  topRow(
                    context,
                    onPressed: () => context.go(RouterName.settingScreen.path),
                    text: " Password Manager",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  title(context, title: "Current Password"),
                  coustomTextField(
                    context: context,
                    hintText: "••••••••",
                    image: AssetImage("assets/images/obsecure_image.png"),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.setPasswordScreen.path);
                        },
                        child: Text(
                          "${AppString.forgotPass}?",
                          style: GoogleFonts.leagueSpartan(
                            fontSize: AppSize.width(context) * 0.043, // 13
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff2260FF),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.025), // 10
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  title(context, title: "New Password"),
                  coustomTextField(
                    context: context,
                    hintText: "••••••••",
                    image: AssetImage("assets/images/obsecure_image.png"),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.021),
                  title(context, title: "Confirm Password"),
                  coustomTextField(
                    context: context,
                    hintText: "••••••••",
                    image: AssetImage("assets/images/obsecure_image.png"),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.4),
                  customButton(
                    context,
                    text: "Change Password",
                    backgroundColor: Color(0xff2260FF),
                    fontSize: 20,
                    width: 280,
                    textColor: Colors.white,
                    onPressed: () {},
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
