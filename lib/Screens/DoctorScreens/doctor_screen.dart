import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Screens/DoctorScreens/coustom_doctor_widget.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Global/dummy_data.dart';
import '../../Helper/app_localizations.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';
import 'doctor_info_screen.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

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
                  vertical: AppSize.height(context) * 0.017,
                  horizontal: AppSize.width(context) * 0.064,
                ),
                child: Column(
                  children: [
                    doctorsTopRow(
                      context,
                      text: localization?.translate('doctors') ?? "Doctors",
                      onPressed: () => context.go(RouterName.homeScreen.path),
                    ),
                    SizedBox(height: AppSize.height(context) * 0.023),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          localization?.translate('sortBy') ?? "Sort By",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                            height: 1,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: AppSize.width(context) * 0.012),
                        GestureDetector(
                          onTap: () async {
                            context.read<DoctorScreenBloc>().add(
                                   ApplyFilters(sortBy: "A->Z"),
                                );
                            context.read<DoctorScreenBloc>().add(
                                   FilterChangedEvent(-1, DoctorFilter.sortBy),
                                );
                            context.read<DoctorScreenBloc>().add(
                                   TabEvent(isTab: true),
                                );
                          },
                          child: Container(
                            width: AppSize.width(context) * 0.133,
                            height: AppSize.height(context) * 0.026,
                            decoration: BoxDecoration(
                              color: state.selectedIndex == -1 ? colorScheme.primary : colorScheme.secondary,
                              borderRadius: BorderRadius.circular(
                                AppSize.width(context) * 0.051,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "A→Z",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: state.selectedIndex == -1 ? Colors.white : colorScheme.primary,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.width(context) * 0.015),
                        filterOptions(
                          context,
                          icon: Icons.star_outline,
                          size: AppSize.width(context) * 0.046,
                          filter: DoctorFilter.rating,
                          index: 0,
                        ),
                        SizedBox(width: AppSize.width(context) * 0.015),
                        filterOptions(
                          context,
                          icon: Icons.favorite_border,
                          size: AppSize.width(context) * 0.041,
                          filter: DoctorFilter.liked,
                          index: 1,
                        ),
                        SizedBox(width: AppSize.width(context) * 0.015),
                        filterOptions(
                          context,
                          icon: Icons.female,
                          size: AppSize.width(context) * 0.046,
                          index: 2,
                          filter: DoctorFilter.female,
                        ),
                        SizedBox(width: AppSize.width(context) * 0.015),
                        filterOptions(
                          context,
                          icon: Icons.male,
                          size: AppSize.width(context) * 0.046,
                          index: 3,
                          filter: DoctorFilter.male,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    if (state.selectedFilter == DoctorFilter.liked) likedBar(
                      text: localization?.translate('doctors') ?? "Doctors",
                      title: localization?.translate('services') ?? "Services",
                    ) else Container(),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    state.isTab
                        ? Expanded(child: doctorDetailsCard())
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              // child: serviceDetails(),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
              height: AppSize.height(context) * 0.065,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(
                  AppSize.width(context) * 0.076,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  const Icon(Icons.favorite, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: colorScheme.primary,
                      size: AppSize.width(context) * 0.076,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              )),
        ),
        SizedBox(height: AppSize.height(context) * 0.011),
        if (isExpanded) ...[
          Container(
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(
                AppSize.width(context) * 0.038,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.017,
              horizontal: AppSize.width(context) * 0.033,
            ),
            child: Text(
              widget.discription,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1,
                letterSpacing: -0.3,
              ),
            ),
          ),
          SizedBox(height: AppSize.height(context) * 0.011),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(
                AppSize.width(context) * 0.038,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.017,
              horizontal: AppSize.width(context) * 0.033,
            ),
            child: Center(
              child: Text(
                "Looking doctors",
                style: theme.textTheme.titleLarge?.copyWith(
                  height: 0.8,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
