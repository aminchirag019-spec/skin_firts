import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/LocaleBloc/locale_bloc.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Bloc/LocaleBloc/locale_event.dart';
import '../../Bloc/LocaleBloc/locale_state.dart';
import '../../Helper/app_localizations.dart';
import '../../global/custom_widgets.dart';
import '../../Utilities/media_query.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<LocaleBloc, LocaleState>(
                  builder: (context, state) {
                    return DropdownButton<String>(
                      value: state.locale.languageCode,
                      underline: const SizedBox(),
                      icon: Icon(Icons.language, color: colorScheme.primary),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text("EN")),
                        DropdownMenuItem(value: 'hi', child: Text("HI")),
                        DropdownMenuItem(value: 'gu', child: Text("GU")),
                      ],
                      onChanged: (langCode) {
                        if (langCode != null) {
                          context.read<LocaleBloc>().add(ChangeLocale(Locale(langCode)));
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                            localization?.translate('skin') ?? "Skin\nFirts",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displayMedium?.copyWith(
                              height: 0.8,
                              fontWeight: FontWeight.w200,
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: AppSize.height(context) * 0.020),
                          Text(
                            localization?.translate('dermatology') ?? "Dermatology center",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSize.height(context) * 0.082),
                          Text(
                            localization?.translate('loreum') ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
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
                            text: localization?.translate('logIn') ?? "Log In",
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
                            text: localization?.translate('signUp') ?? "Sign Up",
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
            ),
          ],
        ),
      ),
    );
  }
}
