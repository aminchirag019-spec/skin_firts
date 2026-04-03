import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skin_firts/Utilities/colors.dart';
import '../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../Utilities/media_query.dart';

Widget topRow(
  BuildContext context, {
  required VoidCallback onPressed,
  required String text,
  Color? color,
}) {
  return Row(
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Icon(Icons.arrow_back_ios, color: color ?? AppColors.darkPurple),
      ),
      Expanded(
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: AppSize.width(context) * 0.064, // 25
              fontWeight: FontWeight.w600,
              color: color ?? AppColors.darkPurple,
            ),
          ),
        ),
      ),
      SizedBox(width: AppSize.width(context) * 0.077), // 30
    ],
  );
}

Widget customTextField({
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
  String? padding,
  double h = 14,
  double w = 10,
  VoidCallback? onTap,
  String? initialValue,
  String? type,
  TextInputType? textInputType,
  int? maxLength,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType,
    validator: validator,
    maxLength: maxLength,
    initialValue: initialValue,
    obscureText: obscureText,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    style: GoogleFonts.leagueSpartan(fontSize: 20),
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
        color: isBold ? AppColors.darkPurple : Color(0xff809CFF),
        fontSize: size == 20
            ? AppSize.width(context) * 0.06
            : AppSize.width(context) * ((size ?? 20) / 390.0),
        fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
      ),
      filled: true,
      fillColor: Color(0xffECF1FF),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.width(context) * 0.038),
        borderSide: BorderSide.none,
      ),
      suffixIcon: image != null
          ? BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<DoctorScreenBloc>().add(
                      TogglePasswordVisibility(),
                    );
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

Widget loginRow(
  BuildContext context, {
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
            backgroundColor: AppColors.lightPurple,
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

Widget customButton(
  BuildContext context, {
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
  final DateTime date;
  final String day;

  Days({required this.date, required this.day});
}

List<Days> getDynamicAppointmentDates() {
  List<Days> dates = [];
  DateTime now = DateTime.now();
  for (int i = 0; i < 30; i++) {
    DateTime current = now.add(Duration(days: i));
    dates.add(
      Days(date: current, day: DateFormat('EEE').format(current).toUpperCase()),
    );
  }
  return dates;
}

List<Days> appointmentDates = getDynamicAppointmentDates();

Widget homeCircleIcon(
  BuildContext context,
  String svgPath, {
  bool showDot = false,
}) {
  return Container(
    padding: EdgeInsets.all(AppSize.width(context) * 0.012), // 5
    decoration: BoxDecoration(
      color: AppColors.lightPurple,
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
                color: AppColors.darkPurple,
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
        colorFilter: ColorFilter.mode(AppColors.darkPurple, BlendMode.srcIn),
      ),

      SizedBox(height: AppSize.height(context) * 0.007),

      Text(
        text,
        style: GoogleFonts.leagueSpartan(
          fontSize: AppSize.width(context) * 0.030,
          color: AppColors.darkPurple,
        ),
      ),
    ],
  );
}
