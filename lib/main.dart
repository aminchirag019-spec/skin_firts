import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skin_firts/router/app_router.dart';
import 'package:skin_firts/screens/authScreens/splash_screen.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff2260FF)
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Skin_Firts',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: app_router,
    );
  }
}
