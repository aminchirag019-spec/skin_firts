import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Bloc/ChatBloc/chat_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import 'package:skin_firts/Network/chat_repository.dart';
import 'package:skin_firts/Network/notification_repository.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';
import 'package:skin_firts/firebase_options.dart';
import 'package:skin_firts/router/app_router.dart';

import 'Utilities/bio_metric.dart';
import 'Utilities/firebase_message.dart';

final user = FirebaseAuth.instance.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: AppColors.darkPurple));
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) =>
            DoctorScreenBloc(AuthRepository(), NotificationService())),
    BlocProvider(
        create: (context) => AuthBloc(
            AuthRepository(), BiometricAuthService(), SharedPrefsHelper())),
    BlocProvider(
      create: (context) => NotificationBloc(NotificationRepository()),
    ),
    BlocProvider(
      create: (context) => ChatBloc(ChatRepository()),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Skin_Firts',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.darkPurple,
          primary: AppColors.darkPurple,
          secondary: AppColors.lightPurple,
        ),
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkPurple,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        textTheme: GoogleFonts.leagueSpartanTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: app_router,
    );
  }
}
