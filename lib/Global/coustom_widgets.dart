import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';

import '../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../router/router_class.dart';

import '../Utilities/media_query.dart';

Widget topRow(BuildContext context, {
  required VoidCallback onPressed,
  required String text,
}) {
  return Row(
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Icon(Icons.arrow_back_ios, color: Color(0xff2260FF)),
      ),
      Expanded(
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: AppSize.width(context) * 0.064, // 25
              fontWeight: FontWeight.w600,
              color: Color(0xff2260FF),
            ),
          ),
        ),
      ),
      SizedBox(width: AppSize.width(context) * 0.077), // 30
    ],
  );
}

Widget coustomTextField({
  required BuildContext context,
  required String hintText,
  ImageProvider? image,
  double? size = 20,
  FormFieldValidator<String>? validator,
  String? obscuring,
  TextEditingController? controller,
  TextAlignVertical? alignment,
  bool isBold = false,
  bool obscureText = false,
  String? SvgPath,
  String? padding,
  double h = 14,
  double w = 10,
  VoidCallback? onTap,
  String? initialValue,
  String ? type,
  TextInputType ? textInputType,
  int ? maxLength
}) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType,
    validator: validator,
    maxLength: maxLength,
    initialValue: initialValue,
    obscureText: obscureText,
    onTap: onTap,
    decoration: InputDecoration(
      isCollapsed: true,
      alignLabelWithHint: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: h == 14
            ? AppSize.width(context) * 0.036
            : AppSize.width(context) * (h / 390.0),
        vertical: w == 10
            ? AppSize.height(context) * 0.012
            : AppSize.height(context) * (w / 844.0),
      ),
      hintText: hintText ?? "******",
      hintStyle: GoogleFonts.leagueSpartan(
        color: isBold ? Color(0xff2260FF) : Color(0xff809CFF),
        fontSize: size == 20
            ? AppSize.width(context) * 0.058
            : AppSize.width(context) * ((size ?? 20) / 390.0),
        fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
      ),
      filled: true,
      fillColor: Color(0xffECF1FF),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSize.width(context) * 0.038,
        ),
        borderSide: BorderSide.none,
      ),
      suffixIcon: image != null
          ? BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
        builder: (context, state) {
          return IconButton(
            onPressed: () {
              context
                  .read<DoctorScreenBloc>()
                  .add(TogglePasswordVisibility());
              },

            icon: Icon(
              state.isPasswordHidden
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
          );
        },
      )
          : null,
    ),
  );
}

class LoginRow {
  final String svgPath;
  final VoidCallback? onTap;
  final double? radius;
  final double? iconSize;

  LoginRow({required this.svgPath, this.onTap, this.radius, this.iconSize});
}

Widget loginRow(BuildContext context, {
  required List<LoginRow> icons,
  double defaultRadius = 25,
  double defaultIconSize = 30,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: icons.map((icon) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: icon.onTap,
          child: CircleAvatar(
            backgroundColor: const Color(0xffCAD6FF),
            radius: icon.radius == null
                ? AppSize.width(context) * (defaultRadius / 390.0)
                : AppSize.width(context) * (icon.radius! / 390.0),
            child: SvgPicture.asset(
              icon.svgPath,
              height: icon.iconSize == null
                  ? AppSize.width(context) * (defaultIconSize / 390.0)
                  : AppSize.width(context) * (icon.iconSize! / 390.0),
              width: icon.iconSize == null
                  ? AppSize.width(context) * (defaultIconSize / 390.0)
                  : AppSize.width(context) * (icon.iconSize! / 390.0),
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

Widget customButton(BuildContext context, {
  required String text,
  required Color backgroundColor,
  required Color textColor,
  required VoidCallback? onPressed,
  double? width,
  double? fontSize,
}) {
  return SizedBox(
    width: width,
    height: AppSize.height(context) * 0.059, // 50
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      child: Text(
        text,
        style: GoogleFonts.leagueSpartan(
          color: textColor,
          fontSize: fontSize == null
              ? AppSize.width(context) * 0.064
              : AppSize.width(context) * (fontSize / 390.0), // 25
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class Days {
  final int date;
  final String day;

  Days({required this.date, required this.day});
}

List<Days> appointmentDates = [
  Days(date: 6, day: "THU"),
  Days(date: 7, day: "FRI"),
  Days(date: 8, day: "SAT"),
  Days(date: 9, day: "SUN"),
  Days(date: 10, day: "MON"),
  Days(date: 11, day: "TUE"),
  Days(date: 12, day: "WED"),
  Days(date: 13, day: "THU"),
  Days(date: 14, day: "FRI"),
  Days(date: 15, day: "SAT"),
  Days(date: 16, day: "SUN"),
  Days(date: 17, day: "MON"),
  Days(date: 18, day: "TUE"),
  Days(date: 19, day: "WED"),
  Days(date: 20, day: "THU"),
  Days(date: 21, day: "FRI"),
  Days(date: 22, day: "SAT"),
  Days(date: 23, day: "SUN"),
  Days(date: 24, day: "MON"),
  Days(date: 25, day: "TUE"),
  Days(date: 26, day: "WED"),
  Days(date: 27, day: "THU"),
  Days(date: 28, day: "FRI"),
  Days(date: 29, day: "SAT"),
  Days(date: 30, day: "SUN"),

  /// next month
  Days(date: 1, day: "MON"),
  Days(date: 2, day: "TUE"),
  Days(date: 3, day: "WED"),
  Days(date: 4, day: "THU"),
  Days(date: 5, day: "FRI"),
  Days(date: 6, day: "SAT"),
];

Widget homeCircleIcon(BuildContext context,
    String svgPath, {
      bool showDot = false,
    }) {
  return Container(
    padding: EdgeInsets.all(AppSize.width(context) * 0.012), // 5
    decoration: const BoxDecoration(
      color: Color(0xffCAD6FF),
      shape: BoxShape.circle,
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          svgPath,
          height: AppSize.width(context) * 0.051, // 20
          width: AppSize.width(context) * 0.051, // 20
        ),

        if (showDot)
          Positioned(
            top: AppSize.height(context) * 0.001, // 1
            right: AppSize.width(context) * 0.002, // 1
            child: Container(
              height: AppSize.height(context) * 0.007, // 6
              width: AppSize.width(context) * 0.015, // 6
              decoration: BoxDecoration(
                color: Color(0xff2260FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    ),
  );
}

Widget menuItem(String svgPath, String text, BuildContext context) {
  return Column(
    children: [
      SizedBox(height: AppSize.height(context) * 0.009),

      SvgPicture.asset(
        svgPath,
        height: AppSize.height(context) * 0.020,
        width: AppSize.width(context) * 0.038,
        colorFilter: const ColorFilter.mode(Color(0xff2260FF), BlendMode.srcIn),
      ),

      SizedBox(height: AppSize.height(context) * 0.007),

      Text(
        text,
        style: GoogleFonts.leagueSpartan(
          fontSize: AppSize.width(context) * 0.030,
          color: const Color(0xff2260FF),
        ),
      ),
    ],
  );
}
