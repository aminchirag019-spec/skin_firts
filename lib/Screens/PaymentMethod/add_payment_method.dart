import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.paymentMethodScreen.path);
        return false;
      },
      child: Scaffold(
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
                  onPressed: () => context.go(RouterName.paymentMethodScreen.path),
                  text: "Add Card",
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSize.height(context) * 0.04),
                        _buildCreditCardPreview(),
                        SizedBox(height: AppSize.height(context) * 0.04),
                        _buildLabel("Card Holder Name"),
                        SizedBox(height: AppSize.height(context) * 0.01),
                        coustomTextField(
                          context: context,
                          hintText: "John Doe",
                          controller: _cardHolderController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.02),
                        _buildLabel("Card Number"),
                        SizedBox(height: AppSize.height(context) * 0.01),
                        coustomTextField(
                          context: context,
                          hintText: "000 000 000 00",
                          controller: _cardNumberController,
                          textInputType: TextInputType.number,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("Expiry Date"),
                                  SizedBox(height: AppSize.height(context) * 0.01),
                                  coustomTextField(
                                    context: context,
                                    hintText: "04/28",
                                    controller: _expiryDateController,
                                    textInputType: TextInputType.datetime,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSize.width(context) * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("CVV"),
                                  SizedBox(height: AppSize.height(context) * 0.01),
                                  coustomTextField(
                                    context: context,
                                    hintText: "0000",
                                    controller: _cvvController,
                                    textInputType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSize.height(context) * 0.02),
                customButton(
                  context,
                  text: "Save Card",
                  backgroundColor: AppColors.darkPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    context.pop();
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.leagueSpartan(
        fontSize: AppSize.width(context) * 0.051, // ~20
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCreditCardPreview() {
    return Container(
      width: double.infinity,
      height: AppSize.height(context) * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF648DFF), Color(0xFF2260FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 50,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Spacer(),
          Text(
            "000 000 000 00",
            style: GoogleFonts.leagueSpartan(
              color: Colors.white,
              fontSize: AppSize.width(context) * 0.06,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card Holder Name",
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "John Doe",
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Expiry Date",
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "04/28",
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.grid_view_rounded, color: Colors.white70),
              )
            ],
          )
        ],
      ),
    );
  }
}
