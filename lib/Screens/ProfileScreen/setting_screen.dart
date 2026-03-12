import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Screens/ProfileScreen/profile_screen.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Router/router_class.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
          child: Column(
            children: [
              topRow(
                context,
                onPressed: () => context.go(RouterName.profileScreen.path),
                text: "Setting",
              ),
              SizedBox(height: 10,),
              ProfileOptionTile(image: AssetImage("assets/images/user_icon.png"),title: "Notification Setting", onTap: () {},),
              SizedBox(height: 10),
              ProfileOptionTile(image: AssetImage("assets/images/lock_icon.png"), title: "Password Manager", onTap: () {},),
              SizedBox(height: 10),
              ProfileOptionTile(image: AssetImage("assets/images/lock_icon.png"), title: "Delete Account", onTap: () {},)
            ],
          ),
        ),
      ),
    );
  }
}
