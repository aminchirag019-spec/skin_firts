import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Screens/ProfileScreen/profile_screen.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Utilities/colors.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  async{
        context.go(RouterName.profileScreen.path);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.054, // 25
              vertical: AppSize.height(context) * 0.023,  // 20
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:6),
                  child: topRow(
                    context,
                    onPressed: () => context.go(RouterName.profileScreen.path),
                    text: "Setting",
                  ),
                ),
                SizedBox(height: AppSize.height(context) * 0.04),
                settingOptionTile(context, image:  AssetImage("assets/images/notification.png"),title: "Notification Setting", onTap: () {
                  context.go(RouterName.notificationSetting.path);
                },),
                SizedBox(height: AppSize.height(context) * 0.029),
                settingOptionTile(context, image:  AssetImage("assets/images/key.png"), title: "Password Manager", onTap: () {
                  context.go(RouterName.passwordManagerScreen.path);
                },),
                SizedBox(height: AppSize.height(context) * 0.029),
                settingOptionTile(context, image:  AssetImage("assets/images/user_icon.png"), title: "Delete Account", onTap: () {},)
              ],
            ),
          ),
        ),
      ),
    );
  }
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
            color: AppColors.darkPurple
        ), // 16
      ],
    ),
  );
}

