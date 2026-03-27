import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Bloc/LocaleBloc/locale_bloc.dart';
import 'package:skin_firts/Utilities/app_localizations.dart';
import 'package:skin_firts/global/coustom_widgets.dart';

import '../../Bloc/LocaleBloc/locale_event.dart';
import '../../Bloc/LocaleBloc/locale_state.dart';
import '../../Utilities/colors.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.profileScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.054,
              vertical: AppSize.height(context) * 0.023,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: topRow(
                    context,
                    onPressed: () => context.go(RouterName.profileScreen.path),
                    text: localization?.translate('setting') ?? "Setting",
                  ),
                ),
                SizedBox(height: AppSize.height(context) * 0.04),
                settingOptionTile(
                  context,
                  image: const AssetImage("assets/images/notification.png"),
                  title: localization?.translate("Notification Setting") ?? "Notification Setting",
                  onTap: () {
                    context.go(RouterName.notificationSetting.path);
                  },
                ),
                SizedBox(height: AppSize.height(context) * 0.029),
                settingOptionTile(
                  context,
                  image: const AssetImage("assets/images/key.png"),
                  title: localization?.translate("Password Manager") ?? "Password Manager",
                  onTap: () {
                    context.go(RouterName.passwordManagerScreen.path);
                  },
                ),
                SizedBox(height: AppSize.height(context) * 0.029),
                _LanguageSelector(context),
                SizedBox(height: AppSize.height(context) * 0.029),
                settingOptionTile(
                  context,
                  image: const AssetImage("assets/images/user_icon.png"),
                  title: localization?.translate("Delete Account") ?? "Delete Account",
                  onTap: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final BuildContext context;
  const _LanguageSelector(this.context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                const Icon(Icons.language, size: 25, color: AppColors.grey),
                SizedBox(width: AppSize.width(context) * 0.037),
                Expanded(
                  child: Text(
                    localization?.translate("Language") ?? "Language",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LangChip(context, "English", const Locale('en'), state.locale),
                _LangChip(context, "हिंदी", const Locale('hi'), state.locale),
                _LangChip(context, "ગુજરાતી", const Locale('gu'), state.locale),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LangChip extends StatelessWidget {
  final BuildContext context;
  final String label;
  final Locale locale;
  final Locale currentLocale;

  const _LangChip(this.context, this.label, this.locale, this.currentLocale);

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLocale.languageCode == locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<LocaleBloc>().add(ChangeLocale(locale));
        }
      },
      selectedColor: colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : colorScheme.primary,
      ),
    );
  }
}

Widget settingOptionTile(
  BuildContext context, {
  required ImageProvider image,
  required String title,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(image: DecorationImage(image: image)),
        ),
        SizedBox(width: AppSize.width(context) * 0.037),
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
          size: 20,
          color: colorScheme.primary,
        ),
      ],
    ),
  );
}
