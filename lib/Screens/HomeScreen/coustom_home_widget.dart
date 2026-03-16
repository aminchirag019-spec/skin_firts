import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';
import 'home_screen.dart';

Widget doctorInformationCard() {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      if (state.getDoctor.isEmpty) {
        return const Center(child: Text("No Doctors Found"));
      }
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final doctor = state.getDoctor[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.005,
              // 5
              horizontal: AppSize.width(context) * 0.051, // 20
            ),
            child: GestureDetector(
              onTap: () {
                context.go(RouterName.doctorInfoScreen.path, extra: doctor);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(context) * 0.035, // 14
                  vertical: AppSize.height(context) * 0.009, // 8
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffCAD6FF).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.064,
                  ), // 25
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.width(context) * 0.087, // 34
                      backgroundColor: Colors.white,
                      backgroundImage:  AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.025),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppSize.width(context) * 0.769,
                            height: AppSize.height(context) * 0.045,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppSize.width(context) * 0.030,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    AppSize.width(context) * 0.030,
                                vertical: AppSize.height(context) * 0.005,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${doctor.doctorName},${doctor.qualification}",
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize:
                                          AppSize.width(context) * 0.035, // 14
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff2260FF),
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    "${doctor.specialization}",
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize:
                                          AppSize.width(context) * 0.033, // 13
                                      color: Colors.black87,
                                      height: 0.9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSize.height(context) * 0.005),
                          // 5
                          Row(
                            children: [
                              infoBadge(
                                context,
                                "assets/images/star_svg.svg",
                                "5",
                              ),
                              SizedBox(width: AppSize.width(context) * 0.025),
                              // 10
                              infoBadge(
                                context,
                                "assets/images/meesage_svg.svg",
                                "60",
                              ),
                              const Spacer(),
                              circleIcon(
                                context,
                                Icons.question_mark,
                                isBlue: true,
                              ),
                              SizedBox(width: AppSize.width(context) * 0.012),
                              BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<DoctorScreenBloc>().add(
                                        LikedEvent(doctor.id,
                                        !doctor.isLiked),
                                      );
                                    },
                                    child: circleIcon(
                                      context,
                                      doctor.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      isBlue: true,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: state.getDoctor.length,
      );
    },
  );
}

Widget appointmentInformation(BuildContext context) {
  return Container(
    height: AppSize.height(context) * 0.154, // 130
    width: AppSize.width(context) * 3,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSize.width(context) * 0.064), // 25
    ),
    child: Stack(
      children: [
        Positioned(
          left: AppSize.width(context) * 0.5, // 155
          top: AppSize.height(context) * 0.011, // 10
          child: Text(
            "11 Wednesday - Today",
            style: GoogleFonts.leagueSpartan(
              color: const Color(0xff2260FF),
              letterSpacing: 0.6,
              fontSize: AppSize.width(context) * 0.035,
            ),
          ),
        ),
        Positioned(
          top: AppSize.height(context) * 0.027,
          left: AppSize.width(context) * 0.128,
          right: AppSize.width(context) * 0.128,
          child: Divider(color: const Color(0xff2260FF), thickness: 1),
        ),
        Positioned(
          bottom: AppSize.height(context) * 0.015,
          left: AppSize.width(context) * 0.128,
          right: AppSize.width(context) * 0.128,
          child: Divider(color: const Color(0xff2260FF), thickness: 1),
        ),
        Positioned(
          top: AppSize.height(context) * 0.017, // 15
          left: AppSize.width(context) * 0.025, // 10
          child: Column(
            children: [
              SizedBox(height: AppSize.height(context) * 0.009), // 8
              Text(
                "9 AM",
                style: GoogleFonts.leagueSpartan(
                  color: const Color(0xff2260FF),
                  fontSize: AppSize.width(context) * 0.035,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.009), // 8
              Text(
                "10 AM",
                style: GoogleFonts.leagueSpartan(
                  color: const Color(0xff2260FF),
                  fontSize: AppSize.width(context) * 0.035,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.009), // 8
              Text(
                "11 AM",
                style: GoogleFonts.leagueSpartan(
                  color: const Color(0xff2260FF),
                  fontSize: AppSize.width(context) * 0.035,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.005), // 5
              Text(
                "12 AM",
                style: GoogleFonts.leagueSpartan(
                  color: const Color(0xff2260FF),
                  fontSize: AppSize.width(context) * 0.035,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: AppSize.height(context) * 0.047, // 40
          left: AppSize.width(context) * 0.141, // 55
          child: Container(
            height: AppSize.height(context) * 0.071, // 60
            width: AppSize.width(context) * 0.641, // 250
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppSize.width(context) * 0.051, // 20
              ),
              color: const Color(0xffCAD6FF),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: AppSize.height(context) * 0.008, // 7
                  left: AppSize.width(context) * 0.051, // 20
                  child: Text(
                    "Dr. Olivia Turner, M.D.",
                    style: GoogleFonts.leagueSpartan(
                      fontSize: AppSize.width(context) * 0.041, // 16
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff2260FF),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.height(context) * 0.033, // 28
                  left: AppSize.width(context) * 0.051, // 20
                  child: Text(
                    "Treatment and prevention of\nskin and photodermatitis.",
                    style: GoogleFonts.leagueSpartan(
                      fontSize: AppSize.width(context) * 0.038,
                      fontWeight: FontWeight.w300,
                      height: 0.8,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.height(context) * 0.009, // 8
                  right: AppSize.width(context) * 0.025, // 10
                  child: Row(
                    children: [
                      Container(
                        height: AppSize.width(context) * 0.038, // 15
                        width: AppSize.width(context) * 0.038, // 15
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/images/right_icon.png"),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.015), // 6
                      Container(
                        height: AppSize.width(context) * 0.038, // 15
                        width: AppSize.width(context) * 0.038, // 15
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/images/wrong_icon.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget circleIcon(BuildContext context, IconData icon, {bool isBlue = false}) {
  return Container(
    height: AppSize.width(context) * 0.056, // 22
    width: AppSize.width(context) * 0.056, // 22
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Icon(
        icon,
        size: AppSize.width(context) * 0.038,
        color: const Color(0xff2260FF),
      ), // 15
    ),
  );
}

Widget infoBadge(
  BuildContext context,
  String svgPath,
  String text, {
  double width = 50,
}) {
  return Container(
    width: AppSize.width(context) * (width / 390.0),
    height: AppSize.height(context) * 0.026, // 22
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSize.width(context) * 0.051), // 20
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: AppSize.width(context) * 0.012), // 5
        SvgPicture.asset(
          svgPath,
          height: AppSize.width(context) * 0.041, // 16
          width: AppSize.width(context) * 0.041, // 16
          color: const Color(0xff2260FF),
        ),
        SizedBox(width: AppSize.width(context) * 0.010), // 4
        Text(
          text,
          style: TextStyle(
            color: const Color(0xff2260FF),
            fontWeight: FontWeight.w300,
            fontSize: AppSize.width(context) * 0.030, // 12
          ),
        ),
      ],
    ),
  );
}
