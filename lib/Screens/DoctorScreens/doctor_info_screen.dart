import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Data/dotor_model.dart';
import 'package:skin_firts/Global/app_string.dart';
import 'package:skin_firts/Global/dummy_data.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
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
                        text: "Doctor Info",
                        onPressed: () {
                          print("button pressed");
                          context.go(RouterName.doctorScreen.path);
                        },
                      ),
                      SizedBox(height: 10),
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
                                  radius: 65,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    "assets/images/user_image.png",
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xff2260FF),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: 23,
                                                  width: 23,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Image(
                                                      image: AssetImage(
                                                        "assets/images/qualification_badge_blue.png",
                                                      ),
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              children: [
                                                SizedBox(width: 6),
                                                Text(
                                                  data!.experience.toString(),
                                                  style:
                                                      GoogleFonts.leagueSpartan(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                        height: 1,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 3),
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                              height: 0.9,
                                            ),
                                            children: [
                                              TextSpan(
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
                            SizedBox(height: 10),
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
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff2260FF),
                                      height: 1,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    data!.specialization.toString(),
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                infoBadge(
                                  "assets/images/star_svg.svg",
                                  "5",
                                  width: 50,
                                ),
                                SizedBox(width: 3),
                                infoBadge(
                                  "assets/images/meesage_svg.svg",
                                  "50",
                                  width: 50,
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width: 170,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 5),
                                      SvgPicture.asset(
                                        "assets/images/alarm_svg.svg",
                                        height: 16,
                                        width: 16,
                                        color: Color(0xff2260FF),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Mon-Sat / 9:00AM - 5:00PM",
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: -0.5,
                                          color: Color(0xff2260FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Color(0xff2260FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Schedule",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                servicesOptions(
                                  icon: Icons.info_outline,
                                  size: 18,
                                ),
                                SizedBox(width: 3),
                                servicesOptions(
                                  icon: Icons.question_mark,
                                  size: 18,
                                ),
                                SizedBox(width: 3),
                                servicesOptions(
                                  icon: Icons.star_outline,
                                  size: 18,
                                ),
                                SizedBox(width: 3),
                                servicesOptions(
                                  icon: Icons.favorite_border_outlined,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Profile",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 16,
                              color: Color(0xff2260FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            data!.profile.toString(),
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Career Path",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 16,
                              color: Color(0xff2260FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            data!.careerPath.toString(),
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "highlights",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 16,
                              color: Color(0xff2260FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            data!.highlights.toString(),
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              height: 1,
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

Widget doctorsTopRow({required String text, required VoidCallback onPressed}) {
  return Row(
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Icon(Icons.arrow_back_ios, color: Color(0xff2260FF)),
      ),
      SizedBox(width: 5),
      Expanded(
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color(0xff2260FF),
            ),
          ),
        ),
      ),
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: Color(0xffCAD6FF),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            AssetImage("assets/images/search.png"),
            color: Color(0xff2260FF),
            size: 14,
          ),
        ),
      ),
      SizedBox(width: 5),
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: Color(0xffCAD6FF),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            AssetImage("assets/images/tune.png"),
            color: Color(0xff2260FF),
            size: 15,
          ),
        ),
      ),
    ],
  );
}

Widget filterOptions({
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
          context.read<DoctorScreenBloc>().add(FilterChangedEvent(index));

          context.read<DoctorScreenBloc>().add(
            ApplyFilters(filter: filter, index: index),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? const Color(0xff2260FF)
                : const Color(0xffCAD6FF),
          ),
          child: Center(
            child: Icon(
              icon,
              size: size,
              color: isSelected ? Colors.white : const Color(0xff2260FF),
            ),
          ),
        ),
      );
    },
  );
}

Widget servicesOptions({required IconData icon, required double size}) {
  return Container(
    height: 25,
    width: 24,
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    child: Center(
      child: Icon(icon, size: size, color: Color(0xff2260FF)),
    ),
  );
}
