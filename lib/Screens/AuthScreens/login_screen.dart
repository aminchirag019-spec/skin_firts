import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/textfield_validators.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Data/auth_model.dart';
import '../../Helper/app_localizations.dart';
import '../../Helper/sharedpref_helper.dart';
import '../../global/coustom_widgets.dart';
import '../../Utilities/media_query.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.welcomeScreen.path);
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
                  topRow(
                    context,
                    text: localization?.translate('logIn') ?? "Log In",
                    onPressed: () => context.go(RouterName.welcomeScreen.path),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Row(
                    children: [
                      Text(
                        localization?.translate('welcome') ?? "Welcome",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.height(context) * 0.004),
                        Text(
                          localization?.translate('loreum') ?? "loreum",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            letterSpacing: -0.7,
                            height: 0.9,
                            fontWeight: FontWeight.w300,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: AppSize.height(context) * 0.035),
                        Row(
                          children: [
                            Text(
                              localization?.translate('loginLabel') ??
                                  "Email or Mobile Number",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(context) * 0.005),
                        coustomTextField(
                          context: context,
                          controller: emailController,
                          hintText:
                              localization?.translate('emailExample') ??
                              "example@example.com",
                          validator: (value) =>
                              Validators().validateEmail(context, value),
                        ),
                        SizedBox(height: AppSize.height(context) * 0.017),
                        Row(
                          children: [
                            Text(
                              localization?.translate('password') ?? "password",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(context) * 0.005),
                        coustomTextField(
                          context: context,
                          controller: passwordController,
                          validator: (value) =>
                              Validators().validatePassword(context, value),
                          hintText: "••••••••",
                          image: const AssetImage(
                            "assets/images/obsecure_image.png",
                          ),
                        ),
                        SizedBox(height: AppSize.height(context) * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.go(RouterName.setPasswordScreen.path);
                              },
                              child: Text(
                                localization?.translate('forgotPass') ??
                                    "Forgot Password",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSize.width(context) * 0.025),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.035),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      if (state.loginStatus == LoginStatus.success) {
                        String? userId = await SharedPrefsHelper.getUserId();
                        if (userId != null) {
                          context.go(
                            RouterName.fingerAuthenticationScreen.path,
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state.loginStatus == LoginStatus.loading) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      return customButton(
                        context,
                        text: localization?.translate('logIn') ?? "Log In",
                        backgroundColor: colorScheme.primary,
                        textColor: Colors.white,
                        width: AppSize.width(context) * 0.512,
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
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          localization?.translate('signupOptionTitle') ??
                              "or sign up with",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
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
                        onTap: () {
                          if(!formKey.currentState!.validate()) return;
                          context.go(
                            RouterName.fingerAuthenticationScreen.path,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.041),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localization?.translate('dontHaveAccount') ??
                            "Don’t have an account?",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005),
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.signupScreen.path);
                        },
                        child: Text(
                          localization?.translate('signUp') ?? "Sign Up",
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
