import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({
    required this.navigationShell,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 21, right: 21),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: _onTap,
              backgroundColor:  Color(0xff1E63F3),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.white70,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_home2.svg",
                    height: 22,
                    width: 22,
                    color: widget.navigationShell.currentIndex == 0
                        ? const Color(0xff00278C)
                        : Colors.white,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_message.svg",
                    height: 22,
                    width: 22,
                    color: widget.navigationShell.currentIndex == 1
                        ? const Color(0xff00278C)
                        : Colors.white,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_user.svg",
                    height: 22,
                    width: 22,
                    color: widget.navigationShell.currentIndex == 2
                        ? const Color(0xff00278C)
                        : Colors.white,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_calender.svg",
                    height: 22,
                    width: 22,
                    color: widget.navigationShell.currentIndex == 3
                        ? const Color(0xff00278C)
                        : Colors.white,
                  ),
                  label: "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}