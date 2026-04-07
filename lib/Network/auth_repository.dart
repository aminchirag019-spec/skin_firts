import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' hide Query;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skin_firts/Data/appointment_model.dart';
import 'package:skin_firts/Network/translation_repository.dart';

import '../Data/auth_model.dart';
import '../Data/doctor_model.dart';
import '../Helper/sharedpref_helper.dart';
import '../main.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signUp({required SignupModel signupModel}) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: signupModel.email,
        password: signupModel.password,
      );

      final user = credential.user;
      final token = await user?.getIdToken();
      if (user != null) {
        final userData = {
          'uid': user.uid,
          'name': signupModel.name,
          'email': signupModel.email,
          'phone': signupModel.phone,
          'dob': signupModel.dob,
          'password': signupModel.password,
          'role': signupModel.role,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        // Store in Firestore
        await firestore.collection('users').doc(user.uid).set(userData);

        // Store in Realtime Database
        await realtimeDatabase.ref('users').child(user.uid).set(userData);

        await SharedPrefsHelper.setLogin(
          userId: user.uid,
          accessToken: token ?? "",
          checkToken: token ?? "",
        );
        return user;
      }
    } catch (e) {
      debugPrint("Error creating user: $e");
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final token = await user.getIdToken();
        final doc = await firestore.collection('users').doc(user.uid).get();

        SignupModel userModel;
        if (!doc.exists) {
          userModel = SignupModel(
            uid: user.uid,
            name: user.displayName ?? "",
            email: user.email ?? "",
            phone: "",
            dob: "",
            password: "",
            role: "user",
          );
          final userData = {
            ...userModel.toJson(),
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          };
          
          await firestore.collection('users').doc(user.uid).set(userData);
          await realtimeDatabase.ref('users').child(user.uid).set(userData);
        } else {
          userModel = SignupModel.fromJson(doc.data()!);
        }

        await SharedPrefsHelper.setLogin(
          userId: user.uid,
          accessToken: token ?? "",
          checkToken: token ?? "",
        );

        return {"user": userModel, "role": userModel.role};
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      rethrow;
    }
    return null;
  }

  Future<List<ServiceModel>> getServices({String langCode = 'en'}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .get();
    List<ServiceModel> services = snapshot.docs
        .map((doc) => ServiceModel.fromJson(doc.data()))
        .toList();

    if (langCode != 'en') {
      services = await Future.wait(
        services.map((s) async {
          final translatedTitle = await TranslationService.translate(
            s.getLocalizedTitle(langCode),
            langCode,
          );
          final translatedDesc = await TranslationService.translate(
            s.getLocalizedDesc(langCode),
            langCode,
          );
          return ServiceModel(
            title: translatedTitle,
            discription: translatedDesc,
          );
        }),
      );
    }
    return services;
  }




  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      final updateData = {
        "password": newPassword,
        "passwordUpdatedAt": DateTime.now().toIso8601String(),
      };

      await firestore.collection('users').doc(user.uid).update(updateData);
      await realtimeDatabase.ref('users').child(user.uid).update(updateData);
    } catch (e) {
      debugPrint("Error updating password: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile({required SignupModel signupModel}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return;
    }

    final updateData = {
      "name": signupModel.name,
      "phone": signupModel.phone,
      "dob": signupModel.dob,
      "email": signupModel.email,
      "updatedAt": DateTime.now().toIso8601String(),
    };

    await firestore.collection('users').doc(user.uid).update(updateData);
    await realtimeDatabase.ref('users').child(user.uid).update(updateData);
  }





  Future<SignupModel?> getCurrentUserDetails({String langCode = 'en'}) async {
    try {
      final user = firebaseAuth.currentUser;

      if (user != null) {
        final userId = user.uid;

        final userData = await firestore.collection('users').doc(userId).get();

        if (userData.exists) {
          SignupModel signupModel = SignupModel.fromJson(userData.data()!);

          if (langCode != 'en') {
            final translatedName = await TranslationService.translate(
              signupModel.name,
              langCode,
            );
            signupModel = signupModel.copyWith(name: translatedName);
          }

          return signupModel;
        }
      }

      return null;
    } catch (e) {
      debugPrint("Error fetching user: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> login({required LoginModel loginModel}) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: loginModel.email,
        password: loginModel.password,
      );

      final user = credential.user;

      if (user != null) {
        final token = await user.getIdToken();

        await SharedPrefsHelper.setLogin(
          userId: user.uid,
          accessToken: token ?? "",
          checkToken: token ?? "",
        );

        final doc = await firestore.collection('users').doc(user.uid).get();

        final userModel = SignupModel.fromJson(doc.data()!);

        return {"user": userModel, "role": userModel.role};
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      rethrow;
    }
    return null;
  }

  Future<void> logout() async {
    try {
      String? userId = await SharedPrefsHelper.getUserId();
      if (userId != null) {
        await SharedPrefsHelper.logout(userId);
      }

      await firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }


  Future<List<SignupModel>> getAllUsers() async {
    try {
      final snapshot = await firestore
          .collection("users")
          .where("role", isEqualTo: "user")
          .get();

      return snapshot.docs.map((doc) {
        return SignupModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      debugPrint("Error fetching users: $e");
      return [];
    }
  }


}
