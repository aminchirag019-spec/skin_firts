import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../router/router_class.dart';

Widget topRow(
  BuildContext context, {
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
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color(0xff2260FF),
            ),
          ),
        ),
      ),
      SizedBox(width: 30),
    ],
  );
}

Widget coustomTextField({
  required String hintText,
  ImageProvider? image,
  double? size = 20,
  FormFieldValidator<String>? validator,
  String? obscuring,
  TextEditingController? controller,
  TextAlignVertical? alignment,
  bool isBold = false,
  bool obscureText = false,
  String ? SvgPath,
  String ? padding,
  double  h =14,
  double w = 10,
  VoidCallback ? onTap,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    onTap: onTap,
    decoration: InputDecoration(
      isCollapsed: true,
      alignLabelWithHint: true,

      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: h , vertical: w),
      hintText: hintText ?? "******",
      hintStyle: GoogleFonts.leagueSpartan(
        color: isBold ? Color(0xff2260FF) : Color(0xff809CFF),
        fontSize: size ?? 20,
        fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
      ),
      filled: true,
      fillColor: Color(0xffECF1FF),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      suffixIcon: image != null ? ImageIcon(image,size: 10,) : null
    ),
  );
}
class LoginRow {
  final String svgPath;
  final VoidCallback? onTap;
  final double? radius;
  final double? iconSize;
  LoginRow({
    required this.svgPath,
    this.onTap,
    this.radius,
    this.iconSize,
  });
}
Widget loginRow({
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
            radius: icon.radius ?? defaultRadius,
            child: SvgPicture.asset(
              icon.svgPath,
              height: icon.iconSize ?? defaultIconSize,
              width: icon.iconSize ?? defaultIconSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }).toList(),
  );
}Widget customButton({
  required String text,
  required Color backgroundColor,
  required Color textColor,
  required VoidCallback? onPressed,
  double? width,
  double ? fontSize,
}) {
  return SizedBox(
    width: width,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      child: Text(
        text,
        style: GoogleFonts.leagueSpartan(
          color: textColor,
          fontSize: fontSize ?? 25,
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
Widget circleIcon(String svgPath, {bool showDot = false}) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: const BoxDecoration(
      color: Color(0xffCAD6FF),
      shape: BoxShape.circle,
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          svgPath,
          height: 20,
          width: 20,
        ),

        if (showDot)
          Positioned(
            top: 1,
            right: 1,
            child: Container(
              height: 6,
              width: 6,
              decoration:  BoxDecoration(
                color: Color(0xff2260FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    ),
  );
}

Widget menuItem(String svgPath, String text) {
  return Column(
    children: [
      SizedBox(height: 8,),
      SvgPicture.asset(
        svgPath,
        height: 17,
        width: 15,
        colorFilter:  ColorFilter.mode(
          Color(0xff2260FF),
          BlendMode.srcIn,
        ),
      ),
      SizedBox(height: 6),
      Text(
        text,
        style: GoogleFonts.leagueSpartan(
          fontSize: 12,
          color:  Color(0xff2260FF),
        ),
      ),
    ],
  );
}

