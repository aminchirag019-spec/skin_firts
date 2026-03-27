import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../global/app_string.dart';
import '../../global/coustom_widgets.dart';
import '../../Utilities/media_query.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppSize.height(context) * 0.130),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(context) * 0.051,
              ),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage("assets/images/welcome_image.png"),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.016),
                  Text(
                    AppString.skin,
                    style: theme.textTheme.displayMedium?.copyWith(
                      height: 0.8,
                      fontWeight: FontWeight.w200,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.020),
                  Text(
                    AppString.dermetology,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.082),
                  Text(
                    AppString.Loreum,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.2,
                      letterSpacing: -0.6,
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.035),
                  customButton(
                    context,
                    text: AppString.logIn,
                    width: AppSize.width(context) * 0.512,
                    backgroundColor: colorScheme.primary,
                    textColor: Colors.white,
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.009),
                  customButton(
                    context,
                    width: AppSize.width(context) * 0.512,
                    text: AppString.signUp,
                    backgroundColor: colorScheme.secondary,
                    textColor: colorScheme.primary,
                    onPressed: () => context.go(RouterName.signupScreen.path),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
