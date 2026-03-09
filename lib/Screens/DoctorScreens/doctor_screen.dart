import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Router/router_class.dart';

import '../../Global/dummy_data.dart';
import 'doctor_screen.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            children: [
              doctorsTopRow(
                text: "Doctors",
                onPressed: () => context.go(RouterName.homeScreen.path),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Sort By",
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 1,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 52,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Color(0xff2260FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            "A→Z",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),
                          ),
                        ),
                  ),
                  SizedBox(width:6,),
                  filterOptions(
                      icon: Icons.star_outline,
                    size: 18
                  ),
                  SizedBox(width:6,),
                  filterOptions(
                  icon: Icons.favorite_border,
                    size: 16
                  ),
                  SizedBox(width:6,),
                  filterOptions(
                  icon: Icons.female,
                    size: 18
                  ),
                  SizedBox(width:6,),
                  filterOptions(
                    icon: Icons.male,
                    size: 18
                  ),
                ],
              ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              final item = doctors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                  decoration: BoxDecoration(
                    color:  Color(0xffCAD6FF).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:item.image,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Text(
                                "${item.doctorName},\n${item.qualification}",
                                style:GoogleFonts.leagueSpartan(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff2260FF),
                                    height: 1
                                )
                            ),
                            SizedBox(height: 3),
                            Text(
                                "${item.title}",
                                style:GoogleFonts.leagueSpartan(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                )
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => context.go(RouterName.doctorInfoScreen.path)
                                  ,child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 2),
                                    decoration: BoxDecoration(
                                      color:  Color(0xff1B5FE0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child:  Text(
                                        "Info",
                                        style: GoogleFonts.leagueSpartan(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                servicesOptions(icon: Icons.calendar_month, size: 15),
                                SizedBox(width: 2,),
                                servicesOptions(icon: Icons.calendar_month, size: 15),
                                SizedBox(width: 2,),
                                servicesOptions(icon: Icons.question_mark, size: 15),
                                SizedBox(width: 2,),
                                servicesOptions(icon: Icons.favorite_border_outlined, size: 15),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: 4,),
          )
            ],
          ),
        ),
      ),
    );
  }
}

Widget doctorsTopRow({required String text, required VoidCallback onPressed}) {
  return Row(
    children: [
      Icon(Icons.arrow_back_ios, color: Color(0xff2260FF)),
      SizedBox(width: 5,),
      Expanded(
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color:  Color(0xff2260FF)
            ),
          ),
        ),
      ),
      Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: Color(0xffCAD6FF),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            AssetImage("assets/images/search.png"),
            color: Color(0xff2260FF),
            size: 14,
          ),
        ),
      ),
      SizedBox(width: 5),
      Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: Color(0xffCAD6FF),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ImageIcon(
            AssetImage("assets/images/tune.png"),
            color: Color(0xff2260FF),
            size: 15,
          ),
        ),
      ),
    ],
  );
}

Widget filterOptions ({
 required IconData icon,
required double size,
}) {
  return Container(
    height: 24,
    width: 24,
  decoration: BoxDecoration(
  shape: BoxShape.circle,
  color: Color(0xffCAD6FF),
  ),
  child: Center(
    child: Icon(icon,size: size,color: Color(0xff2260FF),),
  ),
  );
}



Widget servicesOptions ({
  required IconData icon,
  required double size,
}) {
  return Container(
    height: 25,
    width: 24,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
    ),
    child: Center(
      child: Icon(icon,size: size,color: Color(0xff2260FF),),
    ),
  );
}

