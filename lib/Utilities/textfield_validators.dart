import 'package:flutter/material.dart';
import 'package:skin_firts/Utilities/App_regex.dart';
import 'package:skin_firts/Helper/app_localizations.dart';

class Validators {
  String? validateEmail(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return localization?.translate('emailRequired') ?? "Please enter the email";
    }
    return null;
  }

  String? validatePassword(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return localization?.translate('passwordRequired') ?? "Please enter your password";
    }
    if (!AppRegex.password.hasMatch(value)) {
      return localization?.translate('invalidPassword') ?? "Please enter a valid password";
    }
    return null;
  }

  String? validateMobile(BuildContext context, String? value) {
    final localization = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return localization?.translate('mobileRequired') ?? "Please enter mobile number";
    }
    if (!AppRegex.phone.hasMatch(value)) {
      return localization?.translate('invalidMobile') ?? "Please enter valid mobile number";
    }
    return null;
  }
}
