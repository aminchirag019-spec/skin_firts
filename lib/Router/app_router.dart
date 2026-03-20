import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Data/dotor_model.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_info_screen.dart';
import 'package:skin_firts/Screens/MessageScreen/message_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/add_doctor_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/edit_user.dart';
import 'package:skin_firts/Screens/ProfileScreen/password_manager_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/profile_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/setting_screen.dart';
import 'package:skin_firts/Screens/widgets/bottom_nav_bar.dart';
import 'package:skin_firts/router/router_class.dart';
import 'package:skin_firts/screens/authScreens/finger_authentication.dart';
import 'package:skin_firts/screens/authScreens/login_Screen_!.dart';
import 'package:skin_firts/screens/authScreens/login_screen.dart';
import 'package:skin_firts/screens/authScreens/set_password_screen.dart';
import 'package:skin_firts/screens/authScreens/signup_screen.dart';
import 'package:skin_firts/screens/authScreens/splash_screen.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';
import 'package:skin_firts/screens/homeScreen/home_screen.dart';

import '../Global/dummy_data.dart';
import '../Screens/ChatScreens/chat_list_screen.dart';
import '../Screens/DoctorScreens/doctor_screen.dart';
import '../Screens/CalenderScreen/calender_screen.dart';
import '../Screens/ChatScreens/chat_screen.dart';
import '../Screens/ProfileScreen/notification_setting.dart';

final GoRouter app_router = GoRouter(
  initialLocation: RouterName.splashScreen.path,
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterName.homeScreen.path,
              builder: (context, state) => HomeScreen(),
            ),
            GoRoute(
              path: RouterName.doctorScreen.path,
              builder: (context, state) => DoctorScreen(),
            ),
            GoRoute(
              path: RouterName.doctorInfoScreen.path,
              builder: (context, state) {
                final data = state.extra as AddDoctor;
                return DoctorInfoScreen(data: data);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterName.messageScreen.path,
              builder: (context, state) => MessageScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterName.profileScreen.path,
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterName.calenderScreen.path,
              builder: (context, state) => CalenderScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouterName.fingerAuthenticationScreen.path,
      builder: (context, state) => FingerAuthentication(),
    ),
    GoRoute(
      path: RouterName.settingScreen.path,
      builder: (context, state) => SettingScreen(),
    ),
    GoRoute(
      path: RouterName.addDoctorScreen.path,
      builder: (context, state) => AddDoctorScreen(),
    ),
    GoRoute(
      path: RouterName.passwordManagerScreen.path,
      builder: (context, state) => PasswordManagerScreen(),
    ),
    GoRoute(
      path: RouterName.editUserScreen.path,
      builder: (context, state) => EditUser(),
    ),
    GoRoute(
      path: RouterName.notificationSetting.path,
      builder: (context, state) => NotificationSetting(),
    ),
    GoRoute(
      path: RouterName.chatScreen.path,
      builder: (context, state) => ChatScreen(),
    ),
    GoRoute(
      path: RouterName.chatListScreen.path,
      builder: (context, state) => ChatListScreen(),
    ),
  ],
);
