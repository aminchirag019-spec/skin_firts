import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';
import 'package:skin_firts/Utilities/textfield_validators.dart';
import 'package:skin_firts/global/app_string.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Data/auth_model.dart';
import '../../global/coustom_widgets.dart';
import '../../Utilities/media_query.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.welcomeScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.064, // 25
              vertical: AppSize.height(context) * 0.017, // 15
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  topRow(
                    context,
                    text: AppString.logIn,
                    onPressed: () => context.go(RouterName.welcomeScreen.path),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  Row(
                    children: [
                      Text(
                        AppString.welcome,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: AppSize.width(context) * 0.061, // 24
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff2260FF),
                        ),
                      ),
                    ],
                  ),

                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.height(context) * 0.004), // 4
                        Text(
                          AppString.loreum,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: AppSize.width(context) * 0.035, // 14
                            letterSpacing: -0.7,
                            height: 0.9,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff070707),
                          ),
                        ),
                        SizedBox(height: AppSize.height(context) * 0.035), // 30
                        Row(
                          children: [
                            Text(
                              AppString.loginLabel,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.053, // 21
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(context) * 0.005), // 5
                        coustomTextField(
                          context: context,
                          controller: emailController,
                          hintText: AppString.emailExample,
                          h: 14,
                          w: 10,
                          validator: Validators().validateEmail,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.017), // 15
                        Row(
                          children: [
                            Text(
                              AppString.passwordLable,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.053, // 21
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(context) * 0.005), // 5
                        coustomTextField(
                          context: context,
                          controller: passwordController,
                          validator: Validators().validatePassword,
                          hintText: "••••••••",
                          image: const AssetImage("assets/images/obsecure_image.png"),
                        ),
                        SizedBox(height: AppSize.height(context) * 0.005), // 5
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
                                  fontSize: AppSize.width(context) * 0.033, // 13
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff2260FF),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSize.width(context) * 0.025), // 10
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.035), // 30
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) async {

                      if (state.loginStatus == LoginStatus.success) {

                        String? userId = await SharedPrefsHelper.getUserId();

                        if (userId != null) {
                          context.go(RouterName.fingerAuthenticationScreen.path);
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state.loginStatus == LoginStatus.loading) {
                        return  Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return customButton(
                        context,
                        text: AppString.logIn,
                        backgroundColor: const Color(0xff2260FF),
                        textColor: Colors.white,
                        width: AppSize.width(context) * 0.512, // 200
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          context.read<AuthBloc>().add(
                            LoginEvent(
                              loginModel: LoginModel(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          AppString.signupOptionTitle,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: AppSize.width(context) * 0.033, // 13
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  loginRow(
                    context,
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
                  SizedBox(height: AppSize.height(context) * 0.041), // 35
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.dontHaveAccount,
                        style: GoogleFonts.leagueSpartan(
                          fontWeight: FontWeight.w300,
                          fontSize: AppSize.width(context) * 0.035, // 14
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005), // 2
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.signupScreen.path);
                        },
                        child: Text(
                          AppString.signUp,
                          style: GoogleFonts.leagueSpartan(
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.width(context) * 0.035, // 14
                            color: const Color(0xff2260FF),
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
