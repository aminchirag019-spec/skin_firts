import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricAuthService {

  final LocalAuthentication _auth = LocalAuthentication();
  Future<bool> hasBiometrics() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      return canCheckBiometrics && isDeviceSupported;

    } on PlatformException catch (e) {
      print("Biometric check error: $e");
      return false;
    }
  }

  Future<bool> authenticate() async {

    final bool isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: "Authenticate to login",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: "Fingerprint Authentication",
            cancelButton: "Cancel",
          ),
        ],
      );

      return isAuthenticated;

    } on PlatformException catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }
}