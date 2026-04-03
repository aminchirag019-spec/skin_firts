import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:skin_firts/Utilities/colors.dart';
import '../../Global/custom_widgets.dart';
import '../../Helper/app_localizations.dart';
import '../../router/router_class.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formKey = GlobalKey<FormState>();
    final localization = AppLocalizations.of(context);

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
                    text: localization?.translate('setPassword') ?? "Set Password",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localization?.translate('loreum') ?? "",
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
                        localization?.translate('passwordLable') ?? "Password",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  customTextField(
                    context: context,
                    hintText: "••••••••",
                    image: const AssetImage("assets/images/obsecure_image.png"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        localization?.translate('confirmPass') ?? "Confirm Password",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  customTextField(
                    context: context,
                    hintText: "••••••••",
                    image: const AssetImage("assets/images/obsecure_image.png"),
                  ),
                  const SizedBox(height: 30),
                  customButton(
                    context,
                    text: localization?.translate('createNewPass') ?? "Create New Password",
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
