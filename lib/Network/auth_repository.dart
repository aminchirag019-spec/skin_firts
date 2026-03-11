import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';

import '../Data/auth_model.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> signUp({required SignupModel signupModel}) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: signupModel.email,
        password: signupModel.password,
      );

      final user = credential.user;
      final token = await user?.getIdToken();
      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': signupModel.name,
          'email': signupModel.email,
          'phone': signupModel.phone,
          'dob': signupModel.dob,
          'password': signupModel.password,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        await SharedPrefsHelper.setLogin(
          userId: user.uid,
          accessToken: token ?? "",
          checkToken: token ?? "",
        );
        return user;
      }
    } catch (e) {
      print("Error creating user: $e");
    }
  }


  Future<User?> login({ required LoginModel loginModel}) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: loginModel.email,
        password: loginModel.password,
      );
      print("Login successful: ${credential.user!.uid}");
    } catch (e) {
      print("Error logging in: $e");
    }
  }


  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      await SharedPrefsHelper.logout();
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}