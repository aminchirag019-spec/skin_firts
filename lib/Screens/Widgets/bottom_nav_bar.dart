import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';

class BottomNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({required this.navigationShell});

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
          padding: EdgeInsets.only(
            bottom: AppSize.height(context) * 0.017, // 15
            left: AppSize.width(context) * 0.053, // 21
            right: AppSize.width(context) * 0.053, // 21
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppSize.width(context) * 0.076,
            ), // 30
            child: BottomNavigationBar(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: _onTap,
              backgroundColor: AppColors.darkPurple,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.white70,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_home2.svg",
                    height: AppSize.width(context) * 0.056, // 22
                    width: AppSize.width(context) * 0.056, // 22
                    color: widget.navigationShell.currentIndex == 0
                        ? AppColors.selectedColor
                        : AppColors.white,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_message.svg",
                    height: AppSize.width(context) * 0.056, // 22
                    width: AppSize.width(context) * 0.056, // 22
                    color: widget.navigationShell.currentIndex == 1
                        ? AppColors.selectedColor
                        : AppColors.white,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_user.svg",
                    height: AppSize.width(context) * 0.056, // 22
                    width: AppSize.width(context) * 0.056, // 22
                    color: widget.navigationShell.currentIndex == 2
                        ? AppColors.selectedColor
                        : AppColors.white,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/bottom_calender.svg",
                    height: AppSize.width(context) * 0.056, // 22
                    width: AppSize.width(context) * 0.056, // 22
                    color: widget.navigationShell.currentIndex == 3
                        ? AppColors.selectedColor
                        : AppColors.white,
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
