import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';

import '../Data/auth_model.dart';
import '../Data/dotor_model.dart';

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

  Future <List<ServiceModel>> getServices () async {
    final snapshot = await FirebaseFirestore.instance.collection('services').get();

    return snapshot.docs.map((doc) => ServiceModel.fromJson(doc.data())).toList();
  }


  Future<AddDoctor?> getDoctorByUid(String doctorUid) async {

    final doc = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(doctorUid)
        .get();

    if (doc.exists) {
      return AddDoctor.fromJson(doc.data() as Map<String, dynamic>);
    }

    return null;
  }

  Future<List<AddDoctor>> getDoctors() async {
    final snapshot = await firestore.collection("doctors").get();

    return snapshot.docs.map((doc) => AddDoctor.fromJson(doc.data())).toList();
  }

  Future<void> addDoctor({required AddDoctor addDoctorModel}) async {
    await firestore.collection('doctors').add(addDoctorModel.toJson());
  }

  Future<SignupModel?> getCurrentUserDetails() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user != null) {
        final userId = user.uid;

        final userData = await firestore.collection('users').doc(userId).get();

        if (userData.exists) {
          return SignupModel.fromJson(userData.data()!);
        }
      }

      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<User?> login({required LoginModel loginModel}) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: loginModel.email,
        password: loginModel.password,
      );

      final user = credential.user;
      final token = await user?.getIdToken();
      if (user != null) {
        await SharedPrefsHelper.setLogin(
          userId: user.uid,
          accessToken: token ?? "",
          checkToken: token ?? "",
        );
        print("Login successful: ${user.uid}");
        return user;
      }
    } catch (e) {
      print("Error logging in: $e");
    }
    return null;
  }

  Future<void> logout() async {
    try {
      String? userId = await SharedPrefsHelper.getUserId();

      if (userId != null) {
        await SharedPrefsHelper.logout(userId);
      }

      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
