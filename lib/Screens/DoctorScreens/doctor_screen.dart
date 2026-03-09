import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/Router/router_class.dart';

import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Global/dummy_data.dart';
import 'doctor_screen.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.homeScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              children: [
                doctorsTopRow(
                  text: "Doctors",
                  onPressed: () => context.go(RouterName.homeScreen.path),
                ),
                SizedBox(height: 20),
                BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Sort By",
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            height: 1,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            context.read<DoctorScreenBloc>().add(FilterChangedEvent(-1));
                          },child: Container(
                            width: 52,
                            height: 22,
                            decoration: BoxDecoration(
                              color: state.selectedIndex == -1
                                  ?   Color(0xff2260FF)
                                  :  Color(0xffCAD6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "A→Z",
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: state.selectedIndex == -1
                                      ? Colors.white :  Color(0xff2260FF),
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        filterOptions(
                          icon: Icons.star_outline,
                          size: 18,
                          index: 0,
                        ),
                        SizedBox(width: 6),
                        filterOptions(
                          icon: Icons.favorite_border,
                          size: 16,
                          index: 1,
                        ),
                        SizedBox(width: 6),
                        filterOptions(icon: Icons.female, size: 18, index: 2),
                        SizedBox(width: 6),
                        filterOptions(icon: Icons.male, size: 18, index: 3),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final item = doctors[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffCAD6FF).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: item.image,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text(
                                          "${item.doctorName},",
                                          style: GoogleFonts.leagueSpartan(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff2260FF),
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          "${item.qualification}",
                                          style: GoogleFonts.leagueSpartan(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff2260FF),
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "${item.title}",
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () => context.go(
                                            RouterName.doctorInfoScreen.path,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xff1B5FE0),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "Info",
                                              style: GoogleFonts.leagueSpartan(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        servicesOptions(
                                          icon: Icons.calendar_month,
                                          size: 15,
                                        ),
                                        SizedBox(width: 2),
                                        servicesOptions(
                                          icon: Icons.calendar_month,
                                          size: 15,
                                        ),
                                        SizedBox(width: 2),
                                        servicesOptions(
                                          icon: Icons.question_mark,
                                          size: 15,
                                        ),
                                        SizedBox(width: 2),
                                        servicesOptions(
                                          icon: Icons.favorite_border_outlined,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget doctorsTopRow({required String text, required VoidCallback onPressed}) {
  return Row(
    children: [
      Icon(Icons.arrow_back_ios, color: Color(0xff2260FF)),
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
        onTap: () {
          context.read<ApplyFilters>().add;
        },
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
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
          ],
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
