import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/AuthBloc/auth_bloc.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Global/enums.dart';
import '../../Helper/app_localizations.dart';
import '../../Utilities/media_query.dart';
import '../../Utilities/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.currentUser == null) {
                return const ProfileShimmer();
              }
              final user = state.currentUser!;
              return SingleChildScrollView(
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
                        text: localization?.translate('My Profile') ?? "My Profile",
                      ),
                      SizedBox(height: AppSize.height(context) * 0.011),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: AppSize.width(context) * 0.153,
                            backgroundImage: const AssetImage(
                              "assets/images/doctor_1.png",
                            ),
                          ),
                          Positioned(
                            right: 3,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () {
                                context.go(RouterName.editUserScreen.path);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primary,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.height(context) * 0.005),
                      Text(
                        user.name ?? "",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSize.height(context) * 0.011),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/user_icon.png"),
                        title: localization?.translate('profile') ?? "profile",
                        onTap: () {},
                      ),
                      _space(context),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/heart_outlined.png",
                        ),
                        title: localization?.translate('favorite') ?? "favorite",
                        onTap: () {},
                      ),
                      _space(context),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/wallet_icon.png",
                        ),
                        title: localization?.translate('Payment Method') ?? "Payment Method",
                        onTap: () {},
                      ),
                      _space(context),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/lock_icon.png"),
                        title: localization?.translate('privacy') ?? "Privacy Policy",
                        onTap: () {
                          context.go(RouterName.privacyPolicyScreen.path);
                        },
                      ),
                      _space(context),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/profile_setting.png",
                        ),
                        title: localization?.translate('setting') ?? "Setting",
                        onTap: () {
                          context.go(RouterName.settingScreen.path);
                        },
                      ),
                      _space(context),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/img.png"),
                        title: localization?.translate('chatList') ?? "Chat List",
                        onTap: () {
                          context.push(RouterName.chatListScreen.path);
                        },
                      ),
                      _space(context),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage(
                          "assets/images/question_icon.png",
                        ),
                        title: localization?.translate('help') ?? "Help",
                        onTap: () {
                          context.go(RouterName.helpCentreScreen.path);
                        },
                      ),
                      _space(context),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state.loginStatus == LoginStatus.logout) {
                            context.go(RouterName.welcomeScreen.path);
                          }
                        },
                        builder: (context, state) {
                          return _ProfileOptionTile(
                            context,
                            image: const AssetImage(
                              "assets/images/logout_icon.png",
                            ),
                            title: localization?.translate('logout') ?? "Logout",
                            onTap: () {
                              onShowBottomSheet(context);
                            },
                          );
                        },
                      ),
                      _space(context),
                      _ProfileOptionTile(
                        context,
                        image: const AssetImage("assets/images/plus_icon.png"),
                        title: localization?.translate('Add Doctor') ?? "Add Doctor",
                        onTap: () {
                          context.go(RouterName.addDoctorScreen.path);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  final BuildContext context;
  final ImageProvider image;
  final String title;
  final VoidCallback onTap;

  const _ProfileOptionTile(
    this.context, {
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSize.width(context) * 0.051,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            child: ImageIcon(image, color: colorScheme.primary),
          ),
          SizedBox(width: AppSize.width(context) * 0.035),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: AppSize.width(context) * 0.041,
            color: theme.disabledColor,
          ),
        ],
      ),
    );
  }
}

SizedBox _space(BuildContext context) => SizedBox(height: AppSize.height(context) * 0.017);

void onShowBottomSheet(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final localization = AppLocalizations.of(context);

  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(context) * 0.064,
          vertical: AppSize.height(context) * 0.023,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localization?.translate('logout') ?? "Logout",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.height(context) * 0.020),
            Text(
              localization?.translate('Are you sure you want to log out?') ?? "Are you sure you want to log out?",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18
              ),
            ),
            SizedBox(height: AppSize.height(context) * 0.035),
            Row(
              children: [
                Expanded(
                  child: customButton(
                    context,
                    text: localization?.translate('Cancel') ?? "Cancel",
                    backgroundColor: colorScheme.secondary,
                    textColor: colorScheme.primary,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
                SizedBox(width: AppSize.width(context) * 0.035),
                Expanded(
                  child: customButton(
                    context,
                    text: localization?.translate('logout') ?? "Logout",
                    backgroundColor: colorScheme.primary,
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.height(context) * 0.040)
          ],
        ),
      );
    },
  );
}
