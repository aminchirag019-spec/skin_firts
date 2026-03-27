import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Global/enums.dart';
import '../../Helper/app_localizations.dart';
import '../../Helper/sharedpref_helper.dart';
import '../../Utilities/media_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplash();
  }

  Future<void> saveFcmToken(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        "fcmToken": token,
      }, SetOptions(merge: true));
    }
  }

  void startSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = await FirebaseAuth.instance.authStateChanges().first;

    if (!mounted) return;

    if (user == null) {
      context.go(RouterName.loginScreen.path);
      return;
    }

    await saveFcmToken(user.uid);
    String? userId = await SharedPrefsHelper.getUserId();
    bool biometricEnabled = await SharedPrefsHelper.getBiometricEnabled(user.uid) ?? false;

    if (userId != null && biometricEnabled) {
      context.read<AuthBloc>().add(BiometricLoginEvent());
    } else {
      context.go(RouterName.loginScreen.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.biometricStatus == BiometricStatus.enabled) {
          context.go(RouterName.homeScreen.path);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/splash_image.png"),
              SizedBox(height: AppSize.height(context) * 0.017),
              Text(
                localization?.translate('skin') ?? "Skin\nFirts",
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                  height: 0.8,
                  fontWeight: FontWeight.w200,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.020),
              Text(
                localization?.translate('dermatology') ?? "Dermatology center",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
