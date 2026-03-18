import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_event.dart';
import 'package:skin_firts/Data/dotor_model.dart';

import '../../Bloc/NotificationBloc/notification_bloc.dart';
import '../../Bloc/NotificationBloc/notification_state.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetNotificationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(context) * 0.064, // 25
            vertical: AppSize.height(context) * 0.023, //
          ),
          child: Column(
            children: [
              topRow(
                context,
                onPressed: () => context.go(RouterName.homeScreen.path),
                text: "Notification",
              ),
              SizedBox(height: AppSize.height(context) * 0.023), // 10
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customDayContainers(text: "Today", context),
                  Text(
                    "Mark all",
                    style: GoogleFonts.leagueSpartan(
                      fontSize: AppSize.width(context) * 0.046, // 18
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2260FF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(context) * 0.023), // 10
              Expanded(
                child: BlocConsumer<NotificationBloc, NotificationState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:AppSize.width(context) * 0.050, // 12
                                    vertical: AppSize.height(context) * 0.025, // 5
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xff2260FF),
                                    shape: BoxShape.circle
                                  ),
                                  child:SvgPicture.asset("assets/images/bottom_calender.svg"),
                                ),
                              ],
                            ),
                            SizedBox(width: AppSize.width(context) * 0.050), // 12
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(state.notifications[index].title,
                                    style: GoogleFonts.leagueSpartan(
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppSize.width(context) * 0.05, // 18
                                    ),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(state.notifications[index].body,),
                                  ],
                                ),

                              ],
                            )
                           ],
                        );
                      },
                      itemCount: state.notifications.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customDayContainers(BuildContext context, {required String text}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(context) * 0.050, // 12
      vertical: AppSize.height(context) * 0.005, // 5
    ),
    decoration: BoxDecoration(
      color: Color(0xffCAD6FF),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Text(
      text,
      style: GoogleFonts.leagueSpartan(
        fontSize: AppSize.width(context) * 0.058, // 18
        fontWeight: FontWeight.w400,
        color: Color(0xff2260FF),
      ),
    ),
  );
}
