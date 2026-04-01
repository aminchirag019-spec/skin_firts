import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Global/enums.dart';
import '../../Helper/app_localizations.dart';
import '../../Helper/sharedpref_helper.dart';

class FingerAuthentication extends StatefulWidget {
  const FingerAuthentication({super.key});

  @override
  State<FingerAuthentication> createState() => _FingerAuthenticationState();
}

class _FingerAuthenticationState extends State<FingerAuthentication> {
  Future<void> _handleBiometricLogin() async {
    context.read<AuthBloc>().add(BiometricLoginEvent());
  }

  Future<void> _enableBiometric() async {
    String? userId = await SharedPrefsHelper.getUserId();
    if (userId != null) {
      await SharedPrefsHelper.setBiometricEnabled(true, userId);
    }
  }

  Future<void> _disableBiometric() async {
    String? userId = await SharedPrefsHelper.getUserId();
    if (userId != null) {
      await SharedPrefsHelper.setBiometricEnabled(false, userId);
    }
  }

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
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: Column(
            children: [
               SizedBox(height: 30),
              Text(
                localization?.translate('securityFingerprint') ?? "Security Fingerprint",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
               SizedBox(height: 40),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                  ),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      if (state.biometricStatus == BiometricStatus.enabled) {
                        await _enableBiometric();
                        context.go(RouterName.homeScreen.path);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           SizedBox(height: 40),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fingerprint,
                              color: Colors.white,
                              size: 70,
                            ),
                          ),
                           SizedBox(height: 60),
                          Text(
                            localization?.translate('useFingerToAccess') ?? "Use Fingerprint To Access",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                           SizedBox(height: 12),
                          Text(
                            localization?.translate('authenticateQuickly') ?? "Authenticate quickly and securely using your fingerprint.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                           SizedBox(height: 50),
                          GestureDetector(
                            onTap: _handleBiometricLogin,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  localization?.translate('useFingerId') ?? "Use Touch ID",
                                  style:  TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                           SizedBox(height: 15),
                          GestureDetector(
                            onTap: () async {
                              await _disableBiometric();
                              context.go(RouterName.homeScreen.path);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: theme.disabledColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  localization?.translate('skip') ?? "Skip",
                                  style:  TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            localization?.translate('or use pin code') ?? "or use pin code",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                           SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
