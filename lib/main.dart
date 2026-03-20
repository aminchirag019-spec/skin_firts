import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';
import 'package:skin_firts/firebase_options.dart';
import 'package:skin_firts/router/app_router.dart';

import 'Bloc/ChatBloc/chat_bloc.dart';
import 'Utilities/bio_metric.dart';
import 'Utilities/firebase_message.dart';

final user = FirebaseAuth.instance.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Color(0xff2260FF)),
  );
  final authRepo = AuthRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DoctorScreenBloc(AuthRepository(), NotificationService()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            AuthRepository(),
            BiometricAuthService(),
            SharedPrefsHelper(),
          ),
        ),
        BlocProvider(create: (context) => NotificationBloc(AuthRepository())),
        BlocProvider(create: (context) => ChatBloc(authRepo) ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Skin_Firts',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      routerConfig: app_router,
    );
  }
}
