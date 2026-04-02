import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Utilities/colors.dart';

import '../../Helper/app_localizations.dart';
import '../../Utilities/media_query.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final List<String> items = [
      localization?.translate('loreum') ?? "Ut lacinia justo sit amet lorem sodales accumsan. Proin malesuada eleifend fermentum. Donec condimentum, nunc at rhoncus faucibus, ex nisi laoreet ipsum, eu pharetra eros est vitae orci. Morbi quis rhoncus mi. Nullam lacinia ornare accumsan. Duis laoreet, ex eget rutrum pharetra, lectus nisl posuere risus, vel facilisis nisl tellus ac turpis.",
      localization?.translate('loreum') ?? "Ut lacinia justo sit amet lorem sodales accumsan. Proin malesuada eleifend fermentum. Donec condimentum, nunc at rhoncus faucibus, ex nisi laoreet ipsum, eu pharetra eros est vitae orci. Morbi quis rhoncus mi. Nullam lacinia ornare accumsan. Duis laoreet, ex eget rutrum pharetra, lectus nisl posuere risus, vel facilisis nisl tellus.",
      localization?.translate('loreum') ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.",
      localization?.translate('loreum') ?? "Nunc auctor tortor in dolor luctus, quis euismod urna tincidunt. Aenean arcu metus, bibendum at rhoncus at, volutpat ut lacus. Morbi pellentesque malesuada eros semper ultrices. Vestibulum lobortis enim vel neque auctor, a ultrices ex placerat. Mauris ut lacinia justo, sed suscipit tortor. Nam egestas nulla posuere neque.",
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.height(context) * 0.023,
            horizontal: AppSize.width(context) * 0.064, // 15
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                topRow(
                  context,
                  onPressed: () => context.go(RouterName.profileScreen.path),
                  text: localization?.translate('privacy') ?? "Privacy Policy",
                ),
                SizedBox(height: AppSize.height(context) * 0.026),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.leagueSpartan(
                          color: const Color(0xffA9BCFE),
                          fontSize: AppSize.width(context) * 0.047,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(text: "${localization?.translate('lastUpdate') ?? "Last Update"}:"),
                          TextSpan(text: " ${localization?.formatNumber("14/08/2024") ?? "14/08/2024"}"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.height(context) * 0.018),
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.leagueSpartan(
                          color: AppColors.black,
                          fontSize: AppSize.width(context) * 0.05,
                          fontWeight: FontWeight.w200,
                        ),
                        children: [
                          TextSpan(
                            text: localization?.translate('loreum') ??
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem,"
                                " vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam. "
                                "Fusce a scelerisque neque, sed accumsan metus.\n\n"
                                "Nunc auctor tortor in dolor luctus, quis euismod urna tincidunt."
                                " Aenean arcu metus, bibendum at rhoncus at, volutpat ut lacus."
                                " Morbi pellentesque malesuada eros semper ultrices."
                                " Vestibulum lobortis enim vel neque auctor, a ultrices ex placerat."
                                " Mauris ut lacinia justo, sed suscipit tortor. Nam egestas nulla posuere neque tincidunt porta.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.height(context) * 0.028),
                Row(
                  children: [
                    Text(
                      localization?.translate('termsConditions') ?? "Terms & Conditions",
                      style: GoogleFonts.leagueSpartan(
                        color: AppColors.darkPurple,
                        fontSize: AppSize.width(context) * 0.067,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.height(context) * 0.005),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${localization?.formatNumber((index + 1).toString()) ?? (index + 1)}.",
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              height: 1
                            ),
                          ),
                           const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              items[index],
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 14,
                                letterSpacing: -0.5 ,
                                height: 1,
                                fontWeight: FontWeight.w200
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
