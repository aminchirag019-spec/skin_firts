import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Global/enums.dart';

import 'package:skin_firts/Utilities/textfield_validators.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Data/auth_model.dart';
import '../../Helper/app_localizations.dart';
import '../../router/router_class.dart';
import '../../Utilities/media_query.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.loginScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.064,
              vertical: AppSize.height(context) * 0.017,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label:  Text(localization?.translate("user") ?? "user"),
                            selected: state.selectedRole == "user",
                            onSelected: (_) {
                              context.read<AuthBloc>().add( SelectRoleEvent("user"));
                            },
                          ),
                           SizedBox(width: 10),
                          ChoiceChip(
                            label: Text(localization?.translate('doctors') ?? "Doctor"),
                            selected: state.selectedRole == "doctor",
                            onSelected: (_) {
                              context.read<AuthBloc>().add( SelectRoleEvent("doctor"));
                            },
                          ),
                        ],
                      );
                    },
                  ),
                   SizedBox(height: 15),
                  topRow(
                    context,
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                    text: localization?.translate('New Account') ?? "New Account",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Row(
                    children: [
                      Text(
                        localization?.translate('fullname') ?? "Full name",
                        style: theme.textTheme.titleLarge?.copyWith(
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
                          hintText: localization?.translate('nameExample') ?? "Enter Your Name",
                          size: 20,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014),
                        Row(
                          children: [
                            Text(
                              localization?.translate('passwordLable') ?? "Password",
                              style: theme.textTheme.titleLarge?.copyWith(
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
                              image: const AssetImage("assets/images/obsecure_image.png"),
                            );
                          },
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014),
                        Row(
                          children: [
                            Text(
                              localization?.translate('email') ?? "Email",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        coustomTextField(
                          context: context,
                          hintText: localization?.translate('emailExample') ?? "example@example.com",
                          controller: emailController,
                          size: 20,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014),
                        Row(
                          children: [
                            Text(
                              localization?.translate('mobile') ?? "Mobile Number",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        coustomTextField(
                          context: context,
                          maxLength: 10,
                          textInputType: TextInputType.number,
                          hintText: localization?.translate('numberExample') ?? "+91 0000000000",
                          h: 16,
                          w: 13,
                          controller: phoneController,
                          size: 18,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.014),
                        Row(
                          children: [
                            Text(
                              localization?.translate('dob') ?? "Date of birth",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        coustomTextField(
                          context: context,
                          hintText: localization?.translate('dobExample') ?? "DD / MM /YYY",
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
                              dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            }
                          },
                        ),
                        SizedBox(height: AppSize.height(context) * 0.017),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localization?.translate('byContinuing') ?? "By continuing, you agree to",
                              style: theme.textTheme.bodySmall?.copyWith(
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
                        localization?.translate('terms') ?? "Terms of Use",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005),
                      Text(
                        localization?.translate('and') ?? "and",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005),
                      Text(
                        localization?.translate('privacy') ?? "Privacy Policy",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
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
                        text: localization?.translate('signUp') ?? "Sign Up",
                        backgroundColor: colorScheme.primary,
                        width: AppSize.width(context) * 0.538,
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
                                    role: state.selectedRole.toString(),
                                    uid: "",
                                  ),
                                ),
                              );
                        },
                      );
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          localization?.translate('signupOptionTitle') ?? "or sign up with",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.009),
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
                  SizedBox(height: AppSize.height(context) * 0.035),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localization?.translate('already') ?? "already have an account?",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005),
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.loginScreen.path);
                        },
                        child: Text(
                          localization?.translate('logIn') ?? "Log In",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
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
