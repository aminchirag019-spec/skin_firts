import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/dummy_data.dart';
import '../../Global/enums.dart';
import '../../Helper/app_localizations.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../HomeScreen/coustom_home_widget.dart';

class DoctorInfoScreen extends StatelessWidget {
  const DoctorInfoScreen({super.key, this.data});
  final AddDoctor? data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.doctorScreen.path);
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      doctorsTopRow(
                        context,
                        text: localization?.translate('info') ?? "Doctor Info",
                        onPressed: () {
                          context.go(RouterName.doctorScreen.path);
                        },
                      ),
                      SizedBox(height: AppSize.height(context) * 0.011),
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
                                              height: AppSize.width(context) * 0.058,
                                              width: AppSize.width(context) * 0.058,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Image(
                                                  image: const AssetImage(
                                                    "assets/images/qualification_badge_blue.png",
                                                  ),
                                                  height: AppSize.width(context) * 0.038,
                                                  width: AppSize.width(context) * 0.038,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: AppSize.width(context) * 0.020),
                                            Text(
                                              data?.experience ?? "",
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: Colors.white,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: AppSize.height(context) * 0.003),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff1B5FE0),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                              height: 0.9,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${localization?.translate('focus') ?? 'Focus'}: ",
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: data?.getLocalized(data?.description, langCode, localization) ?? "",
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
                                    "${data?.getLocalized(data?.doctorName, langCode, localization) ?? ""}, ${data?.getLocalized(data?.qualification, langCode, localization) ?? ""}",
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.primary,
                                      height: 1,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    data?.getLocalized(data?.specialization, langCode, localization) ?? "",
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
                                  data?.rating.toString() ?? "0",
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
                                      borderRadius: BorderRadius.circular(AppSize.width(context) * 0.051),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: AppSize.width(context) * 0.012),
                                        SvgPicture.asset(
                                          "assets/images/alarm_svg.svg",
                                          height: AppSize.width(context) * 0.041,
                                          width: AppSize.width(context) * 0.041,
                                          color: colorScheme.primary,
                                        ),
                                        SizedBox(width: AppSize.width(context) * 0.010),
                                        Text(
                                          "Mon-Sat / 9:00AM - 5:00PM",
                                          style: theme.textTheme.bodySmall?.copyWith(
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
                            SizedBox(height: AppSize.height(context) * 0.013),
                            Row(
                              children: [
                                Container(
                                  height: AppSize.height(context) * 0.035,
                                  width: AppSize.width(context) * 0.256,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(AppSize.width(context) * 0.051),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () {
                                          context.go(RouterName.doctorDetailsScreen.path,extra: data);
                                        },
                                        child: Text(
                                          localization?.translate('schedule') ?? "Schedule",
                                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                servicesOptions(
                                  context,
                                  icon: Icons.info_outline,
                                  size: 18,
                                ),
                                const SizedBox(width: 3),
                                servicesOptions(
                                  context,
                                  icon: Icons.question_mark,
                                  size: 18,
                                ),
                                const SizedBox(width: 3),
                                GestureDetector(
                                  onTap: () {
                                    context.push(RouterName.reviewScreen.path, extra: data);
                                  },
                                  child: servicesOptions(
                                    context,
                                    icon: Icons.star_outline,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                servicesOptions(
                                  context,
                                  icon: Icons.favorite_border_outlined,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.023),
                      Row(
                        children: [
                          Text(
                            localization?.translate('profile') ?? "Profile",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data?.getLocalized(data?.profile, langCode, localization) ?? "",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.height(context) * 0.023),
                      Row(
                        children: [
                          Text(
                            localization?.translate('careerPath') ?? "Career Path",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data?.getLocalized(data?.careerPath, langCode, localization) ?? "",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.height(context) * 0.023),
                      Row(
                        children: [
                          Text(
                            localization?.translate('highlights') ?? "Highlights",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data?.getLocalized(data?.highlights, langCode, localization) ?? "",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget doctorsTopRow(BuildContext context, {required String text, required VoidCallback onPressed}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Row(
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Icon(Icons.arrow_back_ios, color: colorScheme.primary),
      ),
      SizedBox(width: AppSize.width(context) * 0.012),
      Expanded(
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
          ),
        ),
      ),
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            const AssetImage("assets/images/search.png"),
            color: colorScheme.primary,
            size: 14,
          ),
        ),
      ),
      const SizedBox(width: 5),
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            const AssetImage("assets/images/tune.png"),
            color: colorScheme.primary,
            size: 15,
          ),
        ),
      ),
    ],
  );
}

Widget filterOptions(
  BuildContext context, {
  required IconData icon,
  required double size,
  required int index,
  required DoctorFilter filter,
}) {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      final colorScheme = Theme.of(context).colorScheme;
      bool isSelected = state.selectedIndex == index;

      return InkWell(
        onTap: () {
          context.read<DoctorScreenBloc>().add(FilterChangedEvent(index, filter));
          context.read<DoctorScreenBloc>().add(ApplyFilters(
                sortBy: filter == DoctorFilter.rating ? "Rating" : null,
                liked: filter == DoctorFilter.liked ? true : null,
                gender: filter == DoctorFilter.male
                    ? "male"
                    : filter == DoctorFilter.female
                        ? "female"
                        : null,
              ));
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? colorScheme.primary : colorScheme.secondary,
          ),
          child: Center(
            child: Icon(
              icon,
              size: size,
              color: isSelected ? Colors.white : colorScheme.primary,
            ),
          ),
        ),
      );
    },
  );
}

Widget servicesOptions(BuildContext context,{required IconData icon, required double size,Color? color}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    height: 25,
    width: 24,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? AppColors.white),
    child: Center(
      child: Icon(icon, size: size, color: colorScheme.primary),
    ),
  );
}
