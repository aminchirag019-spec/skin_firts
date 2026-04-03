import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_firts/Utilities/session_keys.dart';

class SharedPrefsHelper {

  /// SAVE LOGIN DATA
  static Future<void> setLogin({
    required String userId,
    required String accessToken,
    required String checkToken,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(PrefKeys.isLoggedIn, true);
    await prefs.setString(PrefKeys.loginId, userId);
    await prefs.setString(PrefKeys.accessToken, accessToken);
    await prefs.setString(PrefKeys.checkToken, checkToken);
  }

  static Future<bool?> getBiometricEnabled(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("biometricEnabled_$userId");
  }


  static Future<void> setBiometricEnabled(bool value,String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("biometricEnabled_$userId", value);
  }

  /// CHECK LOGIN
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(PrefKeys.isLoggedIn) ?? false;
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(PrefKeys.accessToken);
  }

  static Future<String?> getCheckToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(PrefKeys.checkToken);
  }
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(PrefKeys.loginId);
  }

  /// 🌐 LANGUAGE HELPER
  static Future<void> setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("languageCode", langCode);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("languageCode");
  }

  static Future<void> logout(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(PrefKeys.isLoggedIn);
    await prefs.remove(PrefKeys.loginId);
    await prefs.remove("biometricEnabled_$userId");
    await prefs.remove(PrefKeys.accessToken);
    await prefs.remove(PrefKeys.checkToken);
  }
}
