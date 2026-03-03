import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/coustom_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        "assets/images/user_image.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, WelcomeBack",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 12,
                              color: Color(0xff2260FF),
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                          Text(
                            "John Doe",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    circleIcon("assets/images/notification_icon.svg"),
                    SizedBox(width: 5),
                    circleIcon("assets/images/setting.svg"),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    menuItem("assets/images/doctor_image.svg", "Doctors"),
                    SizedBox(width: 10),
                    menuItem("assets/images/heart_image.svg", "Favorite"),
                    SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ImageIcon(
                                      AssetImage("assets/images/tune.png"),
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ImageIcon(
                                      AssetImage("assets/images/search.png"),
                                      color: Color(0xff2260FF),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            filled: true,
                            fillColor: Color(0xffCAD6FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xffCAD6FF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: SizedBox(
                        height: 70,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: appointmentDates.length,
                          itemBuilder: (context, index) {
                            final item = appointmentDates[index];
                            bool isSelected =
                                index == 2 || index == 4 || index == 5;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Container(
                                width: 45,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xff2260FF)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.date.toString(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        height: 1,
                                      ),
                                    ),
                                    Text(
                                      item.day,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 155,
                              top: 10,
                              child: Text(
                                "11 Wednesday - Today",
                                style: GoogleFonts.leagueSpartan(
                                  color: Color(0xff2260FF),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 50,
                              child: Text(
                                "--------------------------------------------------------------",
                                style: TextStyle(color: Color(0xff2260FF)),
                              ),
                            ),
                            Positioned(
                              bottom: 7,
                              left: 50,
                              child: Text(
                                "--------------------------------------------------------------",
                                style: TextStyle(color: Color(0xff2260FF)),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              left: 10,
                              child: Column(
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    "9 AM",
                                    style: GoogleFonts.leagueSpartan(
                                      color: Color(0xff2260FF),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "10 AM",
                                    style: GoogleFonts.leagueSpartan(
                                      color: Color(0xff2260FF),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "11 AM",
                                    style: GoogleFonts.leagueSpartan(
                                      color: Color(0xff2260FF),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "12 AM",
                                    style: GoogleFonts.leagueSpartan(
                                      color: Color(0xff2260FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 50,
                              child: Container(
                                height: 60,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffCAD6FF),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 7,
                                      left: 20,
                                      child: Text(
                                        "Dr. Olivia Turner, M.D.",
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff2260FF),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 28,
                                      left: 20,
                                      child: Text(
                                        "Treatment and prevention of\nskin and photodermatitis.",
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          height: 0.8,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 10,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 13,
                                            width: 13,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/right_icon.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Container(
                                            height: 13,
                                            width: 13,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/wrong_icon.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xffCAD6FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                          "assets/images/user_image.png"),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dr. Olivia Turner,M.D.",
                                    style: GoogleFonts.leagueSpartan(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff2260FF),
                                        height: 1
                                    ),
                                  ),
                                  Text(
                                    "Dermato-Endocrinology",
                                    style: GoogleFonts.leagueSpartan(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              _infoBadge("assets/images/star_svg.svg", "5"),
                              SizedBox(width: 10),
                              _infoBadge("assets/images/message_svg.svg", "60"),
                              // _circleIcon(""),
                              // SizedBox(height: 10),
                              // _circleIcon(AssetImage("assets/images/heart.png"), isBlue: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBadge(String svgPath, String text) {
    return Container(
      width: 70,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 3),
          SvgPicture.asset(
            svgPath,
            height: 16,
            width: 16,
            color: const Color(0xff2260FF),
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Color(0xff2260FF),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(String svgPath, {bool isBlue = false}) {
    return Container(
      height: 25,
      width: 25,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          svgPath,
          height: 14,
          width: 14,
          color: isBlue ? Color(0xff2260FF) : Colors.black,
        ),
      ),
    );
  }
}
