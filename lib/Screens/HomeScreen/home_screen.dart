  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:go_router/go_router.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:skin_firts/Router/router_class.dart';

  import '../../global/coustom_widgets.dart';
  import '../widgets/bottom_nav_bar.dart';

  class HomeScreen extends StatefulWidget {
    HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }

  final ValueNotifier<List<bool>> favList =
  ValueNotifier(List.generate(5, (index) => false));

  class _HomeScreenState extends State<HomeScreen> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xffF5F7FB),
        bottomNavigationBar: BottomNavBar(),
        body: SafeArea(
          bottom: false,
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
                                fontSize: 14,
                                color: Color(0xff2260FF),
                                fontWeight: FontWeight.w300,
                                height: 1,
                              ),
                            ),
                            Text(
                              "John Doe",
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      circleIcon(
                        "assets/images/notification_icon.svg",
                        showDot: true,
                      ),
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
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.doctorScreen.path);
                        },
                        child: menuItem(
                          "assets/images/doctor_image.svg",
                          "Doctors",
                        ),
                      ),
                      SizedBox(width: 10),
                      menuItem("assets/images/heart_image.svg", "Favorite"),
                      SizedBox(width: 15),
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: SizedBox(
                                width: 40,
                                child: Row(
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
                                  ],
                                ),
                              ),
                              suffixIcon: Padding(
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
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              filled: true,
                              fillColor: Color(0xffCAD6FF).withOpacity(0.6),
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffCAD6FF).withOpacity(0.6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 13),
                                child: SizedBox(
                                  height: 70,
                                  child: ListView.builder(
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
                                        left: 55,
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
                                                      height: 15,
                                                      width: 15,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            "assets/images/right_icon.png",),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Container(
                                                      height: 15,
                                                      width: 15,
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
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xffCAD6FF).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 34,
                                      backgroundImage: AssetImage(
                                        "assets/images/user_image.png",
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 300,
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 5,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Dr. Olivia Turner,M.D.",
                                                    style: GoogleFonts.leagueSpartan(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xff2260FF),
                                                      height: 1,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Dermato-Endocrinology",
                                                    style: GoogleFonts.leagueSpartan(
                                                      fontSize: 13,
                                                      color: Colors.black87,
                                                      height: 0.9,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              infoBadge(
                                                "assets/images/star_svg.svg",
                                                "5",
                                              ),
                                              SizedBox(width: 10),
                                              infoBadge(
                                                "assets/images/meesage_svg.svg",
                                                "60",
                                              ),
                                              Spacer(),
                                              _circleIcon(
                                                Icons.question_mark,
                                                isBlue: true,
                                              ),
                                              SizedBox(width: 5),
                                              ValueListenableBuilder<List<bool>>(
                                                valueListenable: favList,
                                                builder: (context, value, child) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      value[index] = !value[index];
                                                      favList.value = List.from(value);
                                                    },
                                                    child: _circleIcon(
                                                      value[index] ? Icons.favorite : Icons.favorite_border,
                                                      isBlue: true,
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: 5,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget _circleIcon(IconData icon, {bool isBlue = false}) {
      return Container(
        height: 22,
        width: 22,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, size: 15, color: const Color(0xff2260FF)),
        ),
      );
    }
  }

  Widget infoBadge(String svgPath, String text, {double width = 50}) {
    return Container(
      width: width,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 5),
          SvgPicture.asset(
            svgPath,
            height: 16,
            width: 16,
            color: const Color(0xff2260FF),
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Color(0xff2260FF),
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
