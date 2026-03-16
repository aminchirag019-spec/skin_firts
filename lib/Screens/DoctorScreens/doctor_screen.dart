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
import '../../Utilities/media_query.dart';
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
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(context) * 0.017, // 15
                  horizontal: AppSize.width(context) * 0.064, // 25
                ),
                child: Column(
                  children: [
                    doctorsTopRow(
                      context,
                      text: "Doctors",
                      onPressed: () => context.go(RouterName.homeScreen.path),
                    ),
                    SizedBox(height: AppSize.height(context) * 0.023), // 20
                         Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Sort By",
                              style: GoogleFonts.leagueSpartan(
                                fontSize: AppSize.width(context) * 0.035, // 14
                                fontWeight: FontWeight.w300,
                                height: 1,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) * 0.012,
                            ),
                            GestureDetector(
                              onTap: () async {
                                context.read<DoctorScreenBloc>().add(
                                  ApplyFilters(sortBy: "A->Z"),
                                );
                                context.read<DoctorScreenBloc>().add(
                                  FilterChangedEvent(-1,DoctorFilter.sortBy),
                                );
                                context.read<DoctorScreenBloc>().add(
                                  TabEvent(isTab: true),
                                );
                              },
                              child: Container(
                                width: AppSize.width(context) * 0.133, // 52
                                height: AppSize.height(context) * 0.026, // 22
                                decoration: BoxDecoration(
                                  color: state.selectedIndex == -1
                                      ?  Color(0xff2260FF)
                                      :  Color(0xffCAD6FF),
                                  borderRadius: BorderRadius.circular(
                                    AppSize.width(context) * 0.051,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "A→Z",
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize:
                                          AppSize.width(context) * 0.038,
                                      fontWeight: FontWeight.w600,
                                      color: state.selectedIndex == -1
                                          ? Colors.white
                                          :  Color(0xff2260FF),
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) * 0.015,
                            ), // 6
                            filterOptions(
                              context,
                              icon: Icons.star_outline,
                              size: AppSize.width(context) * 0.046, // 18
                              filter: DoctorFilter.rating,
                              index: 0,
                            ),
                            SizedBox(
                              width: AppSize.width(context) * 0.015,
                            ), // 6
                            filterOptions(
                              context,
                              icon: Icons.favorite_border,
                              size: AppSize.width(context) * 0.041, // 16
                              filter: DoctorFilter.liked,
                              index: 1,
                            ),
                            SizedBox(
                              width: AppSize.width(context) * 0.015,
                            ), // 6
                            filterOptions(
                              context,
                              icon: Icons.female,
                              size: AppSize.width(context) * 0.046, // 18
                              index: 2,
                              filter: DoctorFilter.female,
                            ),
                            SizedBox(
                              width: AppSize.width(context) * 0.015,
                            ), // 6
                            filterOptions(
                              context,
                              icon: Icons.male,
                              size: AppSize.width(context) * 0.046, // 18
                              index: 3,
                              filter: DoctorFilter.male,
                            ),
                          ],
                        ),
                    SizedBox(height: AppSize.height(context) * 0.011), // 10
                    if (state.selectedFilter == DoctorFilter.liked)
                      likedBar()
                    else
                      Container(),
                    SizedBox(height: AppSize.height(context) * 0.011), // 10
                    state.isTab
                        ? Expanded(child: doctorDetailsCard())
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
            height: AppSize.height(context) * 0.065, // 55
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff2260FF),
              borderRadius: BorderRadius.circular(
                AppSize.width(context) * 0.076,
              ), // 30
            ),
            child: Row(
              children: [
                SizedBox(width: AppSize.width(context) * 0.038),
                Icon(Icons.favorite, color: Colors.white),

                SizedBox(width: AppSize.width(context) * 0.025),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: -0.1,
                      fontSize: AppSize.width(context) * 0.048,
                    ),
                  ),
                ),

                 Spacer(),

                Container(
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color:  Color(0xff2260FF),
                    size: AppSize.width(context) * 0.076,
                  ),
                ),

                SizedBox(width: AppSize.width(context) * 0.025),
              ],
            )
          ),
        ),
        SizedBox(height: AppSize.height(context) * 0.011), // 10
        if (isExpanded) ...[
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffCAD6FF),
              borderRadius: BorderRadius.circular(
                AppSize.width(context) * 0.038,
              ), // 15
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.017, // 15
              horizontal: AppSize.width(context) * 0.033, // 13
            ),
            child: Text(
              widget.discription,
              style: GoogleFonts.leagueSpartan(
                height: 1,
                fontSize: AppSize.width(context) * 0.035, // 14
                letterSpacing: -0.3,
              ),
            ),
          ),

          SizedBox(height: AppSize.height(context) * 0.011), // 10

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffCAD6FF),
              borderRadius: BorderRadius.circular(
                AppSize.width(context) * 0.038,
              ), // 15
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.017, // 15
              horizontal: AppSize.width(context) * 0.033, // 13
            ),
            child: Center(
              child: Text(
                "Looking doctors",
                style: GoogleFonts.leagueSpartan(
                  height: 0.8,
                  fontSize: AppSize.width(context) * 0.051, // 20
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff2260FF),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
