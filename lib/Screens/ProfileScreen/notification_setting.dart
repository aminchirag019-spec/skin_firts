import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Global/custom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';
import 'notification_setting.dart';

class NotificationSetting extends StatelessWidget {
  const NotificationSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(context) * 0.064, // 25
            vertical: AppSize.height(context) * 0.023,
          ),
          child: Column(
            children: [
              topRow(
                context,
                onPressed: () {
                  context.go(RouterName.settingScreen.path);
                },
                text: "Notification Setting",
              ),
              SizedBox(height: AppSize.height(context) * 0.021),
              switchSetting(title: "General Notification",index: 0),
              SizedBox(height: AppSize.height(context) * 0.011),
              switchSetting(title: "Sound",index: 1),
              SizedBox(height: AppSize.height(context) * 0.011),
              switchSetting(title: "Sound Call",index: 2),
              SizedBox(height: AppSize.height(context) * 0.011),
              switchSetting(title: "Vibrate",index: 3),
              SizedBox(height: AppSize.height(context) * 0.011),
              switchSetting(title: "Special Offers",index: 4),
              SizedBox(height: AppSize.height(context) * 0.011),
              switchSetting(title: "Payments",index: 5),
              SizedBox(height: AppSize.height(context) * 0.011),
              switchSetting(title: "Promo and discount",index: 6),
              SizedBox(height: AppSize.height(context) * 0.011),
              switchSetting(title: "Cashback",index: 7),
            ],
          ),
        ),
      ),
    );
  }
}
Widget switchSetting({
  required String title,
  required int index,
}) {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.leagueSpartan(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SwitchTheme(
            data: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.white;
                }
                return AppColors.white;
              }),
              trackColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.darkPurple;
                }
                return AppColors.lightPurple;
              }),
            ),
            child: Switch(
              value: state.switches[index],
              activeColor: AppColors.white,
              activeTrackColor: AppColors.darkPurple,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.lightPurple,
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onChanged: (value) {
                context.read<DoctorScreenBloc>().add(
                  SwitchEvent(index: index, isSwitched: value),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

