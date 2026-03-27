import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Global/enums.dart';
import '../../Utilities/sharedpref_helper.dart';

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
              const SizedBox(height: 30),
              Text(
                "Security Fingerprint",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
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
                          const SizedBox(height: 40),
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
                          const SizedBox(height: 60),
                          Text(
                            "Use Fingerprint To Access",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Authenticate quickly and securely using your fingerprint.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: _handleBiometricLogin,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  "Use Touch ID",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
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
                              child: const Center(
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Or prefer use pin code?",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 20),
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
