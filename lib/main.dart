import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Bloc/ChatBloc/chat_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:skin_firts/Bloc/LocaleBloc/locale_bloc.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import 'package:skin_firts/Network/chat_repository.dart';
import 'package:skin_firts/Network/notification_repository.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/firebase_options.dart';
import 'package:skin_firts/router/app_router.dart';

import 'Bloc/LocaleBloc/locale_event.dart';
import 'Bloc/LocaleBloc/locale_state.dart';
import 'Helper/app_localizations.dart';
import 'Helper/sharedpref_helper.dart';
import 'Utilities/bio_metric.dart';
import 'Helper/firebase_message.dart';

final user = FirebaseAuth.instance.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: AppColors.darkPurple),
  );

  final authRepository = AuthRepository();
  final notificationService = NotificationService();
  final notificationRepository = NotificationRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleBloc()..add(LoadStoredLocale()),
        ),
        BlocProvider(
          create: (context) => DoctorScreenBloc(
            authRepository,
            notificationService,
            context.read<LocaleBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository,
            BiometricAuthService(),
            SharedPrefsHelper(),
            context.read<LocaleBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(
            notificationRepository,
            context.read<LocaleBloc>(),
          ),
        ),
        BlocProvider(create: (context) => ChatBloc(ChatRepository())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Skin_Firts',
          locale: state.locale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('hi', ''),
            Locale('gu', ''),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
      },
    );
  }
}
