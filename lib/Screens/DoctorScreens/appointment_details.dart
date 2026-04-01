import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Screens/HomeScreen/coustom_home_widget.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/media_query.dart';
import '../../Helper/app_localizations.dart';

class AppointmentDetails extends StatelessWidget {
  final AddDoctor? doctor;
  const AppointmentDetails({super.key, this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: topRow(
                context,
                onPressed: () => context.pop(),
                text: localization?.translate('Your Appointment') ?? "Your Appointment",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildDoctorCard(context, theme, colorScheme, localization, langCode),
                    const SizedBox(height: 30),
                    const Divider(color: AppColors.blue, thickness: 1),
                    const SizedBox(height: 20),
                    _buildDateTimeSection(context, colorScheme, localization),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.blue, thickness: 1),
                    const SizedBox(height: 20),
                    _buildPatientDetails(context, theme, colorScheme, localization),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.blue, thickness: 1),
                    const SizedBox(height: 20),
                    _buildProblemSection(context, theme, colorScheme, localization),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, ThemeData theme, ColorScheme colorScheme, AppLocalizations? localization, String langCode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSize.width(context) * 0.11,
            backgroundColor: Colors.white,
            backgroundImage: const AssetImage("assets/images/user_image.png"),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor != null 
                            ? "${doctor!.getLocalized(doctor!.doctorName, langCode, localization)}, ${doctor!.getLocalized(doctor!.qualification, langCode, localization)}"
                            : "Dr. Olivia Turner, M.D.",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        doctor != null 
                            ? doctor!.getLocalized(doctor!.specialization, langCode, localization)
                            : "Dermato-Endocrinology",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    infoBadge(context, "assets/images/star_svg.svg", doctor?.rating.toString() ?? "5"),
                    const SizedBox(width: 8),
                    infoBadge(context, "assets/images/meesage_svg.svg", "60"),
                    const Spacer(),
                    circleIcon(context, Icons.question_mark, isBlue: true),
                    const SizedBox(width: 8),
                    circleIcon(context, Icons.favorite, isBlue: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection(BuildContext context, ColorScheme colorScheme, AppLocalizations? localization) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Month 24, Year",
                  style: GoogleFonts.leagueSpartan(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  "WED, 10:00 AM",
                  style: GoogleFonts.leagueSpartan(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        _statusIcon("assets/images/right.svg.svg", colorScheme.primary),
        const SizedBox(width: 12),
        _statusIcon("assets/images/wrong.svg.svg", colorScheme.primary),
      ],
    );
  }

  Widget _statusIcon(String assetPath, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        assetPath,
        height: 16,
        width: 16,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildPatientDetails(BuildContext context, ThemeData theme, ColorScheme colorScheme, AppLocalizations? localization) {
    return Column(
      children: [
        _detailRow(localization?.translate('bookingFor') ?? "Booking For", "Another Person"),
        const SizedBox(height: 12),
        _detailRow(localization?.translate('fullName') ?? "Full Name", "Jane Doe"),
        const SizedBox(height: 12),
        _detailRow(localization?.translate('age') ?? "Age", "30"),
        const SizedBox(height: 12),
        _detailRow(localization?.translate('gender') ?? "Gender", "Female"),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.leagueSpartan(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.leagueSpartan(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProblemSection(BuildContext context, ThemeData theme, ColorScheme colorScheme, AppLocalizations? localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization?.translate('problem') ?? "Problem",
          style: GoogleFonts.leagueSpartan(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
          style: GoogleFonts.leagueSpartan(
            color: Colors.black,
            fontSize: 14,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
