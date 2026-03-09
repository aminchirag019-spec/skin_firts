import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/router/router_class.dart';

class FingerAuthentication extends StatelessWidget {
  const FingerAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.go(RouterName.welcomeScreen.path);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff2260FF),
        body: SafeArea(
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

              const SizedBox(height: 40),

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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

                      SizedBox(height: 40),

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

                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => context.go(RouterName.homeScreen.path),
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
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        "Or prefer use pin code?",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
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
