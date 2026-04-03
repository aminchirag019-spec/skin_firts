import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/Data/appointment_model.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Helper/app_localizations.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorScreenBloc>().add(GetAppointmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final List<String> tabs = [
      localization?.translate("complete") ?? "Complete",
      localization?.translate("upcoming") ?? "Upcoming",
      localization?.translate("cancelled") ?? "Cancelled"
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: topRow(
                context,
                onPressed: () => context.pop(),
                text: localization?.translate("allAppointment") ?? "All Appointment",
              ),
            ),
            const SizedBox(height: 16),
            _buildTabs(context, tabs),
            const SizedBox(height: 24),
            Expanded(
              child: _buildAppointmentList(tabs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, List<String> tabs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
        buildWhen: (previous, current) => previous.selectedAppointmentTabIndex != current.selectedAppointmentTabIndex,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(tabs.length, (index) {
              bool isSelected = state.selectedAppointmentTabIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<DoctorScreenBloc>().add(SelectAppointmentTabEvent(index));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.darkPurple : const Color(0xffCAD6FF).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: GoogleFonts.leagueSpartan(
                          color: isSelected ? Colors.white : AppColors.darkPurple.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentList(List<String> tabs) {
    return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
      builder: (context, state) {
        final statusMap = {0: "complete", 1: "upcoming", 2: "cancelled"};
        final targetStatus = statusMap[state.selectedAppointmentTabIndex];

        final filteredAppointments = state.appointments.where((a) => a.status == targetStatus).toList();

        if (filteredAppointments.isEmpty) {
          return Center(
            child: Text(
              "No appointments found",
              style: GoogleFonts.leagueSpartan(color: AppColors.darkPurple),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredAppointments.length,
          itemBuilder: (context, index) {
            return _buildAppointmentCard(context, filteredAppointments[index], state.selectedAppointmentTabIndex);
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(BuildContext context, AppointmentModel appointment, int selectedIndex) {
    final localization = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffD6E0FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(appointment.doctorImage),
                backgroundColor: AppColors.lightPurple,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${appointment.doctorName}, ${appointment.doctorQualification}",
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkPurple,
                      ),
                    ),
                    Text(
                      appointment.doctorSpecialization,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (selectedIndex == 0) // Complete
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.blue, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  localization?.formatNumber("4.5") ?? "4.5",
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SvgPicture.asset(
                            "assets/images/heart_image.svg",
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(AppColors.darkPurple, BlendMode.srcIn),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selectedIndex == 1) ...[ // Upcoming
            Row(
              children: [
                _buildInfoChip(Icons.calendar_month_outlined, appointment.date),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.access_time, appointment.time),
              ],
            ),
            const SizedBox(height: 16),
          ],
          _buildActionButtons(context, appointment, selectedIndex),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.darkPurple),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 11,
                  color: AppColors.darkPurple,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppointmentModel appointment, int selectedIndex) {
    final localization = AppLocalizations.of(context);
    if (selectedIndex == 0) { // Complete
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.darkPurple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(localization?.translate("reBook") ?? "Re-Book", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(localization?.translate("addReview") ?? "Add Review", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      );
    } else if (selectedIndex == 1) { // Upcoming
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(localization?.translate("details") ?? "Details", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          _buildIconActionButton("assets/images/right.svg.svg", () {
             context.read<DoctorScreenBloc>().add(UpdateAppointmentStatusEvent(appointment.id, "complete"));
          }),
          const SizedBox(width: 12),
          _buildIconActionButton("assets/images/wrong.svg.svg", () {
             context.read<DoctorScreenBloc>().add(UpdateAppointmentStatusEvent(appointment.id, "cancelled"));
             context.push(RouterName.cancelAppointmentScreen.path);
          }),
        ],
      );
    } else { // Cancelled
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.go(RouterName.reviewScreen.path);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPurple,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(localization?.translate("addReview") ?? "Add Review", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
        ),
      );
    }
  }

  Widget _buildIconActionButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          assetPath,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(AppColors.darkPurple, BlendMode.srcIn),
        ),
      ),
    );
  }
}
