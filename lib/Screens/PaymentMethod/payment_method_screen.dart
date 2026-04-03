import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_bloc.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_state.dart';
import 'package:skin_firts/router/router_class.dart';
import '../../Global/custom_widgets.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(context) * 0.06,
            vertical: AppSize.height(context) * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topRow(
                context,
                onPressed: () => context.pop(),
                text: "Payment Method",
              ),
              SizedBox(height: AppSize.height(context) * 0.047),
              Text(
                "Credit & Debit Card",
                style: GoogleFonts.leagueSpartan(
                  fontSize: AppSize.width(context) * 0.056,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.019),
              _buildPaymentItem(
                context,
                title: "Add New Card",
                icon: Icons.credit_card_outlined,
                value: "Add New Card",
              ),
              SizedBox(height: AppSize.height(context) * 0.047),
              Text(
                "More Payment Option",
                style: GoogleFonts.leagueSpartan(
                  fontSize: AppSize.width(context) * 0.056,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.019),
              _buildPaymentItem(
                context,
                title: "Apple Play",
                icon: Icons.apple,
                value: "Apple Play",
              ),
              SizedBox(height: AppSize.height(context) * 0.019),
              _buildPaymentItem(
                context,
                title: "Paypal",
                icon: Icons.payment_outlined,
                value: "Paypal",
              ),
              SizedBox(height: AppSize.height(context) * 0.019),
              _buildPaymentItem(
                context,
                title: "Google Play",
                svgPath: 'assets/images/goole_svg.svg',
                value: "Google Play",
              ),
              const Spacer(),
              Center(
                child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                  buildWhen: (previous, current) => previous.selectedPaymentMethod != current.selectedPaymentMethod,
                  builder: (context, state) {
                    return customButton(
                      context,
                      text: "Next",
                      backgroundColor: AppColors.darkPurple,
                      textColor: AppColors.white,
                      width: double.infinity,
                      onPressed: () {
                        if (state.selectedPaymentMethod == "Add New Card") {
                          context.push(RouterName.addPaymentMethodScreen.path);
                        }
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentItem(
    BuildContext context, {
    required String title,
    IconData? icon,
    String? svgPath,
    required String value,
  }) {
    return BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
      buildWhen: (previous, current) => previous.selectedPaymentMethod != current.selectedPaymentMethod,
      builder: (context, state) {
        bool isSelected = state.selectedPaymentMethod == value;
        return GestureDetector(
          onTap: () {
            context.read<DoctorScreenBloc>().add(SelectPaymentMethodEvent(value));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.04,
              vertical: AppSize.height(context) * 0.019,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffECF1FF),
              borderRadius: BorderRadius.circular(AppSize.width(context) * 0.05),
            ),
            child: Row(
              children: [
                if (svgPath != null)
                  SvgPicture.asset(
                    svgPath,
                    height: AppSize.width(context) * 0.077,
                    width: AppSize.width(context) * 0.077,
                    colorFilter: const ColorFilter.mode(Color(0xff809CFF), BlendMode.srcIn),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: const Color(0xff809CFF),
                    size: AppSize.width(context) * 0.077,
                  ),
                SizedBox(width: AppSize.width(context) * 0.04),
                Text(
                  title,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: AppSize.width(context) * 0.051,
                    color: const Color(0xff809CFF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Container(
                  height: AppSize.width(context) * 0.061,
                  width: AppSize.width(context) * 0.061,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkPurple,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            height: AppSize.width(context) * 0.036,
                            width: AppSize.width(context) * 0.036,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.darkPurple,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
