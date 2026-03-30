import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_event.dart';

import 'package:skin_firts/Utilities/time_zones.dart';

import '../../Bloc/NotificationBloc/notification_bloc.dart';
import '../../Bloc/NotificationBloc/notification_state.dart';
import '../../Global/coustom_widgets.dart';
import '../../Helper/app_localizations.dart';
import '../../Router/router_class.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/media_query.dart';
import '../../main.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.homeScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.064,
              vertical: AppSize.height(context) * 0.023,
            ),
            child: Column(
              children: [
                topRow(
                  context,
                  onPressed: () => context.go(RouterName.homeScreen.path),
                  text: localization?.translate('Notification') ?? "Notification",
                ),
                SizedBox(height: AppSize.height(context) * 0.023),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customDayContainers(
                      context,
                      text: localization?.translate('today') ?? "Today",
                    ),
                    Text(
                      localization?.translate('markAll') ?? "Mark all",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.height(context) * 0.023),
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
                                      color: colorScheme.primary,
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
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          notification.body,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Text(notificationFormatTime(notification.timestamp))
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
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(context) * 0.050,
      vertical: AppSize.height(context) * 0.005,
    ),
    decoration: BoxDecoration(
      color: colorScheme.secondary,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: colorScheme.primary,
          ),
    ),
  );
}
