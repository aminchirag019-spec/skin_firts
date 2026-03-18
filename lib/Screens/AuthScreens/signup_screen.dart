import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import 'package:skin_firts/Utilities/textfield_validators.dart';
import 'package:skin_firts/global/app_string.dart';
import 'package:skin_firts/global/coustom_widgets.dart';
import 'package:skin_firts/global/image_class.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Data/auth_model.dart';
import '../../Utilities/sharedpref_helper.dart';
import '../../router/router_class.dart';
import '../../Utilities/media_query.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController dobController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.loginScreen.path);
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
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                    text: "New Account",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  Row(
                    children: [
                      Text(
                        AppString.fullname,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: AppSize.width(context) * 0.053, // 21
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
                          context: context,
                          controller: nameController,
                          validator: Validators().validateEmail,
                          hintText: AppString.nameExample,
                          size: 20,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014), // 12
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
                        BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                          builder: (context, state) {
                            return coustomTextField(
                              context: context,
                              hintText: "••••••••",
                              obscureText: state.isPasswordHidden,
                              controller: passwordController,
                              image:  AssetImage(
                                  "assets/images/obsecure_image.png"),
                            );
                          },
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014), // 12
                        Row(
                          children: [
                            Text(
                              AppString.email,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.053, // 21
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        coustomTextField(
                          context: context,
                          hintText: AppString.emailExample,
                          controller: emailController,
                          size: 20,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014), // 12
                        Row(
                          children: [
                            Text(
                              AppString.mobile,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.053, // 21
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        coustomTextField(
                          context: context,
                          maxLength: 10,
                          textInputType: TextInputType.number,
                          hintText: AppString.numberExample,
                          h: 16,
                          w: 13,
                          controller: phoneController,
                          size: 18,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014), // 12
                        Row(
                          children: [
                            Text(
                              AppString.dob,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.053, // 21
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        coustomTextField(
                            context: context,
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
                            }),
                        SizedBox(height: AppSize.height(context) * 0.017), // 15
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppString.byContinuing,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.035, // 14
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
                          fontSize: AppSize.width(context) * 0.030, // 12
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff2260FF),
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005), // 2
                      Text(
                        AppString.and,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: AppSize.width(context) * 0.035, // 14
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005), // 2
                      Text(
                        AppString.privacy,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: AppSize.width(context) * 0.030, // 12
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff2260FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.signupStatus == SignupStatus.success) {
                        context.go(RouterName.fingerAuthenticationScreen.path);
                      }
                    },
                    builder: (context, state) {
                      if (state.signupStatus == SignupStatus.loading) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      return customButton(
                        context,
                        text: AppString.signUp,
                        backgroundColor: const Color(0xff2260FF),
                        width: AppSize.width(context) * 0.538,
                        // 210
                        textColor: Colors.white,
                        onPressed: () async {
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
                  SizedBox(height: AppSize.height(context) * 0.009), // 8
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
                        onTap: () =>
                            context.go(
                              RouterName.fingerAuthenticationScreen.path,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.035), // 30
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.already,
                        style: GoogleFonts.leagueSpartan(
                          fontWeight: FontWeight.w300,
                          fontSize: AppSize.width(context) * 0.035, // 14
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005), // 2
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.loginScreen.path);
                        },
                        child: Text(
                          AppString.logIn,
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
