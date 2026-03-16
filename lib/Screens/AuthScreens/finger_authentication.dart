import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/router/router_class.dart';

import '../../Global/enums.dart';
import '../../Utilities/bio_metric.dart';
import '../../Utilities/sharedpref_helper.dart';

class FingerAuthentication extends StatefulWidget {
  const FingerAuthentication({super.key});

  @override
  State<FingerAuthentication> createState() => _FingerAuthenticationState();
}

class _FingerAuthenticationState extends State<FingerAuthentication> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.welcomeScreen.path);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff2260FF),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 30),

                Text(
                  "Security Fingerprint",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                    color: Color(0xffE5ECE7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: const BoxDecoration(
                          color: Color(0xff2260FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),

                      SizedBox(height: 90),

                      Text(
                        "Use Fingerprint To Access",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 12),

                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),

                      SizedBox(height: 60),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state.biometricStatus ==
                              BiometricStatus.enabled) {
                            context.go(RouterName.homeScreen.path);
                          }
                        },
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              context.read<AuthBloc>().add(
                                BiometricLoginEvent(),
                              );
                              String? userId = await SharedPrefsHelper.getUserId();

                              if (userId != null) {
                                await SharedPrefsHelper.setBiometricEnabled(true,userId );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Color(0xff2260FF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Use Touch Id",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                        },
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              String? userId = await SharedPrefsHelper.getUserId();
                              await SharedPrefsHelper.setBiometricEnabled(false,userId as String);
                              context.go(RouterName.homeScreen.path);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Color(0xff2260FF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),

                      Text(
                        "Or prefer use pin code?",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
