import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/global/app_string.dart';
import 'package:skin_firts/global/coustom_widgets.dart';
import 'package:skin_firts/global/image_class.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Data/auth_model.dart';
import '../../Utilities/sharedpref_helper.dart';
import '../../router/router_class.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController dobController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.loginScreen.path);
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
                    context,
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                    text: "New Account",
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        AppString.fullname,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        coustomTextField(
                          controller: nameController,
                          validator: validateEmail,
                          hintText: AppString.nameExample,
                          size: 20,
                        ),
                        SizedBox(height: 12),
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
                        coustomTextField(
                          hintText: "••••••••",
                          obscureText: true,
                          controller: passwordController,
                          image: AssetImage("assets/images/obsecure_image.png"),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              AppString.email,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        coustomTextField(
                          hintText: AppString.emailExample,
                          controller: emailController,
                          size: 20,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              AppString.mobile,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        coustomTextField(
                          hintText: AppString.numberExample,
                          h: 16,
                          w: 13,
                          controller: phoneController,
                          size: 18,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              AppString.dob,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        coustomTextField(
                          hintText: AppString.dobExample,
                          isBold: true,
                          controller: dobController,
                          size: 20,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              dobController.text =
                              "${pickedDate.day}/${pickedDate
                                  .month}/${pickedDate.year}";
                            }
                          } ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppString.byContinuing,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -0.3,
                                height: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.terms,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2260FF),
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        AppString.and,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        AppString.privacy,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2260FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.signupStatus == SignupStatus.success) {
                      context.go(RouterName.fingerAuthenticationScreen.path);
                    }
                  },
                  builder: (context, state) {
                    if (state.signupStatus == SignupStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return customButton(
                      text: AppString.signUp,
                      backgroundColor: const Color(0xff2260FF),
                      width: 210,
                      textColor: Colors.white,
                      onPressed: () async{
                        if (!formKey.currentState!.validate()) return;
                        context.read<AuthBloc>().add(
                          SignUpEvent(
                            signupModel: SignupModel(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              dob: dobController.text,
                              phone: phoneController.text,
                            ),
                          ),
                        );
                        String? userId = await SharedPrefsHelper.getUserId();

                        if (userId != null) {
                          await SharedPrefsHelper.setBiometricEnabled(true, userId);
                          print("true");
                        }

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
                  SizedBox(height: 8),
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
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.already,
                        style: GoogleFonts.leagueSpartan(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 2),
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.loginScreen.path);
                        },
                        child: Text(
                          AppString.logIn,
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
