import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Helper/app_localizations.dart';

class CancelAppointmentScreen extends StatefulWidget {
  final String? appointmentId;
  const CancelAppointmentScreen({super.key, this.appointmentId});

  @override
  State<CancelAppointmentScreen> createState() => _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final List<String> reasons = [
      localization?.translate("rescheduling") ?? "Rescheduling",
      localization?.translate("weatherConditions") ?? "Weather Conditions",
      localization?.translate("unexpectedWork") ?? "Unexpected Work",
      localization?.translate("others") ?? "Others"
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topRow(
                context,
                onPressed: () => context.pop(),
                text: localization?.translate("cancelAppointment") ?? "Cancel Appointment",
              ),
              const SizedBox(height: 24),
              Text(
                localization?.translate("loreum") ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.7),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              ...reasons.map((reason) => _buildReasonItem(context, reason)).toList(),
              const SizedBox(height: 24),
              Text(
                localization?.translate("loreum") ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff809CFF).withOpacity(0.6),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffECF1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _reasonController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: localization?.translate("enterReason") ?? "Enter Your Reason Here...",
                    hintStyle: GoogleFonts.leagueSpartan(
                      color: const Color(0xff809CFF),
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: customButton(
                  context,
                  text: localization?.translate("cancelAppointment") ?? "Cancel Appointment",
                  backgroundColor: AppColors.darkPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    if (widget.appointmentId != null) {
                      // Update status to cancelled in Firebase
                      context.read<DoctorScreenBloc>().add(
                        UpdateAppointmentStatusEvent(widget.appointmentId!, "cancelled")
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Appointment Cancelled"), backgroundColor: Colors.red),
                      );

                      // Navigate back to the appointment list
                      context.pop();
                    } else {
                      context.pop();
                    }
                  },
                  width: double.infinity,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonItem(BuildContext context, String reason) {
    return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
      buildWhen: (previous, current) => previous.selectedCancelReason != current.selectedCancelReason,
      builder: (context, state) {
        bool isSelected = state.selectedCancelReason == reason;
        return GestureDetector(
          onTap: () {
            context.read<DoctorScreenBloc>().add(SelectCancelReasonEvent(reason));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xffCAD6FF).withOpacity(0.5) : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkPurple,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.darkPurple : Colors.transparent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  reason,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
