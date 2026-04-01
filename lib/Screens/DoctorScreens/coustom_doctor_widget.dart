import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Utilities/colors.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Global/dummy_data.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';
import '../../Helper/app_localizations.dart';
import '../HomeScreen/coustom_home_widget.dart';
import 'doctor_info_screen.dart';
import 'doctor_screen.dart';

Widget likedBar({String? text, String? title}) {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

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
                ),
                decoration: BoxDecoration(
                  color: state.isTab ? colorScheme.primary : colorScheme.secondary,
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.064,
                  ),
                ),
                child: Center(
                  child: Text(
                    text ?? "Doctors",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: state.isTab ? Colors.white : colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<DoctorScreenBloc>().add(TabEvent(isTab: false));
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(context) * 0.011,
                ),
                decoration: BoxDecoration(
                  color: !state.isTab ? colorScheme.primary : colorScheme.secondary,
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.064,
                  ),
                ),
                child: Center(
                  child: Text(
                    title ?? "Services",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: !state.isTab ? Colors.white : colorScheme.primary,
                      fontWeight: FontWeight.w400,
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

Widget  doctorDetailsCard() {
  return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
    builder: (context, state) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final localization = AppLocalizations.of(context);

      return ListView.builder(
        itemCount: state.getDoctor.length,
        itemBuilder: (context, index) {
          final doctor = state.getDoctor[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(context) * 0.009,
            ),
            child: GestureDetector(
              onTap: () {
                context.go(
                  RouterName.doctorInfoScreen.path,
                  extra: state.getDoctor[index],
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(context) * 0.011,
                  horizontal: AppSize.width(context) * 0.020,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(
                    AppSize.width(context) * 0.051,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.width(context) * 0.102,
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: AppSize.width(context) * 0.030),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.selectedFilter == DoctorFilter.rating)
                            Row(
                              children: [
                                Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.primary,
                                  ),
                                  child: const Image(
                                    image: AssetImage(
                                      "assets/images/qualification_badge_white.png",
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  localization?.translate('professionalDoctor') ?? "Professional Doctor",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const Spacer(),
                                infoBadge(
                                  context,
                                  "assets/images/star_svg.svg",
                                  "${doctor.rating}",
                                ),
                              ],
                            ),
                          SizedBox(height: AppSize.height(context) * 0.005),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: state.selectedFilter == DoctorFilter.rating || state.selectedFilter == DoctorFilter.liked
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${doctor.doctorName}, ${doctor.qualification}",
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.primary,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    if (state.selectedFilter == DoctorFilter.liked)
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
                                const SizedBox(height: 4),
                                Text(
                                  doctor.specialization.toString(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: state.selectedFilter == DoctorFilter.liked ? 10 : 15,
                          ),
                          if (state.selectedFilter == DoctorFilter.liked)
                            Container(
                              height: 25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  localization?.translate('makeAppointment') ?? "Make Appointment",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              ),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => context.go(
                                    RouterName.doctorInfoScreen.path,
                                    extra: doctor,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff1B5FE0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      localization?.translate('info') ?? "Info",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                servicesOptions(
                                  context,
                                  icon: Icons.calendar_month,
                                  size: 15,
                                ),
                                const SizedBox(width: 2),
                                servicesOptions(
                                  context,
                                  icon: Icons.info_outline,
                                  size: 15,
                                ),
                                const SizedBox(width: 2),
                                servicesOptions(
                                  context,
                                  icon: Icons.question_mark,
                                  size: 15,
                                ),
                                const SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    context.read<DoctorScreenBloc>().add(
                                          LikedEvent(doctor.id, !doctor.isLiked),
                                        );
                                  },
                                  child: servicesOptions(
                                    context,
                                    icon: doctor.isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                                    size: state.selectedFilter == DoctorFilter.liked ? 18 : 15,
                                  ),
                                ),
                                const SizedBox(width: 2),
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
      );
    },
  );
}
