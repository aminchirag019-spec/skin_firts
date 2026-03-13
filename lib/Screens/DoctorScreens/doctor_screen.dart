import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Screens/DoctorScreens/coustom_doctor_widget.dart';
import 'package:skin_firts/Screens/HomeScreen/home_screen.dart';

import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Global/dummy_data.dart';
import 'doctor_info_screen.dart';
import 'doctor_screen.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorScreenBloc>().add(GetDoctorEvent());
    context.read<DoctorScreenBloc>().add(GetServiceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.homeScreen.path);
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
                              onTap: () async {
                                context.read<DoctorScreenBloc>().add(
                                  ApplyFilters(filter: DoctorFilter.none),
                                );
                                context.read<DoctorScreenBloc>().add(
                                  FilterChangedEvent(-1),
                                );
                                context.read<DoctorScreenBloc>().add(
                                  TabEvent(isTab: true),
                                );
                              },
                              child: Container(
                                width: 52,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: state.selectedIndex == -1
                                      ? Color(0xff2260FF)
                                      : Color(0xffCAD6FF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "A→Z",
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: state.selectedIndex == -1
                                          ? Colors.white
                                          : Color(0xff2260FF),
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
                              filter: DoctorFilter.rating,
                              index: 0,
                            ),
                            SizedBox(width: 6),
                            filterOptions(
                              icon: Icons.favorite_border,
                              size: 16,
                              filter: DoctorFilter.liked,
                              index: 1,
                            ),
                            SizedBox(width: 6),
                            filterOptions(
                              icon: Icons.female,
                              size: 18,
                              index: 2,
                              filter: DoctorFilter.female,
                            ),
                            SizedBox(width: 6),
                            filterOptions(
                              icon: Icons.male,
                              size: 18,
                              index: 3,
                              filter: DoctorFilter.male,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    if (state.selectedFilter == DoctorFilter.liked)
                      likedBar()
                    else
                      Container(),
                    SizedBox(height: 10),
                    state.isTab
                        ? Expanded(
                            child: doctorDetailsCard(),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: serviceDetails(),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ServiceDropdown extends StatefulWidget {
  final String title;
  final String discription;

  const ServiceDropdown({
    super.key,
    required this.title,
    required this.discription,
  });

  @override
  State<ServiceDropdown> createState() => _ServiceDropdownState();
}

class _ServiceDropdownState extends State<ServiceDropdown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff2260FF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                SizedBox(width: 15),
                Icon(Icons.favorite, color: Colors.white),
                SizedBox(width: 10),

                Text(
                  widget.title,
                  style: GoogleFonts.leagueSpartan(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    letterSpacing: -0.1,
                    fontSize: 19,
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Color(0xff2260FF),
                    size: 30,
                  ),
                ),

                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        if (isExpanded) ...[
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffCAD6FF),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
            child: Text(
              widget.discription,
              style: GoogleFonts.leagueSpartan(
                height: 1,
                fontSize: 14,
                letterSpacing: -0.3,
              ),
            ),
          ),

          SizedBox(height: 10),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffCAD6FF),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
            child: Center(
              child: Text(
                "Looking doctors",
                style: GoogleFonts.leagueSpartan(
                  height: 0.8,
                  fontSize: 20,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff2260FF),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
