import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/media_query.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Helper/app_localizations.dart';

class ScheduleScreen extends StatelessWidget {
  final AddDoctor? doctor;
  const ScheduleScreen({super.key, this.doctor});

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
              _buildTopBar(context, doctor, colorScheme, langCode, localization),
              _buildDateSelection(context, colorScheme),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Time",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildTimeGrid(context, colorScheme),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    Text(
                      "Patient Details",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPatientSelection(context, colorScheme),
                    const SizedBox(height: 20),
                    Text("Full Name", style: theme.textTheme.bodySmall),
                    const SizedBox(height: 5),
                    coustomTextField(context: context, hintText: "Jane Doe", isBold: false),
                    const SizedBox(height: 15),
                    Text("Age", style: theme.textTheme.bodySmall),
                    const SizedBox(height: 5),
                    coustomTextField(context: context, hintText: "30", isBold: false),
                    const SizedBox(height: 15),
                    Text("Gender", style: theme.textTheme.bodySmall),
                    const SizedBox(height: 10),
                    _buildGenderSelection(context, colorScheme),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    Text("Describe your problem", style: theme.textTheme.bodySmall),
                    const SizedBox(height: 10),
                    _buildProblemDescription(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AddDoctor? doctor, ColorScheme colorScheme, String langCode, AppLocalizations? localization) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go(RouterName.appointmentScreen.path),
            icon: Icon(Icons.arrow_back_ios, color: colorScheme.primary, size: 20),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                doctor?.getLocalized(doctor.doctorName, langCode, localization) ?? "Dr. Olivia Turner, M.D.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _topBarIcon(Icons.phone, colorScheme.primary),
          _topBarIcon(Icons.videocam, colorScheme.primary),
          _topBarIcon(Icons.chat_bubble, colorScheme.primary),
          _topBarIcon(Icons.help_outline, colorScheme.primary.withOpacity(0.5)),
          _topBarIcon(Icons.favorite, colorScheme.primary),
        ],
      ),
    );
  }

  Widget _topBarIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildDateSelection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: colorScheme.secondary.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text("Month", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down, color: colorScheme.primary),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: colorScheme.primary, size: 16),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      int day = 22 + index;
                      bool isSelected = day == 24;
                      return Container(
                        width: 55,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? colorScheme.primary : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("$day", style: TextStyle(color: isSelected ? Colors.white : colorScheme.primary.withOpacity(0.4), fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"][index % 7],
                                style: TextStyle(color: isSelected ? Colors.white : colorScheme.primary.withOpacity(0.4), fontSize: 10)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: colorScheme.primary, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid(BuildContext context, ColorScheme colorScheme) {
    List<String> times = ["9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM", "4:00 PM"];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: times.length,
      itemBuilder: (context, index) {
        bool isSelected = times[index] == "10:00 AM";
        bool isBooked = times[index] == "10:30 AM";
        return Container(
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : (isBooked ? Colors.white : colorScheme.secondary.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              times[index],
              style: TextStyle(color: isSelected ? Colors.white : colorScheme.primary, fontSize: 9, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPatientSelection(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildChoiceChip("Yourself", false, colorScheme),
        const SizedBox(width: 10),
        _buildChoiceChip("Another Person", true, colorScheme),
      ],
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : colorScheme.primary.withOpacity(0.5), fontSize: 12),
      ),
    );
  }

  Widget _buildGenderSelection(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildChoiceChip("Male", false, colorScheme),
        const SizedBox(width: 10),
        _buildChoiceChip("Female", true, colorScheme),
        const SizedBox(width: 10),
        _buildChoiceChip("Other", false, colorScheme),
      ],
    );
  }

  Widget _buildProblemDescription(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffECF1FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightPurple, width: 1),
      ),
      child: const TextField(
        maxLines: null,
        decoration: InputDecoration(
          hintText: "Enter Your Problem Here...",
          hintStyle: TextStyle(color: Colors.black26, fontSize: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
