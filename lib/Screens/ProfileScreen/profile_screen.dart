import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Global/enums.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';
import '../../Utilities/shimmer.dart';

/// ================== SHIMMER ==================

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.currentUser == null) {
                return ProfileShimmer();
              }
              final user = state.currentUser!;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(context) * 0.064,
                    vertical: AppSize.height(context) * 0.023,
                  ),
                  child: Column(
                    children: [
                      topRow(
                        context,
                        onPressed: () => context.go(RouterName.homeScreen.path),
                        text: "My Profile",
                      ),

                      SizedBox(height: AppSize.height(context) * 0.011),

                      /// PROFILE IMAGE
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: AppSize.width(context) * 0.153,
                            backgroundImage: const AssetImage(
                              "assets/images/doctor_1.png",
                            ),
                          ),
                          Positioned(
                            right: 3,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () {
                                context.go(RouterName.editUserScreen.path);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff2260FF),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSize.height(context) * 0.005),

                      /// USER NAME
                      Text(
                        user.name ?? "",
                        style: GoogleFonts.leagueSpartan(
                          fontSize: AppSize.width(context) * 0.064,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: AppSize.height(context) * 0.011),

                      /// OPTIONS
                      ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/user_icon.png"),
                        title: "Profile",
                        onTap: () {},
                      ),

                      _space(context),

                      ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/heart_outlined.png",
                        ),
                        title: "Favourite",
                        onTap: () {},
                      ),

                      _space(context),

                      ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/wallet_icon.png",
                        ),
                        title: "Payment Method",
                        onTap: () {},
                      ),

                      _space(context),

                      ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/lock_icon.png"),
                        title: "Privacy Policy",
                        onTap: () {
                          context.go(RouterName.privacyPolicyScreen.path);
                        },
                      ),

                      _space(context),

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

                      _space(context),

                      ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/img.png"),
                        title: "Chat List",
                        onTap: () {
                          context.push(RouterName.chatListScreen.path);
                        },
                      ),

                      _space(context),

                      ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/question_icon.png",
                        ),
                        title: "Help",
                        onTap: () {
                          context.go(RouterName.helpCentreScreen.path);
                        },
                      ),

                      _space(context),

                      /// LOGOUT
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
                              onShowBottomSheet(context);
                            },
                          );
                        },
                      ),

                      _space(context),

                      ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/plus_icon.png"),
                        title: "Add Doctor",
                        onTap: () {
                          context.go(RouterName.addDoctorScreen.path);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// ================== COMMON WIDGET ==================
Widget ProfileOptionTile(
  BuildContext context, {
  required ImageProvider image,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        CircleAvatar(
          radius: AppSize.width(context) * 0.051,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: ImageIcon(image, color: const Color(0xff2260FF)),
        ),
        SizedBox(width: AppSize.width(context) * 0.035),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSize.width(context) * 0.041,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: AppSize.width(context) * 0.041,
          color: AppColors.grey,
        ),
      ],
    ),
  );
}

/// spacing helper
SizedBox _space(BuildContext context) =>
    SizedBox(height: AppSize.height(context) * 0.017);

void onShowBottomSheet(BuildContext context) {
  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(context) * 0.064,
          vertical: AppSize.height(context) * 0.023,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Logout",
                  style: GoogleFonts.leagueSpartan(
                    color: AppColors.darkPurple,
                    fontSize: AppSize.width(context) * 0.064,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.height(context) * 0.020),
            Text(
              "are you sure you want to log out?",
              style: GoogleFonts.leagueSpartan(
                color: AppColors.black,
                fontSize: AppSize.width(context) * 0.041,
              ),
            ),
            SizedBox(height: AppSize.height(context) * 0.035  ),
            Row(
              children: [
                customButton(
                  context,
                  text: "Cancel",
                  backgroundColor: AppColors.lightPurple,
                  textColor: AppColors.darkPurple,
                  width: 130,
                  onPressed: () {
                    context.pop();
                  },
                ),
                SizedBox(width: AppSize.width(context) * 0.035,),
                customButton(context, text: "Yes, Logout",
                    backgroundColor: AppColors.darkPurple,
                    width: 170,
                    textColor: AppColors.white, onPressed:
                () {
                  context.read<AuthBloc>().add(LogoutEvent());
                }),
              ],
            ),
            SizedBox(height: AppSize.height(context) * 0.040,)
          ],
        ),
      );
    },
  );
}
