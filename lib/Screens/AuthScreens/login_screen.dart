import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';
import 'package:skin_firts/global/app_string.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Data/auth_model.dart';
import '../../global/coustom_widgets.dart';

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Please enter the email";
  }
  return null;
}
String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Please enter your password";
  }
  return null;
}
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.welcomeScreen.path);
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
                    text: AppString.logIn,
                    context,
                    onPressed: () => context.go(RouterName.welcomeScreen.path),
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

                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 4),
                        Text(
                          AppString.loreum,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 14,
                            letterSpacing: -0.7,
                            height: 0.9,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff070707),
                          ),
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
                        coustomTextField(
                          controller: emailController,
                          hintText: AppString.emailExample,
                          h: 14,
                          w: 10,
                          validator: validateEmail,
                        ),
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
                        coustomTextField(
                          hintText: "••••••••",
                          image: AssetImage("assets/images/obsecure_image.png"),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.go(RouterName.setPasswordScreen.path);
                              },
                              child: Text(
                                AppString.forgotPass,
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2260FF),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.loginStatus == LoginStatus.success) {
                        context.go(RouterName.homeScreen.path);
                      }
                    },
                    builder: (context, state) {
                      if (state.loginStatus == LoginStatus.loading) {
                        return  Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return customButton(
                        text: AppString.logIn,
                        backgroundColor:  Color(0xff2260FF),
                        textColor: Colors.white,
                        width: 200,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          String? userId = await SharedPrefsHelper.getUserId();

                          if (userId != null) {

                            bool? biometricEnabled =
                            await SharedPrefsHelper.getBiometricEnabled(userId);

                            if (biometricEnabled == true) {
                              context.read<AuthBloc>().add(BiometricLoginEvent());
                              return;
                            }
                          }

                          context.read<AuthBloc>().add(
                            LoginEvent(
                              loginModel: LoginModel(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            ),
                          );
                          print(userId);
                          print(emailController);
                        },
                      );
                    },
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
                    icons: [
                      LoginRow(
                        svgPath: "assets/images/goole_svg.svg",
                        iconSize: 26,
                      ),
                      LoginRow(svgPath: "assets/images/facebook_svg.svg"),
                      LoginRow(
                        svgPath: "assets/images/finger_svg.svg",
                        onTap: () => context.go(
                          RouterName.fingerAuthenticationScreen.path,
                        ),
                      ),
                    ],
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
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.signupScreen.path);
                        },
                        child: Text(
                          AppString.signUp,
                          style: GoogleFonts.leagueSpartan(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xff2260FF),
                          ),
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
