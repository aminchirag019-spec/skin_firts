import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Screens/ChatScreens/chat_widget.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/media_query.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Helper/app_localizations.dart';
import '../../Router/router_class.dart';
import '../HomeScreen/coustom_home_widget.dart';
import '../DoctorScreens/doctor_info_screen.dart';

class AppointmentScreen extends StatelessWidget {
  final AddDoctor? doctor;
  const AppointmentScreen({super.key, this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: AppSize.width(context) * 0.166,
                                backgroundColor: Colors.white,
                                backgroundImage: const AssetImage(
                                  "assets/images/user_image.png",
                                ),
                              ),
                              SizedBox(width: AppSize.width(context) * 0.035),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height:
                                                AppSize.width(context) * 0.058,
                                            width:
                                                AppSize.width(context) * 0.058,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Image(
                                                image: const AssetImage(
                                                  "assets/images/qualification_badge_blue.png",
                                                ),
                                                height:
                                                    AppSize.width(context) *
                                                    0.038,
                                                width:
                                                    AppSize.width(context) *
                                                    0.038,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                AppSize.width(context) * 0.020,
                                          ),
                                          Text(
                                            doctor?.experience ?? "",
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  height: 1,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSize.height(context) * 0.003,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1B5FE0),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                                height: 0.9,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${localization?.translate('focus') ?? 'Focus'}: ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  doctor?.getLocalized(
                                                    doctor?.description,
                                                    langCode,
                                                    localization,
                                                  ) ??
                                                  "",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.height(context) * 0.011),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${doctor?.getLocalized(doctor?.doctorName, langCode, localization) ?? ""}, ${doctor?.getLocalized(doctor?.qualification, langCode, localization) ?? ""}",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.primary,
                                    height: 1,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Text(
                                  doctor?.getLocalized(
                                        doctor?.specialization,
                                        langCode,
                                        localization,
                                      ) ??
                                      "",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSize.height(context) * 0.013),
                          Row(
                            children: [
                              infoBadge(
                                context,
                                "assets/images/star_svg.svg",
                                doctor?.rating.toString() ?? "0",
                                width: 50,
                              ),
                              SizedBox(width: AppSize.width(context) * 0.007),
                              infoBadge(
                                context,
                                "assets/images/meesage_svg.svg",
                                "50",
                                width: 50,
                              ),
                              SizedBox(width: AppSize.width(context) * 0.012),
                              Expanded(
                                child: Container(
                                  height: AppSize.height(context) * 0.026,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      AppSize.width(context) * 0.051,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: AppSize.width(context) * 0.012,
                                      ),
                                      SvgPicture.asset(
                                        "assets/images/alarm_svg.svg",
                                        height: AppSize.width(context) * 0.041,
                                        width: AppSize.width(context) * 0.041,
                                        color: colorScheme.primary,
                                      ),
                                      SizedBox(
                                        width: AppSize.width(context) * 0.010,
                                      ),
                                      Text(
                                        "Mon-Sat / 9:00AM - 5:00PM",
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: -0.5,
                                              color: colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      localization?.translate('profile') ?? "Profile",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      doctor?.getLocalized(
                            doctor?.profile,
                            langCode,
                            localization,
                          ) ??
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildCalendarSection(context, theme, colorScheme, localization),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Icon(
              Icons.arrow_back_ios,
              color: colorScheme.primary,
              size: 20,
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  "Schedule",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          chatBarIcons(context, svgPath: "assets/images/audio.svg.svg",color: AppColors.darkPurple,imgColor: AppColors.white,imgWidth: 15,imgHeight: 15),
          chatBarIcons(context, svgPath: "assets/images/video.svg.svg",color: AppColors.darkPurple,imgColor: AppColors.white,imgWidth: 10,imgHeight: 10,height: 7,width:7),
          chatBarIcons(context, svgPath: "assets/images/bottom_message.svg",color: AppColors.darkPurple,imgColor: AppColors.white,imgHeight:15,imgWidth: 15),
          const Spacer(),
          _topBarIcon(Icons.help_outline, colorScheme.primary.withOpacity(0.5)),
          _topBarIcon(Icons.favorite, colorScheme.primary),
        ],
      ),
    );
  }

  Widget _topBarIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context,
    AddDoctor? doctor,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localization,
    String langCode,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: AppSize.width(context) * 0.15,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage(
                  "assets/images/user_image.png",
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            doctor?.experience ?? "20 years experience",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.2,
                          ),
                          children: [
                            const TextSpan(
                              text: "Focus: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  doctor?.getLocalized(
                                    doctor?.description,
                                    langCode,
                                    localization,
                                  ) ??
                                  "The impact of hormonal imbalances on skin conditions, specializing in acne, hirsutism, and other skin disorders.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  doctor?.getLocalized(
                        doctor?.doctorName,
                        langCode,
                        localization,
                      ) ??
                      "Dr. Olivia Turner, M.D.",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  doctor?.getLocalized(
                        doctor?.qualification,
                        langCode,
                        localization,
                      ) ??
                      "Dermato-Endocrinology",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              infoBadge(
                context,
                "assets/images/star_svg.svg",
                doctor?.rating.toString() ?? "4.5",
              ),
              infoBadge(context, "assets/images/meesage_svg.svg", "30"),
              _timeBadge(context, colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBadge(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.alarm, color: colorScheme.primary, size: 14),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              context.go(RouterName.scheduleScreen.path);
            },
            child: Text(
              "Mon - Sat / 9 AM - 4 PM",
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localization,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: colorScheme.secondary.withOpacity(0.3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios, size: 14, color: colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                "MONTH",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"].map((
              day,
            ) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
              builder: (context, state) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 31,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    int day = index + 1;
                    bool isSelected = day == 24;
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "$day",
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (day > 25
                                        ? Colors.black
                                        : colorScheme.primary.withOpacity(0.4)),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
