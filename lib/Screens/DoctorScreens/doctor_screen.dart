import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Screens/HomeScreen/home_screen.dart';

import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Global/dummy_data.dart';
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
                    state.selectedFilter == DoctorFilter.liked
                        ? Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<DoctorScreenBloc>().add(
                                      TabEvent(isTab: true),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
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
                                          color: state.isTab
                                              ? Colors.white
                                              : Color(0xff2260FF),
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
                                    context.read<DoctorScreenBloc>().add(
                                      TabEvent(isTab: false),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !state.isTab
                                          ? Color(0xff2260FF)
                                          : Color(0xffCAD6FF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Services",
                                        style: GoogleFonts.leagueSpartan(
                                          color: !state.isTab
                                              ? Colors.white
                                              : Color(0xff2260FF),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 10),
                    state.isTab
                        ? Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          context.go(
                                            RouterName.doctorInfoScreen.path,
                                            extra: state.getDoctor[index],
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xffCAD6FF,
                                            ).withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    state.selectedFilter ==
                                                            DoctorFilter.rating
                                                        ? Row(
                                                            children: [
                                                              Container(
                                                                height: 18,
                                                                width: 18,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                    0xff2260FF,
                                                                  ),
                                                                ),
                                                                child: Image(
                                                                  image: AssetImage(
                                                                    "assets/images/qualification_badge_white.png",
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "Professional Doctor",
                                                                style: GoogleFonts.leagueSpartan(
                                                                  color: Color(
                                                                    0xff2260FF,
                                                                  ),
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              state.selectedFilter ==
                                                                      DoctorFilter
                                                                          .rating
                                                                  ? infoBadge(
                                                                      "assets/images/star_svg.svg",
                                                                      "5",
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : Container(),
                                                    SizedBox(height: 5),
                                                    BlocBuilder<
                                                      DoctorScreenBloc,
                                                      DoctorScreenState
                                                    >(
                                                      builder: (context, state) {
                                                        final doctor = state
                                                            .getDoctor[index];
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 6,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                state.selectedFilter ==
                                                                        DoctorFilter
                                                                            .rating ||
                                                                    state.selectedFilter ==
                                                                        DoctorFilter
                                                                            .liked
                                                                ? Colors.white
                                                                : Colors
                                                                      .transparent,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      "${doctor.doctorName},${doctor.qualification} ",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.leagueSpartan(
                                                                        fontSize:
                                                                            state.selectedFilter ==
                                                                                DoctorFilter.rating
                                                                            ? 15
                                                                            : 17,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Color(
                                                                          0xff2260FF,
                                                                        ),
                                                                        height:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    doctor
                                                                        .specialization,
                                                                    style: GoogleFonts.leagueSpartan(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                        0xff2260FF,
                                                                      ),
                                                                      height: 1,
                                                                    ),
                                                                  ),
                                                                  state.selectedFilter ==
                                                                          DoctorFilter
                                                                              .liked
                                                                      ? BlocBuilder<
                                                                          DoctorScreenBloc,
                                                                          DoctorScreenState
                                                                        >(
                                                                          builder:
                                                                              (
                                                                                context,
                                                                                state,
                                                                              ) {
                                                                                final liked = state.doctors[index];

                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    context
                                                                                        .read<
                                                                                          DoctorScreenBloc
                                                                                        >()
                                                                                        .add(
                                                                                          LikedEvent(
                                                                                            liked.id,
                                                                                          ),
                                                                                        );
                                                                                  },
                                                                                  child: servicesOptions(
                                                                                    icon: liked.isLiked
                                                                                        ? Icons.favorite
                                                                                        : Icons.favorite_border_outlined,
                                                                                    size:
                                                                                        state.selectedFilter ==
                                                                                            DoctorFilter.liked
                                                                                        ? 18
                                                                                        : 15,
                                                                                  ),
                                                                                );
                                                                              },
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                doctor
                                                                    .specialization,
                                                                style: GoogleFonts.leagueSpartan(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    state.selectedFilter ==
                                                            DoctorFilter.liked
                                                        ? SizedBox(height: 10)
                                                        : SizedBox(height: 15),
                                                    state.selectedFilter ==
                                                            DoctorFilter.liked
                                                        ? Container(
                                                            height: 25,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0xff2260FF,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                ),
                                                            child: Center(
                                                              child: Text(
                                                                "Make Appointment",
                                                                style: GoogleFonts.leagueSpartan(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .white,
                                                                  height: 1,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () =>
                                                                    context.go(
                                                                      RouterName
                                                                          .doctorInfoScreen
                                                                          .path,
                                                                    ),
                                                                child: Container(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            2,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: Color(
                                                                      0xff1B5FE0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          20,
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    "Info",
                                                                    style: GoogleFonts.leagueSpartan(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),

                                                              servicesOptions(
                                                                icon: Icons
                                                                    .calendar_month,
                                                                size: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              servicesOptions(
                                                                icon: Icons
                                                                    .info_outline,
                                                                size: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              servicesOptions(
                                                                icon: Icons
                                                                    .question_mark,
                                                                size: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              BlocBuilder<
                                                                DoctorScreenBloc,
                                                                DoctorScreenState
                                                              >(
                                                                builder: (context, state) {
                                                                  final doctor =
                                                                      state
                                                                          .doctors[index];

                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      context
                                                                          .read<
                                                                            DoctorScreenBloc
                                                                          >()
                                                                          .add(
                                                                            LikedEvent(
                                                                              doctor.id,
                                                                            ),
                                                                          );
                                                                    },
                                                                    child: servicesOptions(
                                                                      icon:
                                                                          doctor
                                                                              .isLiked
                                                                          ? Icons.favorite
                                                                          : Icons.favorite_border_outlined,
                                                                      size:
                                                                          state.selectedFilter ==
                                                                              DoctorFilter.liked
                                                                          ? 18
                                                                          : 15,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              SizedBox(
                                                                width: 2,
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
                                  ),
                                );
                              },
                              itemCount: state.getDoctor.length,
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child:
                                  BlocBuilder<
                                    DoctorScreenBloc,
                                    DoctorScreenState
                                  >(
                                    builder: (context, state) {
                                      return Column(
                                        children:List.generate(state.service.length, (index) {
                                          final service = state.service[index];

                                          return  ServiceDropdown(
                                            title: service.title,
                                            discription: service.discription,
                                          );
                                        },)
                                      );
                                    },
                                  ),
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
