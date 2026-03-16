import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Global/dummy_data.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';
import '../HomeScreen/coustom_home_widget.dart';
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
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(context) * 0.011,
                ), // 10
                decoration: BoxDecoration(
                  color: state.isTab
                      ? const Color(0xff2260FF)
                      : const Color(0xffCAD6FF),
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.064,
                  ), // 25
                ),
                child: Center(
                  child: Text(
                    "Doctors",
                    style: GoogleFonts.leagueSpartan(
                      color: state.isTab
                          ? Colors.white
                          : const Color(0xff2260FF),
                      fontWeight: FontWeight.w400,
                      fontSize: AppSize.width(context) * 0.051, // 20
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: AppSize.width(context) * 0.025), // 10

          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<DoctorScreenBloc>().add(TabEvent(isTab: false));
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(context) * 0.011,
                ), // 10
                decoration: BoxDecoration(
                  color: !state.isTab
                      ? const Color(0xff2260FF)
                      : const Color(0xffCAD6FF),
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.064,
                  ), // 25
                ),
                child: Center(
                  child: Text(
                    "Services",
                    style: GoogleFonts.leagueSpartan(
                      color: !state.isTab
                          ? Colors.white
                          : const Color(0xff2260FF),
                      fontWeight: FontWeight.w400,
                      fontSize: AppSize.width(context) * 0.051, // 20
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
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.009,
            ), // 8
            child: GestureDetector(
              onTap: () {
                context.go(
                  RouterName.doctorInfoScreen.path,
                  extra: state.getDoctor[index],
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(context) * 0.011, // 10
                  horizontal: AppSize.width(context) * 0.020, // 8
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffCAD6FF).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.051,
                  ), // 20
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.width(context) * 0.102, // 40
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.030), // 12
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state.selectedFilter == DoctorFilter.rating
                              ? Row(
                                  children: [
                                    Container(
                                      height:
                                          AppSize.width(context) * 0.046, // 18
                                      width:
                                          AppSize.width(context) * 0.046, // 18
                                      decoration:  BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff2260FF),
                                      ),
                                      child:  Image(
                                        image: AssetImage(
                                          "assets/images/qualification_badge_white.png",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context) * 0.012,
                                    ), // 5
                                    Text(
                                      "Professional Doctor",
                                      style: GoogleFonts.leagueSpartan(
                                        color: const Color(0xff2260FF),
                                        fontSize:
                                            AppSize.width(context) *
                                            0.030, // 12
                                      ),
                                    ),
                                    const Spacer(),
                                    state.selectedFilter == DoctorFilter.rating
                                        ? infoBadge(
                                            context,
                                            "assets/images/star_svg.svg",
                                            "${state.getDoctor[index].rating}",
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: AppSize.height(context) * 0.005,
                          ), // 5
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.width(context) * 0.025, // 10
                              vertical: AppSize.height(context) * 0.007, // 6
                            ),
                            decoration: BoxDecoration(
                              color:
                                  state.selectedFilter == DoctorFilter.rating ||
                                      state.selectedFilter == DoctorFilter.liked
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppSize.width(context) * 0.038,
                              ), // 15
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${doctor.doctorName},${doctor.qualification} ",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize:
                                              state.selectedFilter ==
                                                  DoctorFilter.rating
                                              ? AppSize.width(context) *
                                                    0.038 // 15
                                              : AppSize.width(context) *
                                                    0.043, // 17
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff2260FF),
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    state.selectedFilter == DoctorFilter.liked ?
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
                                    ) : Container()
                                  ],
                                ),
                                SizedBox(
                                  height: AppSize.height(context) * 0.004,
                                ), // 4
                                Text(
                                  doctor.specialization,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize:
                                        AppSize.width(context) * 0.035, // 14
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          state.selectedFilter == DoctorFilter.liked
                              ? SizedBox(
                                  height: AppSize.height(context) * 0.011,
                                ) // 10
                              : SizedBox(
                                  height: AppSize.height(context) * 0.017,
                                ), // 15
                          state.selectedFilter == DoctorFilter.liked
                              ? Container(
                                  height: AppSize.height(context) * 0.029, // 25
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff2260FF),
                                    borderRadius: BorderRadius.circular(
                                      AppSize.width(context) * 0.051,
                                    ), // 20
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Make Appointment",
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize:
                                            AppSize.width(context) *
                                            0.030, // 12
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
                                        extra: state.getDoctor[index],
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppSize.width(context) *
                                              0.038, // 15
                                          vertical:
                                              AppSize.height(context) *
                                              0.002, // 2
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff1B5FE0),
                                          borderRadius: BorderRadius.circular(
                                            AppSize.width(context) *
                                                0.051, // 20
                                          ),
                                        ),
                                        child: Text(
                                          "Info",
                                          style: GoogleFonts.leagueSpartan(
                                            fontSize:
                                                AppSize.width(context) *
                                                0.046, // 18
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context) * 0.025,
                                    ), // 10

                                    servicesOptions(
                                      context,
                                      icon: Icons.calendar_month,
                                      size:
                                          AppSize.width(context) * 0.038, // 15
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context) * 0.005,
                                    ), // 2
                                    servicesOptions(
                                      context,
                                      icon: Icons.info_outline,
                                      size:
                                          AppSize.width(context) * 0.038, // 15
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context) * 0.005,
                                    ), // 2
                                    servicesOptions(
                                      context,
                                      icon: Icons.question_mark,
                                      size:
                                          AppSize.width(context) * 0.038, // 15
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context) * 0.005,
                                    ), // 2
                                    BlocBuilder<
                                      DoctorScreenBloc,
                                      DoctorScreenState
                                    >(
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<DoctorScreenBloc>()
                                                .add(LikedEvent(
                                                    doctor.id,
                                                    !doctor.isLiked));
                                          },
                                          child: servicesOptions(
                                            context,
                                            icon: doctor.isLiked
                                                ? Icons.favorite
                                                : Icons
                                                      .favorite_border_outlined,
                                            size:
                                                state.selectedFilter ==
                                                    DoctorFilter.liked
                                                ? AppSize.width(context) *
                                                      0.046 // 18
                                                : AppSize.width(context) *
                                                      0.038, // 15
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context) * 0.005,
                                    ), // 2
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
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.009,
            ), // 8
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
