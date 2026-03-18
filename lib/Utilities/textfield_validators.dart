import 'package:skin_firts/Utilities/App_regex.dart';

class Validators {


  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter the email";
    }
    return null;
  }
  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty || AppRegex.password.hasMatch(value)) {
      return "Please enter your password";
    }
    return null;
  }
  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty || AppRegex.phone.hasMatch(value)) {
      return "Please enter valid mobile number";
    }
    return null;
  }
}
