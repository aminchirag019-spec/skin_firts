

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Utilities/colors.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';
import 'coustom_home_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadCurrentUser());
    context.read<DoctorScreenBloc>().add(GetDoctorEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7FB),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.height(context) * 0.017,
          ), // 15
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(context) * 0.064,
                ), // 25
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.width(context) * 0.064, // 25
                      backgroundImage: const AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.030), // 12
                    Expanded(
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${state.currentUser?.name ?? ""} ",
                                style: GoogleFonts.leagueSpartan(
                                  fontSize:
                                  AppSize.width(context) * 0.035, // 14
                                  color: AppColors.darkPurple,
                                  fontWeight: FontWeight.w300,
                                  height: 1,
                                ),
                              ),
                              Text(
                                state.currentUser?.email ?? "",
                                style: GoogleFonts.leagueSpartan(
                                  fontSize:
                                  AppSize.width(context) * 0.043, // 17
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    homeCircleIcon(
                      context,
                      "assets/images/notification_icon.svg",
                      showDot: true,
                    ),
                    SizedBox(width: AppSize.width(context) * 0.012), // 5
                    homeCircleIcon(context, "assets/images/setting.svg"),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.011), // 10
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(context) * 0.064,
                ), // 25
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go(RouterName.doctorScreen.path);
                      },
                      child: menuItem(
                        "assets/images/doctor_image.svg",
                        "Doctors",
                        context,
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.025), //035
                    menuItem(
                      "assets/images/heart_image.svg",
                      "Favorite",
                      context,
                    ),
                    SizedBox(width: AppSize.width(context) * 0.038),
                    Expanded(
                      child: SizedBox(
                        height: AppSize.height(context) * 0.041, // 35
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: SizedBox(
                              width: AppSize.width(context) * 0.102, // 40
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: AppSize.width(context) * 0.010,
                                    ), // 4
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        AppSize.width(context) * 0.017,
                                      ), // 7
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ImageIcon(
                                        const AssetImage(
                                          "assets/images/tune.png",
                                        ),
                                        size:
                                        AppSize.width(context) *
                                            0.038, // 15
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(
                                left: AppSize.width(context) * 0.010,
                              ), // 4
                              child: Container(
                                padding: EdgeInsets.all(
                                  AppSize.width(context) * 0.017,
                                ), // 7
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ImageIcon(
                                  const AssetImage("assets/images/search.png"),
                                  color: AppColors.darkPurple,
                                  size: AppSize.width(context) * 0.061, // 24
                                ),
                              ),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppSize.height(context) * 0.014, // 12
                              horizontal: AppSize.width(context) * 0.030, // 12
                            ),
                            filled: true,
                            fillColor: const Color(0xffCAD6FF).withOpacity(0.6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSize.width(context) * 0.064,
                              ), // 25
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.017), // 15
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: AppSize.height(context) * 0.296, // 250
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xffCAD6FF).withOpacity(0.6),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: AppSize.height(context) * 0.011,
                              ), // 10
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                  AppSize.width(context) * 0.033, // 13
                                ),
                                child: SizedBox(
                                  height: AppSize.height(context) * 0.082, // 70
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: appointmentDates.length,
                                    itemBuilder: (context, index) {
                                      final item = appointmentDates[index];
                                      bool isSelected =
                                          index == 2 || index == 4 ||
                                              index == 5;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                          AppSize.width(context) * 0.012, // 5
                                        ),
                                        child: Container(
                                          width:
                                          AppSize.width(context) *
                                              0.115, // 45
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.darkPurple
                                                : AppColors.white,
                                            borderRadius: BorderRadius.circular(
                                              AppSize.width(context) *
                                                  0.051, // 20
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.date.toString(),
                                                style: TextStyle(
                                                  fontSize:
                                                  AppSize.width(context) *
                                                      0.064, // 25
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                  height: 1,
                                                ),
                                              ),
                                              Text(
                                                item.day,
                                                style: TextStyle(
                                                  fontSize:
                                                  AppSize.width(context) *
                                                      0.030, // 12
                                                  color: isSelected
                                                      ? AppColors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context) * 0.011,
                              ), // 10
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                    AppSize.width(context) * 0.051,
                                    vertical:
                                    AppSize.height(context) * 0.011, // 20
                                  ),
                                  child: appointmentInformation(context)
                              )
                            ]
                        ),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.011), // 10
                      doctorInformationCard(),
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