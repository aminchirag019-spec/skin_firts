import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/app_string.dart';
import '../../Global/dummy_data.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../HomeScreen/coustom_home_widget.dart';
import '../HomeScreen/home_screen.dart';
import 'doctor_screen.dart';

class DoctorInfoScreen extends StatelessWidget {
  DoctorInfoScreen({super.key, this.data});
  final AddDoctor? data;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.doctorScreen.path);
        return false;
      },
      child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 25,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      doctorsTopRow(
                        context,
                        text: "Doctor Info",
                        onPressed: () {
                          print("button pressed");
                          context.go(RouterName.doctorScreen.path);
                        },
                      ),
                      SizedBox(height: AppSize.height(context) * 0.011), // 10
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xffC8D4F6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: AppSize.width(context) * 0.166, // 65
                                  backgroundColor: AppColors.white,
                                  backgroundImage: const AssetImage(
                                    "assets/images/user_image.png",
                                  ),
                                ),
                                SizedBox(width: AppSize.width(context) * 0.035), // 14
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.darkPurple,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: AppSize.width(context) * 0.058, // 23
                                                  width: AppSize.width(context) * 0.058, // 23
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.white,
                                                  ),
                                                  child: Center(
                                                    child: Image(
                                                      image: const AssetImage(
                                                        "assets/images/qualification_badge_blue.png",
                                                      ),
                                                      height: AppSize.width(context) * 0.038, // 15
                                                      width: AppSize.width(context) * 0.038, // 15
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: AppSize.width(context) * 0.020), // 8
                                            Column(
                                              children: [
                                                SizedBox(width: AppSize.width(context) * 0.015), // 6
                                                Text(
                                                  data!.experience.toString(),
                                                  style:
                                                      GoogleFonts.leagueSpartan(
                                                        fontSize: AppSize.width(context) * 0.035, // 14
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors.white,
                                                        height: 1,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: AppSize.height(context) * 0.003), // 3
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Color(0xff1B5FE0),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.leagueSpartan(
                                              fontSize: AppSize.width(context) * 0.035, // 14
                                              fontWeight: FontWeight.w200,
                                              color: AppColors.white,
                                              letterSpacing: 0.5,
                                              height: 0.9,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: "Focus: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: data!.description
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSize.height(context) * 0.011), // 10
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${data!.doctorName.toString()},${data!.qualification}",
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: AppSize.width(context) * 0.048, // 19
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkPurple,
                                      height: 1,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    data!.specialization.toString(),
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: AppSize.width(context) * 0.038, // 15
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.black,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSize.height(context) * 0.013), // 12
                            Row(
                              children: [
                                infoBadge(
                                  context,
                                  "assets/images/star_svg.svg",
                                  "5",
                                  width: 50,
                                ),
                                SizedBox(width: AppSize.width(context) * 0.007), // 3
                                infoBadge(
                                  context,
                                  "assets/images/meesage_svg.svg",
                                  "50",
                                  width: 50,
                                ),
                                SizedBox(width: AppSize.width(context) * 0.012), // 5
                                Expanded(
                                  child: Container(
                                    height: AppSize.height(context) * 0.026, // 22
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(AppSize.width(context) * 0.051), // 20
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: AppSize.width(context) * 0.012), // 5
                                        SvgPicture.asset(
                                          "assets/images/alarm_svg.svg",
                                          height: AppSize.width(context) * 0.041, // 16
                                          width: AppSize.width(context) * 0.041, // 16
                                          color: AppColors.darkPurple
                                        ),
                                        SizedBox(width: AppSize.width(context) * 0.010), // 4
                                        Text(
                                          "Mon-Sat / 9:00AM - 5:00PM",
                                          style: GoogleFonts.leagueSpartan(
                                            fontSize: AppSize.width(context) * 0.033, // 13
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: -0.5,
                                            color: AppColors.darkPurple
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSize.height(context) * 0.013), // 12
                            Row(
                              children: [
                                Container(
                                  height: AppSize.height(context) * 0.035, // 30
                                  width: AppSize.width(context) * 0.256, // 100
                                  decoration: BoxDecoration(
                                    color:AppColors.darkPurple,
                                    borderRadius: BorderRadius.circular(AppSize.width(context) * 0.051), // 20
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: AppColors.white,
                                        size: AppSize.width(context) * 0.046, // 18
                                      ),
                                      SizedBox(width: AppSize.width(context) * 0.015), // 6
                                      const Text(
                                        "Schedule",
                                        style: TextStyle(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                servicesOptions(
                                  context,
                                  icon: Icons.info_outline,
                                  size: AppSize.width(context) * 0.046, // 18
                                ),
                                SizedBox(width: AppSize.width(context) * 0.007), // 3
                                servicesOptions(
                                  context,
                                  icon: Icons.question_mark,
                                  size: AppSize.width(context) * 0.046, // 18
                                ),
                                SizedBox(width: AppSize.width(context) * 0.007), // 3
                                servicesOptions(
                                  context,
                                  icon: Icons.star_outline,
                                  size: AppSize.width(context) * 0.046, // 18
                                ),
                                SizedBox(width: AppSize.width(context) * 0.007), // 3
                                servicesOptions(
                                  context,
                                  icon: Icons.favorite_border_outlined,
                                  size: AppSize.width(context) * 0.046, // 18
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.023), // 20
                      Row(
                        children: [
                          Text(
                            "Profile",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: AppSize.width(context) * 0.041, // 16
                              color: AppColors.darkPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data!.profile.toString(),
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.035, // 14
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.height(context) * 0.023), // 20
                      Row(
                        children: [
                          Text(
                            "Career Path",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: AppSize.width(context) * 0.041, // 16
                              color: AppColors.darkPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data!.careerPath.toString(),
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.035, // 14
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.height(context) * 0.023), // 20
                      Row(
                        children: [
                          Text(
                            "Highlights",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: AppSize.width(context) * 0.041, // 16
                              color: AppColors.darkPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data!.highlights.toString(),
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.035, // 14
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
Widget doctorsTopRow(BuildContext context, {required String text, required VoidCallback onPressed}) {
  return Row(
    children: [
      GestureDetector(
        onTap: onPressed,
        child:  Icon(Icons.arrow_back_ios, color:AppColors.darkPurple),
      ),
      SizedBox(width: AppSize.width(context) * 0.012), // 5
      Expanded(
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: AppSize.width(context) * 0.064, // 25
              fontWeight: FontWeight.w600,
              color: AppColors.darkPurple,
            ),
          ),
        ),
      ),
      Container(
        height: AppSize.width(context) * 0.064, // 25
        width: AppSize.width(context) * 0.064, // 25
        decoration:  BoxDecoration(
          color: AppColors.lightPurple,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            const AssetImage("assets/images/search.png"),
            color:AppColors.darkPurple,
            size: AppSize.width(context) * 0.035, // 14
          ),
        ),
      ),
      SizedBox(width: AppSize.width(context) * 0.012), // 5
      Container(
        height: AppSize.width(context) * 0.064, // 25
        width: AppSize.width(context) * 0.064, // 25
        decoration:  BoxDecoration(
          color: AppColors.lightPurple,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            const AssetImage("assets/images/tune.png"),
            color: AppColors.darkPurple,
            size: AppSize.width(context) * 0.038, // 15
          ),
        ),
      ),
    ],
  );
}

Widget filterOptions(
  BuildContext context, {
  required IconData icon,
  required double size,
  required int index,
      required DoctorFilter filter,
}) {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      bool isSelected = state.selectedIndex == index;

      return InkWell(
        onTap: () async {
          context.read<DoctorScreenBloc>().add(FilterChangedEvent(index,filter));
          context.read<DoctorScreenBloc>().add(ApplyFilters(
            sortBy: filter == DoctorFilter.rating ? "Rating" : null,
            liked: filter == DoctorFilter.liked ? true : null,
            gender: filter == DoctorFilter.male ? "Male".toLowerCase() : filter == DoctorFilter.female ? "Female".toLowerCase() : null,
          ));
        },
        borderRadius: BorderRadius.circular(AppSize.width(context) * 0.051), // 20
        child: Container(
          height: AppSize.width(context) * 0.061, // 24
          width: AppSize.width(context) * 0.061, // 24
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ?  AppColors.darkPurple
                :  AppColors.lightPurple,
          ),
          child: Center(
            child: Icon(
              icon,
              size: size,
              color: isSelected ? AppColors.white : AppColors.darkPurple,
            ),
          ),
        ),
      );
    },
  );
}

Widget servicesOptions(BuildContext context, {required IconData icon, required double size}) {
  return Container(
    height: AppSize.width(context) * 0.064, // 25
    width: AppSize.width(context) * 0.061, // 24
    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
    child: Center(
      child: Icon(icon, size: size, color: AppColors.darkPurple),
    ),
  );
}
