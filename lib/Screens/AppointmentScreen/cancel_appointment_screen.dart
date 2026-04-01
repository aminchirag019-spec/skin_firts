import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/media_query.dart';

class CancelAppointmentScreen extends StatefulWidget {
  const CancelAppointmentScreen({super.key});

  @override
  State<CancelAppointmentScreen> createState() => _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  String? _selectedReason;
  final List<String> _reasons = [
    "Rescheduling",
    "Weather Conditions",
    "Unexpected Work",
    "Others"
  ];
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                text: "Cancel Appointment",
              ),
              const SizedBox(height: 24),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.7),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              ..._reasons.map((reason) => _buildReasonItem(reason)).toList(),
              const SizedBox(height: 24),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
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
                    hintText: "Enter Your Reason Here...",
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
                  text: "Cancel Appointment",
                  backgroundColor: AppColors.darkPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    // Handle cancellation logic
                    context.pop();
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

  Widget _buildReasonItem(String reason) {
    bool isSelected = _selectedReason == reason;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reason;
        });
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
  }
}
