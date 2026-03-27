import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/global/coustom_widgets.dart';
import '../../global/app_string.dart';
import '../../router/router_class.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.loginScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  topRow(
                    context,
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                    text: "Set Password",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppString.loreum,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      letterSpacing: -1.0,
                      height: 0.9,
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        AppString.passwordLable,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  coustomTextField(
                    context: context,
                    hintText: "••••••••",
                    image: const AssetImage("assets/images/obsecure_image.png"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        AppString.confirmPass,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  coustomTextField(
                    context: context,
                    hintText: "••••••••",
                    image: const AssetImage("assets/images/obsecure_image.png"),
                  ),
                  const SizedBox(height: 30),
                  customButton(
                    context,
                    text: "Create New Password",
                    fontSize: 23,
                    backgroundColor: colorScheme.primary,
                    width: 280,
                    textColor: Colors.white,
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      context.go(RouterName.loginScreen.path);
                    },
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
