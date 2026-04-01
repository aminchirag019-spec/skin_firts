import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Global/dummy_data.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/media_query.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["Complete", "Upcoming", "Cancelled"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: topRow(
                context,
                onPressed: () => context.pop(),
                text: "All Appointment",
              ),
            ),
             SizedBox(height: 16),
            _buildTabs(),
             SizedBox(height: 24),
            Expanded(
              child: _buildAppointmentList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_tabs.length, (index) {
          bool isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin:  EdgeInsets.symmetric(horizontal: 4),
                padding:  EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.darkPurple :  Color(0xffCAD6FF).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
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
      ),
    );
  }

  Widget _buildAppointmentList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return _buildAppointmentCard(doctor);
      },
    );
  }

  Widget _buildAppointmentCard(DummyData doctor) {
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
                backgroundImage: doctor.image,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${doctor.doctorName}, ${doctor.qualification}",
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkPurple,
                      ),
                    ),
                    Text(
                      doctor.title,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedIndex == 0) // Complete
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
                                  doctor.rating.toString(),
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
          if (_selectedIndex == 1) ...[ // Upcoming
            Row(
              children: [
                _buildInfoChip(Icons.calendar_month_outlined, "Sunday, 12 June"),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.access_time, "9:30 AM - 10:00 AM"),
              ],
            ),
             SizedBox(height: 16),
          ],
          _buildActionButtons(doctor),
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
             SizedBox(width: 6),
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

  Widget _buildActionButtons(DummyData doctor) {
    if (_selectedIndex == 0) { // Complete
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
              child: Text("Re-Book", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
            ),
          ),
           SizedBox(width: 12),
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
              child: Text("Add Review", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      );
    } else if (_selectedIndex == 1) { // Upcoming
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
              child: Text("Details", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
            ),
          ),
           SizedBox(width: 12),
          _buildIconActionButton("assets/images/right.svg.svg", () {}),
           SizedBox(width: 12),
          _buildIconActionButton("assets/images/wrong.svg.svg", () {}),
        ],
      );
    } else { // Cancelled
      return SizedBox(
        width: double.infinity,
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
          child: Text("Add Review", style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600)),
        ),
      );
    }
  }

  Widget _buildIconActionButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:  BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          assetPath,
          height: 20,
          width: 20,
          colorFilter:  ColorFilter.mode(AppColors.darkPurple, BlendMode.srcIn),
        ),
      ),
    );
  }
}
