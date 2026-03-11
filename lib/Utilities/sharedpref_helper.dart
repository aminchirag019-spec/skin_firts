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

    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("userId", userId);
    await prefs.setString("accessToken", accessToken);
    await prefs.setString("checkToken", checkToken);
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

    return prefs.getBool("isLoggedIn") ?? false;
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("accessToken");
  }

  static Future<String?> getCheckToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("checkToken");
  }
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("userId");
  }
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(PrefKeys.isLoggedIn);
    await prefs.remove(PrefKeys.loginId);
    await prefs.remove(PrefKeys.accessToken);
    await prefs.remove(PrefKeys.checkToken);
  }
}