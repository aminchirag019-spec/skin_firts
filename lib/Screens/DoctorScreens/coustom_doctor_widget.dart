import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Global/dummy_data.dart';
import '../../Router/router_class.dart';
import '../HomeScreen/home_screen.dart';
import 'doctor_info_screen.dart';

Widget likedBar() {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<DoctorScreenBloc>().add(TabEvent(isTab: true));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: state.isTab
                      ? const Color(0xff2260FF)
                      : const Color(0xffCAD6FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    "Doctors",
                    style: GoogleFonts.leagueSpartan(
                      color: state.isTab ? Colors.white : Color(0xff2260FF),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 10),

          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<DoctorScreenBloc>().add(TabEvent(isTab: false));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !state.isTab ? Color(0xff2260FF) : Color(0xffCAD6FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    "Services",
                    style: GoogleFonts.leagueSpartan(
                      color: !state.isTab ? Colors.white : Color(0xff2260FF),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget doctorDetailsCard() {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      return ListView.builder(
        itemBuilder: (context, index) {
          final doctor = state.getDoctor[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                context.go(
                  RouterName.doctorInfoScreen.path,
                  extra: state.getDoctor[index],
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: Color(0xffCAD6FF).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state.selectedFilter == DoctorFilter.rating
                              ? Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff2260FF),
                                      ),
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/qualification_badge_white.png",
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Professional Doctor",
                                      style: GoogleFonts.leagueSpartan(
                                        color: Color(0xff2260FF),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Spacer(),
                                    state.selectedFilter == DoctorFilter.rating
                                        ? infoBadge(
                                            "assets/images/star_svg.svg",
                                            "5",
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
                          SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  state.selectedFilter == DoctorFilter.rating ||
                                      state.selectedFilter == DoctorFilter.liked
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${doctor.doctorName},${doctor.qualification} ",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize:
                                              state.selectedFilter ==
                                                  DoctorFilter.rating
                                              ? 15
                                              : 17,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff2260FF),
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      doctor.specialization,
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff2260FF),
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  doctor.specialization,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          state.selectedFilter == DoctorFilter.liked
                              ? SizedBox(height: 10)
                              : SizedBox(height: 15),
                          state.selectedFilter == DoctorFilter.liked
                              ? Container(
                                  height: 25,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xff2260FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Make Appointment",
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                      icon: Icons.info_outline,
                                      size: 15,
                                    ),
                                    SizedBox(width: 2),
                                    servicesOptions(
                                      icon: Icons.question_mark,
                                      size: 15,
                                    ),
                                    SizedBox(width: 2),
                                    BlocBuilder<
                                      DoctorScreenBloc,
                                      DoctorScreenState
                                    >(
                                      builder: (context, state) {
                                        final doctor = state.doctors[index];

                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<DoctorScreenBloc>()
                                                .add(LikedEvent(doctor.id));
                                          },
                                          child: servicesOptions(
                                            icon: doctor.isLiked
                                                ? Icons.favorite
                                                : Icons
                                                      .favorite_border_outlined,
                                            size:
                                                state.selectedFilter ==
                                                    DoctorFilter.liked
                                                ? 18
                                                : 15,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 2),
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

Widget serviceDetails() {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      return Column(
        children: List.generate(state.service.length, (index) {
          final service = state.service[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ServiceDropdown(
              title: service.title,
              discription: service.discription,
            ),
          );
        }),
      );
    },
  );
}
