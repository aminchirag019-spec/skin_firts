import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Global/enums.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.homeScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  topRow(
                    context,
                    onPressed: () => context.go(RouterName.homeScreen.path),
                    text: "My Profile",
                  ),
                  SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            "assets/images/doctor_1.png",
                          ),
                        ),
                      ),
                      Positioned(
                        right: 3,
                        bottom: 8,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff2260FF),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/pen.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "John Doe",
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ProfileOptionTile(
                    image: AssetImage("assets/images/user_icon.png"),
                    title: "Profile",
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileOptionTile(
                    image: AssetImage("assets/images/heart_outlined.png"),
                    title: "Favourite",
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileOptionTile(
                    image: AssetImage("assets/images/wallet_icon.png"),
                    title: "Payment Method",
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileOptionTile(
                    image: AssetImage("assets/images/lock_icon.png"),
                    title: "Privacy Policy",
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileOptionTile(
                    image: AssetImage("assets/images/profile_setting.png"),
                    title: "Setting",
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileOptionTile(
                    image: AssetImage("assets/images/question_icon.png"),
                    title: "Help",
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if(state.loginStatus == LoginStatus.logout) {
                        context.go(RouterName.welcomeScreen.path);
                      }
                    },
                    builder: (context, state) {
                      return ProfileOptionTile(
                        image: AssetImage("assets/images/logout_icon.png"),
                        title: "Logout",
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  ProfileOptionTile(image: AssetImage("assets/images/plus_icon.png"), title: "Add Doctor", onTap: () {
                    context.go(RouterName.addDoctorScreen.path);
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget ProfileOptionTile({
  required ImageProvider image,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: ImageIcon(image, color: Color(0xff2260FF), size: 20),
          ),

          SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    ),
  );
}
