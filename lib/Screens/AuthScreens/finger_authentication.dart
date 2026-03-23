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
  State<FingerAuthentication> createState() =>
      _FingerAuthenticationState();
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
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.welcomeScreen.path);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.darkPurple,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Security Fingerprint",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),

               SizedBox(height: 40),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                    color: Color(0xffE5ECE7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                  ),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      if (state.biometricStatus ==
                          BiometricStatus.enabled) {
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
                            decoration:  BoxDecoration(
                              color: AppColors.darkPurple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fingerprint,
                              color: AppColors.white,
                              size: 70,
                            ),
                          ),

                          const SizedBox(height: 60),

                          const Text(
                            "Use Fingerprint To Access",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "Authenticate quickly and securely using your fingerprint.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 13),
                          ),
                          SizedBox(height: 50),
                          GestureDetector(
                            onTap: _handleBiometricLogin,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              decoration: BoxDecoration(
                                color:  Color(0xff2260FF),
                                borderRadius:
                                BorderRadius.circular(30),
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
                              context.go(
                                  RouterName.homeScreen.path);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                BorderRadius.circular(30),
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

                          const Text(
                            "Or prefer use pin code?",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45),
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