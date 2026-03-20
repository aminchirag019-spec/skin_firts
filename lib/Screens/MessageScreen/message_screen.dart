import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_event.dart';
import 'package:skin_firts/Data/dotor_model.dart';
import 'package:skin_firts/Utilities/time_zones.dart';

import '../../Bloc/NotificationBloc/notification_bloc.dart';
import '../../Bloc/NotificationBloc/notification_state.dart';
import '../../Global/coustom_widgets.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';
import '../../main.dart';

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
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.homeScreen.path);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    GestureDetector(
                      onTap: () {
                        context.push(
                          RouterName.chatScreen.path,
                          extra: {
                            "receiverId": user!.uid,
                            "receiverName": user!.email,
                          },
                        );
                      },
                      child: customDayContainers(text: "Today", context),
                    ),
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
                        itemCount: state.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = state.notifications[index];

                          return GestureDetector(
                            onTap: () {
                              context.go(RouterName.chatScreen.path);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: AppSize.width(context) * 0.00,
                                vertical: AppSize.height(context) * 0.01,
                              ),
                              padding: EdgeInsets.all(
                                AppSize.width(context) * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSize.width(context) * 0.04,
                                      vertical: AppSize.height(context) * 0.02,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2260FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/images/bottom_calender.svg",
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: AppSize.width(context) * 0.04),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.leagueSpartan(
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppSize.width(context) * 0.045,
                                          ),
                                        ),
                                        Text(
                                          notification.body,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.leagueSpartan(
                                            fontWeight: FontWeight.w300,
                                            fontSize: AppSize.width(context) * 0.045,
                                            color: Colors.black,
                                            height: 1
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(notificationFormatTime(time))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
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
