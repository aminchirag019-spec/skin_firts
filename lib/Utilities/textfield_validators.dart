import 'package:flutter/material.dart';
import 'package:skin_firts/Utilities/App_regex.dart';
import 'package:skin_firts/Helper/app_localizations.dart';

class Validators {

  String? validateDob(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
        return localization?.translate('Please enter you birth date') ?? "Please enter you birth date";
    }
    return null;
  }

  String? validateName(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return localization?.translate('Please enter your full name') ?? "Please enter your full name";
    }
    return null;
  }

  String? validateEmail(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return localization?.translate('Please enter the email') ?? "Please enter the email";
    }
    return null;
  }

  String? validatePassword(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return localization?.translate('Please enter your password') ?? "Please enter your password";
    }
    // if (!AppRegex.password.hasMatch(value)) {
    //   return localization?.translate('Please enter a valid password') ?? "Please enter a valid password";
    // }
    return null;
  }

  String? validateMobile(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return localization?.translate('Please enter mobile number') ?? "Please enter mobile number";
    }
    if (!AppRegex.phone.hasMatch(value)) {
      return localization?.translate('"Please enter valid mobile number"') ?? "Please enter valid mobile number";
    }
    return null;
  }
}
