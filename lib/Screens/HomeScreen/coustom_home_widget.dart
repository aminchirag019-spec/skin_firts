import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Helper/app_localizations.dart';
import '../../Utilities/colors.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';

Widget doctorInformationCard() {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final localization = AppLocalizations.of(context);

      if (state.getDoctor.isEmpty) {
        return Center(
          child: Text(
            localization?.translate('noDoctorsFound') ?? "No Doctors Found",
            style: theme.textTheme.bodyMedium,
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final doctor = state.getDoctor[index];
          final langCode = Localizations.localeOf(context).languageCode;

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.005,
              horizontal: AppSize.width(context) * 0.051,
            ),
            child: GestureDetector(
              onTap: () {
                context.go(RouterName.doctorInfoScreen.path, extra: doctor);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(context) * 0.035,
                  vertical: AppSize.height(context) * 0.009,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.064,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.width(context) * 0.087,
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.025),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppSize.width(context) * 0.769,
                            height: AppSize.height(context) * 0.045,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppSize.width(context) * 0.030,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.width(context) * 0.030,
                                vertical: AppSize.height(context) * 0.005,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${doctor.getLocalized(doctor.doctorName, langCode, localization)}, ${doctor.getLocalized(doctor.qualification, langCode, localization)}",
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    doctor.getLocalized(doctor.specialization, langCode, localization),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.black87,
                                      height: 0.9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSize.height(context) * 0.005),
                          Row(
                            children: [
                              infoBadge(
                                context,
                                "assets/images/star_svg.svg",
                                doctor.rating.toString(),
                              ),
                              SizedBox(width: AppSize.width(context) * 0.025),
                              infoBadge(
                                context,
                                "assets/images/meesage_svg.svg",
                                "60",
                              ),
                              const Spacer(),
                              circleIcon(
                                context,
                                Icons.question_mark,
                                isBlue: true,
                              ),
                              SizedBox(width: AppSize.width(context) * 0.012),
                              GestureDetector(
                                onTap: () {
                                  context.read<DoctorScreenBloc>().add(
                                        LikedEvent(doctor.id, !doctor.isLiked),
                                      );
                                },
                                child: circleIcon(
                                  context,
                                  doctor.isLiked ? Icons.favorite : Icons.favorite_border,
                                  isBlue: true,
                                ),
                              ),
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

Widget appointmentInformation(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final localization = AppLocalizations.of(context);

  return Container(
    height: AppSize.height(context) * 0.154,
    width: AppSize.width(context) * 3,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSize.width(context) * 0.064),
    ),
    child: Stack(
      children: [
        Positioned(
          left: AppSize.width(context) * 0.5,
          top: AppSize.height(context) * 0.011,
          child: Text(
            "11 Wednesday - ${localization?.translate('today') ?? "Today"}",
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Positioned(
          top: AppSize.height(context) * 0.027,
          left: AppSize.width(context) * 0.128,
          right: AppSize.width(context) * 0.128,
          child: Divider(color: colorScheme.primary, thickness: 1),
        ),
        Positioned(
          bottom: AppSize.height(context) * 0.015,
          left: AppSize.width(context) * 0.128,
          right: AppSize.width(context) * 0.128,
          child: Divider(color: colorScheme.primary, thickness: 1),
        ),
        Positioned(
          top: AppSize.height(context) * 0.017,
          left: AppSize.width(context) * 0.025,
          child: Column(
            children: [
              SizedBox(height: AppSize.height(context) * 0.009),
              Text(
                "9 AM",
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
              SizedBox(height: AppSize.height(context) * 0.009),
              Text(
                "10 AM",
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
              SizedBox(height: AppSize.height(context) * 0.009),
              Text(
                "11 AM",
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
              SizedBox(height: AppSize.height(context) * 0.005),
              Text(
                "12 AM",
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
            ],
          ),
        ),
        Positioned(
          top: AppSize.height(context) * 0.047,
          left: AppSize.width(context) * 0.141,
          child: Container(
            height: AppSize.height(context) * 0.071,
            width: AppSize.width(context) * 0.641,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppSize.width(context) * 0.051,
              ),
              color: colorScheme.secondary,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: AppSize.height(context) * 0.008,
                  left: AppSize.width(context) * 0.051,
                  child: Text(
                    localization?.translate("Dr. Olivia Turner, M.D.") ?? "Dr. Olivia Turner, M.D.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.height(context) * 0.033,
                  left: AppSize.width(context) * 0.051,
                  child: Text(
                    localization?.translate("treatment") ?? "treatment",
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 0.8,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.height(context) * 0.009,
                  right: AppSize.width(context) * 0.025,
                  child: Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/images/right_icon.png"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/images/wrong_icon.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget circleIcon(BuildContext context, IconData icon, {bool isBlue = false}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    height: 22,
    width: 22,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Icon(icon, size: 15, color: colorScheme.primary),
    ),
  );
}

Widget infoBadge(
  BuildContext context,
  String svgPath,
  String text, {
  double width = 50,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    width: AppSize.width(context) * (width / 390.0),
    height: 22,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 5),
        SvgPicture.asset(
          svgPath,
          height: 16,
          width: 16,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w300,
              ),
        ),
      ],
    ),
  );
}
