import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Router/router_class.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go(RouterName.homeScreen.path);
        break;
      case 1:
        context.go(RouterName.homeScreen.path);
        break;
      case 2:
        context.go(RouterName.homeScreen.path);
        break;
      case 3:
        context.go(RouterName.homeScreen.path);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 21, right: 21),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: const Color(0xff1E63F3),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: const Color(0xff00278C),
          unselectedItemColor: Colors.white70,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/bottom_home.svg",
                height: 22,
                width: 22,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/bottom_message.svg",
                height: 22,
                width: 22,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/bottom_user.svg",
                height: 22,
                width: 22,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/bottom_calender.svg",
                height: 22,
                width: 22,
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}