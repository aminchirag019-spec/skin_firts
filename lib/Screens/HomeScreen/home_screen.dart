import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Utilities/colors.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';
import 'coustom_home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadCurrentUser());
    context.read<DoctorScreenBloc>().add(GetDoctorEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.height(context) * 0.017,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(context) * 0.064,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.width(context) * 0.064,
                      backgroundImage: const AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.030),
                    Expanded(
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${state.currentUser?.name ?? ""} ",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w300,
                                  height: 1,
                                ),
                              ),
                              Text(
                                state.currentUser?.email ?? "",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    homeCircleIcon(
                      context,
                      "assets/images/notification_icon.svg",
                      showDot: true,
                    ),
                    SizedBox(width: AppSize.width(context) * 0.012),
                    homeCircleIcon(context, "assets/images/setting.svg"),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.011),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(context) * 0.064,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go(RouterName.doctorScreen.path);
                      },
                      child: menuItem(
                        "assets/images/doctor_image.svg",
                        "Doctors",
                        context,
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.025),
                    menuItem(
                      "assets/images/heart_image.svg",
                      "Favorite",
                      context,
                    ),
                    SizedBox(width: AppSize.width(context) * 0.038),
                    Expanded(
                      child: SizedBox(
                        height: AppSize.height(context) * 0.041,
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: SizedBox(
                              width: AppSize.width(context) * 0.102,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: AppSize.width(context) * 0.010,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        AppSize.width(context) * 0.017,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ImageIcon(
                                        const AssetImage(
                                          "assets/images/tune.png",
                                        ),
                                        size: AppSize.width(context) * 0.038,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(
                                left: AppSize.width(context) * 0.010,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(
                                  AppSize.width(context) * 0.017,
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ImageIcon(
                                  const AssetImage("assets/images/search.png"),
                                  color: colorScheme.primary,
                                  size: AppSize.width(context) * 0.061,
                                ),
                              ),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppSize.height(context) * 0.014,
                              horizontal: AppSize.width(context) * 0.030,
                            ),
                            filled: true,
                            fillColor: colorScheme.secondary.withOpacity(0.6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSize.width(context) * 0.064,
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.017),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: AppSize.height(context) * 0.296,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withOpacity(0.6),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: AppSize.height(context) * 0.011,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.width(context) * 0.033,
                                ),
                                child: SizedBox(
                                  height: AppSize.height(context) * 0.082,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: appointmentDates.length,
                                    itemBuilder: (context, index) {
                                      final item = appointmentDates[index];
                                      bool isSelected = index == 2 || index == 4 || index == 5;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppSize.width(context) * 0.012,
                                        ),
                                        child: Container(
                                          width: AppSize.width(context) * 0.115,
                                          decoration: BoxDecoration(
                                            color: isSelected ? colorScheme.primary : AppColors.white,
                                            borderRadius: BorderRadius.circular(
                                              AppSize.width(context) * 0.051,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.date.toString(),
                                                style: TextStyle(
                                                  fontSize: AppSize.width(context) * 0.064,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected ? Colors.white : AppColors.black,
                                                  height: 1,
                                                ),
                                              ),
                                              Text(
                                                item.day,
                                                style: TextStyle(
                                                  fontSize: AppSize.width(context) * 0.030,
                                                  color: isSelected ? Colors.white : Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context) * 0.011,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.width(context) * 0.051,
                                    vertical: AppSize.height(context) * 0.011,
                                  ),
                                  child: appointmentInformation(context))
                            ]),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.011),
                      doctorInformationCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
