import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_firts/router/router_class.dart';
import '../../Global/coustom_widgets.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _AddMethodTile {
  final String title;
  final IconData? icon;
  final String? svgPath;
  final String value;

  _AddMethodTile({required this.title, this.icon, this.svgPath, required this.value});
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = "Add New Card";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(context) * 0.06, // ~24
            vertical: AppSize.height(context) * 0.02, // ~16
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topRow(
                context,
                onPressed: () => context.pop(),
                text: "Payment Method",
              ),
              SizedBox(height: AppSize.height(context) * 0.047), // ~40
              Text(
                "Credit & Debit Card",
                style: GoogleFonts.leagueSpartan(
                  fontSize: AppSize.width(context) * 0.056, // ~22
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.019), // ~16
              _buildPaymentItem(
                title: "Add New Card",
                icon: Icons.credit_card_outlined,
                value: "Add New Card",
              ),
              SizedBox(height: AppSize.height(context) * 0.047), // ~40
              Text(
                "More Payment Option",
                style: GoogleFonts.leagueSpartan(
                  fontSize: AppSize.width(context) * 0.056, // ~22
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: AppSize.height(context) * 0.019), // ~16
              _buildPaymentItem(
                title: "Apple Play",
                icon: Icons.apple,
                value: "Apple Play",
              ),
              SizedBox(height: AppSize.height(context) * 0.019), // ~16
              _buildPaymentItem(
                title: "Paypal",
                icon: Icons.payment_outlined,
                value: "Paypal",
              ),
              SizedBox(height: AppSize.height(context) * 0.019), // ~16
              _buildPaymentItem(
                title: "Google Play",
                svgPath: 'assets/images/goole_svg.svg',
                value: "Google Play",
              ),
              const Spacer(),
              Center(
                child: customButton(
                  context,
                  text: "Next",
                  backgroundColor: AppColors.darkPurple,
                  textColor: AppColors.white,
                  width: double.infinity,
                  onPressed: () {
                    if (_selectedMethod == "Add New Card") {
                      context.push(RouterName.addPaymentMethodScreen.path);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentItem({
    required String title,
    IconData? icon,
    String? svgPath,
    required String value,
  }) {
    bool isSelected = _selectedMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(context) * 0.04, // ~16
          vertical: AppSize.height(context) * 0.019, // ~16
        ),
        decoration: BoxDecoration(
          color: const Color(0xffECF1FF),
          borderRadius: BorderRadius.circular(AppSize.width(context) * 0.05), // ~20
        ),
        child: Row(
          children: [
            if (svgPath != null)
              SvgPicture.asset(
                svgPath,
                height: AppSize.width(context) * 0.077, // ~30
                width: AppSize.width(context) * 0.077, // ~30
                colorFilter: const ColorFilter.mode(Color(0xff809CFF), BlendMode.srcIn),
              )
            else if (icon != null)
              Icon(
                icon,
                color: const Color(0xff809CFF),
                size: AppSize.width(context) * 0.077, // ~30
              ),
            SizedBox(width: AppSize.width(context) * 0.04), // ~16
            Text(
              title,
              style: GoogleFonts.leagueSpartan(
                fontSize: AppSize.width(context) * 0.051, // ~20
                color: const Color(0xff809CFF),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Container(
              height: AppSize.width(context) * 0.061, // ~24
              width: AppSize.width(context) * 0.061, // ~24
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
                        height: AppSize.width(context) * 0.036, // ~14
                        width: AppSize.width(context) * 0.036, // ~14
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
  }
}
