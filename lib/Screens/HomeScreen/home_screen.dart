import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skin_firts/Utilities/colors.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';

import '../../Global/custom_widgets.dart';
import '../../Helper/app_localizations.dart';
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
    context.read<DoctorScreenBloc>().add(GetAppointmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.height(context) * 0.017,
          ),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final isDoctor = authState.currentUser?.role == 'doctor';
              
              return Column(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${localization?.translate("welcome") ?? "Hi"}, ${isDoctor ? "Dr. " : ""}${authState.currentUser?.name ?? ""} ",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w300,
                                  height: 1,
                                ),
                              ),
                              Text(
                                authState.currentUser?.email ?? "",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go(RouterName.messageScreen.path);
                          },
                          child: homeCircleIcon(
                            context,
                            "assets/images/notification_icon.svg",
                            showDot: true,
                          ),
                        ),
                        SizedBox(width: AppSize.width(context) * 0.012),
                        GestureDetector(
                            onTap: () {
                              context.go(RouterName.settingScreen.path);
                            },
                            child: homeCircleIcon(context, "assets/images/setting.svg")),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  
                  if (!isDoctor) ...[
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
                              localization?.translate('doctors') ?? "Doctors",
                              context,
                            ),
                          ),
                          SizedBox(width: AppSize.width(context) * 0.025),
                          menuItem(
                            "assets/images/heart_image.svg",
                            localization?.translate('favorite') ?? "Favorite",
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
                  ] else ...[
                    doctorStats(context),
                  ],

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
                                      child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                                        builder: (context, state) {
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: appointmentDates.length,
                                            itemBuilder: (context, index) {
                                              final item = appointmentDates[index];
                                              bool isSelected = index == state.selectedDateIndex;

                                              final dateStr = DateFormat.d(locale).format(item.date);
                                              final localizedDateStr = localization?.formatNumber(dateStr) ?? dateStr;
                                              final dayStr = DateFormat.E(locale).format(item.date).toUpperCase();

                                              return GestureDetector(
                                                onTap: () {
                                                  context.read<DoctorScreenBloc>().add(SelectDateEvent(index));
                                                },
                                                child: Padding(
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
                                                          localizedDateStr,
                                                          style: TextStyle(
                                                            fontSize: AppSize.width(context) * 0.064,
                                                            fontWeight: FontWeight.bold,
                                                            color: isSelected ? Colors.white : AppColors.black,
                                                            height: 1,
                                                          ),
                                                        ),
                                                        Text(
                                                          dayStr,
                                                          style: TextStyle(
                                                            fontSize: AppSize.width(context) * 0.030,
                                                            color: isSelected ? Colors.white : Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
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
                                      child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                                        builder: (context, doctorState) {
                                          final appointments = doctorState.appointments;
                                          if (appointments.isEmpty) {
                                            return appointmentInformation(context); // Default placeholder
                                          }
                                          // Show the first upcoming appointment as a highlight
                                          return appointmentInformation(context, appointment: appointments.first);
                                        },
                                      )
                                  )
                                ]),
                          ),
                          SizedBox(height: AppSize.height(context) * 0.011),
                          if (!isDoctor) 
                            doctorInformationCard()
                          else 
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.width(context) * 0.051),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localization?.translate("Recent Patients") ?? "Recent Patients",
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                                    builder: (context, state) {
                                      if (state.appointments.isEmpty) {
                                        return const Center(child: Text("No patient records found"));
                                      }
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: state.appointments.length,
                                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          final appointment = state.appointments[index];
                                          return appointmentInformation(context, appointment: appointment);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
