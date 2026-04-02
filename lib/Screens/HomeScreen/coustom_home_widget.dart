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
                            width: double.infinity,
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
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                      height: 1.2,
                                    ),
                                  ),
                                  Text(
                                    doctor.getLocalized(doctor.specialization, langCode, localization),
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.black87,
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
    padding: EdgeInsets.all(AppSize.width(context) * 0.026),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSize.width(context) * 0.064),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSize.height(context) * 0.017,),
            _timeText(context, localization?.translate("9 AM") ?? "9 AM"),
            _timeText(context, localization?.translate("10 AM") ?? "10 AM"),
            _timeText(context, localization?.translate("11 AM") ?? "11 AM"),
            _timeText(context, localization?.translate("12 PM") ?? "12 PM"),
          ],
        ),
        SizedBox(width: AppSize.width(context) * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${localization?.translate("11 Wednesday") ?? "11 Wednesday"} - ${localization?.translate('today') ?? "Today"}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(context) *0.003,),
              Divider(color: colorScheme.primary.withOpacity(0.3)),
              // SizedBox(height: AppSize.height(context) *0.002,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                width: AppSize.width(context) *0.59,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(AppSize.width(context) * 0.04),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical:0),
                          child: Text(
                            localization?.translate("Dr. Olivia Turner, M.D.") ?? "Dr. Olivia Turner, M.D.",
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.width(context) * 0.07,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              _statusIcon("assets/images/right.svg.svg"),
                              SizedBox(width: 5),
                              _statusIcon("assets/images/wrong.svg.svg"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 4),
                    Text(
                      localization?.translate(' Treatment and prevention of\n skin and photodermatitis.') ??
                          "Treatment and prevention of skin and photodermatitis.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: AppSize.height(context) *0.0035,),
              Divider(color: colorScheme.primary.withOpacity(0.3)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _timeText(BuildContext context, String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: AppSize.height(context) * 0.0065),
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 11,
          ),
    ),
  );
}

Widget _statusIcon(String assetPath) {
  return Container(
    padding: EdgeInsetsGeometry.symmetric(vertical: 3,horizontal: 3),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Center(child: SvgPicture.asset(assetPath,fit: BoxFit.cover,height: 7,width: 7,)),
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
