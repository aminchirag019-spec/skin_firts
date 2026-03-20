import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Global/dummy_data.dart';
import '../../Global/enums.dart';

import '../../Utilities/media_query.dart';

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
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(context) * 0.064, // 25
                vertical: AppSize.height(context) * 0.023, // 20
              ),
              child: Column(
                children: [
                  topRow(
                    context,
                    onPressed: () => context.go(RouterName.homeScreen.path),
                    text: "My Profile",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: CircleAvatar(
                          radius: AppSize.width(context) * 0.153, // 60
                          backgroundImage: const AssetImage(
                            "assets/images/doctor_1.png",
                          ),
                        ),
                      ),
                      Positioned(
                        right: AppSize.width(context) * 0.007, // 3
                        bottom: AppSize.height(context) * 0.009, // 8
                        child: Container(
                          height: AppSize.width(context) * 0.076, // 30
                          width: AppSize.width(context) * 0.076, // 30
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff2260FF),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context.go(RouterName.editUserScreen.path);
                            },
                            child: Image(
                              image: AssetImage("assets/images/pen.png"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.005), // 5
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if(state.currentUser!.name.isEmpty){
                        Text("hii");
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.currentUser!.name,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: AppSize.width(context) * 0.064, // 25
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  ProfileOptionTile(
                    context,
                    image: const AssetImage("assets/images/user_icon.png"),
                    title: "Profile",
                    onTap: () {},
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  ProfileOptionTile(
                    context,
                    image: const AssetImage("assets/images/heart_outlined.png"),
                    title: "Favourite",
                    onTap: () {},
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  ProfileOptionTile(
                    context,
                    image: const AssetImage("assets/images/wallet_icon.png"),
                    title: "Payment Method",
                    onTap: () {},
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  ProfileOptionTile(
                    context,
                    image: const AssetImage("assets/images/lock_icon.png"),
                    title: "Privacy Policy",
                    onTap: () {},
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  ProfileOptionTile(
                    context,
                    image: const AssetImage(
                      "assets/images/profile_setting.png",
                    ),
                    title: "Setting",
                    onTap: () {
                      context.go(RouterName.settingScreen.path);
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  ProfileOptionTile(
                    context,
                    image: const AssetImage(
                      "assets/images/chat_img.png",
                    ),
                    title: "Chat List",
                    onTap: () {
                      context.push(RouterName.chatListScreen.path);
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  ProfileOptionTile(
                    context,
                    image: const AssetImage("assets/images/question_icon.png"),
                    title: "Help",
                    onTap: () {},
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.loginStatus == LoginStatus.logout) {
                        context.go(RouterName.welcomeScreen.path);
                      }
                    },
                    builder: (context, state) {
                      return ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/logout_icon.png",
                        ),
                        title: "Logout",
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                        },
                      );
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.017), // 15
                  ProfileOptionTile(
                    context,
                    image: AssetImage("assets/images/plus_icon.png"),
                    title: "Add Doctor",
                    onTap: () {
                      context.go(RouterName.addDoctorScreen.path);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget ProfileOptionTile(
  BuildContext context, {
  required ImageProvider image,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.width(context) * 0.030),
      ), // 12
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSize.width(context) * 0.051, // 20
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: ImageIcon(
              image,
              color: const Color(0xff2260FF),
              size: AppSize.width(context) * 0.051,
            ), // 20
          ),

          SizedBox(width: AppSize.width(context) * 0.035), // 14

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppSize.width(context) * 0.041,
                fontWeight: FontWeight.w500,
              ), // 16
            ),
          ),

          Icon(
            Icons.arrow_forward_ios,
            size: AppSize.width(context) * 0.041,
            color: Colors.grey,
          ), // 16
        ],
      ),
    ),
  );
}

Widget settingOptionTile(
  BuildContext context, {
  required ImageProvider image,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(image: DecorationImage(image: image)),
        ),
        SizedBox(width: AppSize.width(context) * 0.037), // 14
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSize.width(context) * 0.046,
              fontWeight: FontWeight.w500,
            ), // 16
          ),
        ),

        Icon(
          Icons.arrow_forward_ios,
          size: AppSize.width(context) * 0.05,
          color: Color(0xff2260FF),
        ), // 16
      ],
    ),
  );
}
