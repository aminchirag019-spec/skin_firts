import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Screens/DoctorScreens/coustom_doctor_widget.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Router/router_class.dart';
import '../../Utilities/colors.dart';
import '../DoctorScreens/doctor_screen.dart';
import '../ProfileScreen/add_doctor_screen.dart';

class HelpCentreScreen extends StatelessWidget {
  const HelpCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white),
      child: WillPopScope(
        onWillPop: () async {
          context.go(RouterName.profileScreen.path);
          return false;
        },
        child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
          builder: (context, state) {
            return Scaffold(
                backgroundColor: AppColors.white,
                body: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            color: AppColors.darkPurple
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              topRow(
                                  context,
                                  onPressed: () =>
                                      context.go(RouterName.profileScreen.path),
                                  text: "Help Centre", color: AppColors.white
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "How Can We Help You?",
                                      style: GoogleFonts.leagueSpartan(
                                        color: AppColors.lightPurple,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      )
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.white,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/images/search.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        child: likedBar(text: "FAQ", title: "Contact Us"),
                      ),
                      Expanded(
                        child: state.isTab
                            ? serviceDetails()   // should contain ListView
                            : doctorDetailsCard(),
                      ),
                    ],
                  ),
                )
            );
          },
        ),
      ),
    );
  }
}

