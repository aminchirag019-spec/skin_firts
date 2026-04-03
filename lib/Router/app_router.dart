import 'package:go_router/go_router.dart';
import 'package:skin_firts/Data/appointment_model.dart';
import 'package:skin_firts/Screens/AppointmentScreen/appointment_screen.dart';
import 'package:skin_firts/Screens/AppointmentScreen/cancel_appointment_screen.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_details.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_info_screen.dart';
import 'package:skin_firts/Screens/AppointmentScreen/review_screen.dart';
import 'package:skin_firts/Screens/HelpCentreScreen/help_centre_screen.dart';
import 'package:skin_firts/Screens/MessageScreen/message_screen.dart';
import 'package:skin_firts/Screens/PaymentMethod/add_payment_method.dart';
import 'package:skin_firts/Screens/PaymentMethod/payment_method_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/add_doctor_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/edit_user_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/password_manager_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/profile_screen.dart';
import 'package:skin_firts/Screens/ProfileScreen/setting_screen.dart';
import 'package:skin_firts/Screens/widgets/bottom_nav_bar.dart';
import 'package:skin_firts/router/router_class.dart';
import 'package:skin_firts/screens/authScreens/finger_authentication.dart';
import 'package:skin_firts/screens/authScreens/login_screen.dart';
import 'package:skin_firts/screens/authScreens/set_password_screen.dart';
import 'package:skin_firts/screens/authScreens/signup_screen.dart';
import 'package:skin_firts/screens/authScreens/splash_screen.dart';
import 'package:skin_firts/screens/authScreens/welcome_screen.dart';
import 'package:skin_firts/screens/homeScreen/home_screen.dart';
import '../Data/doctor_model.dart';
import '../Screens/DoctorScreens/appointment_details.dart';
import '../Screens/DoctorScreens/schedule_screen.dart';
import '../Screens/ChatScreens/chat_list_screen.dart';
import '../Screens/DoctorScreens/doctor_screen.dart';
import '../Screens/ChatScreens/chat_screen.dart';
import '../Screens/PrivacyPolicyScreen/privacy_policy_screen.dart';
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
      path: RouterName.signupScreen.path,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: RouterName.setPasswordScreen.path,
      builder: (context,state) => SetPasswordScreen(),
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
            GoRoute(
              path: RouterName.doctorDetailsScreen.path,
              builder: (context, state) {
                final data = state.extra as AddDoctor?;
                return DoctorDetailsScreen(doctor: data);
              },
            ),
            GoRoute(path: RouterName.scheduleScreen.path,
                builder: (context, state) {
              final data = state.extra as AddDoctor;
              return ScheduleScreen(doctor: data);
            }),
            GoRoute(
              path: RouterName.appointmentDetails.path,
              builder: (context, state) {
                final appointment = state.extra as AppointmentModel;
                return AppointmentDetails(appointment: appointment);
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
            GoRoute(path: RouterName.appointmentScreen.path,
              builder: (context, state) => AppointmentScreen(),
            ),
             GoRoute(path: RouterName.cancelAppointmentScreen.path,
              builder: (context, state) {
                final appointmentId = state.extra as String?;
                return CancelAppointmentScreen(appointmentId: appointmentId);
              },
            ),
            GoRoute(
              path: RouterName.reviewScreen.path,
              builder: (context, state) {
                final doctor = state.extra as AddDoctor?;
                return ReviewScreen(doctor: doctor);
              },
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
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ChatScreen(
          receiverId: data['receiverId'],
          receiverName: data['receiverName'],
        );
      },
    ),
    GoRoute(
      path: RouterName.chatListScreen.path,
      builder: (context, state) => ChatListScreen(),
    ),
    GoRoute(
      path: RouterName.privacyPolicyScreen.path,
      builder: (context, state) => PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: RouterName.helpCentreScreen.path,
      builder: (context, state) => HelpCentreScreen(),
    ),
    GoRoute(
      path: RouterName.paymentMethodScreen.path,
      builder: (context, state) => PaymentMethodScreen(),
    ),
    GoRoute(
      path: RouterName.addPaymentMethodScreen.path,
      builder: (context, state) => AddPaymentMethod(),
    ),


  ],
);
