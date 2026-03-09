import 'package:go_router/go_router.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_info_screen.dart';
import 'package:skin_firts/router/router_class.dart';
import 'package:skin_firts/screens/authScreens/finger_authentication.dart';
import 'package:skin_firts/screens/authScreens/login_Screen_!.dart';
import 'package:skin_firts/screens/authScreens/login_screen.dart';
import 'package:skin_firts/screens/authScreens/set_password_screen.dart';
import 'package:skin_firts/screens/authScreens/signup_screen.dart';
import 'package:skin_firts/screens/authScreens/splash_screen.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';
import 'package:skin_firts/screens/homeScreen/home_screen.dart';

import '../Screens/DoctorScreens/doctor_screen.dart';

final GoRouter app_router = GoRouter(
  initialLocation: RouterName.homeScreen.path,
  routes: [
    GoRoute(
      path: RouterName.splashScreen.path,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: RouterName.welcomeScreen.path,
      builder: (context, state) => WelcomeScreen(),
    ),
    GoRoute(
      path: RouterName.loginScreen.path,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: RouterName.loginScreen1.path,
      builder: (context, state) => LoginScreen_1(),
    ),
    GoRoute(
      path: RouterName.signupScreen.path,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: RouterName.setPasswordScreen.path,
      builder: (context, state) => SetPasswordScreen(),
    ),
    GoRoute(
      path: RouterName.homeScreen.path,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: RouterName.fingerAuthenticationScreen.path,
      builder: (context, state) => FingerAuthentication(),
    ),
    GoRoute(
      path: RouterName.doctorScreen.path,
      builder: (context, state) => DoctorScreen(),
    ),
    GoRoute(path: RouterName.doctorInfoScreen.path,
    builder: (context, state) => DoctorInfoScreen(),
    )
  ],
);
