import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Screens/ProfileScreen/profile_screen.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(context) * 0.064, // 25
            vertical: AppSize.height(context) * 0.023,  // 20
          ),
          child: Column(
            children: [
              topRow(
                context,
                onPressed: () => context.go(RouterName.profileScreen.path),
                text: "Setting",
              ),
              SizedBox(height: AppSize.height(context) * 0.011), // 10
              ProfileOptionTile(context, image: const AssetImage("assets/images/user_icon.png"),title: "Notification Setting", onTap: () {},),
              SizedBox(height: AppSize.height(context) * 0.011), // 10
              ProfileOptionTile(context, image: const AssetImage("assets/images/lock_icon.png"), title: "Password Manager", onTap: () {},),
              SizedBox(height: AppSize.height(context) * 0.011), // 10
              ProfileOptionTile(context, image: const AssetImage("assets/images/lock_icon.png"), title: "Delete Account", onTap: () {},)
            ],
          ),
        ),
      ),
    );
  }
}
