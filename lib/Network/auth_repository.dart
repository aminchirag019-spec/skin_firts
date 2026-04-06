import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skin_firts/Data/appointment_model.dart';
import 'package:skin_firts/Network/translation_repository.dart';

import '../Data/auth_model.dart';
import '../Data/doctor_model.dart';
import '../Helper/sharedpref_helper.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
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
        await firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': signupModel.name,
          'email': signupModel.email,
          'phone': signupModel.phone,
          'dob': signupModel.dob,
          'password': signupModel.password,
          'role': signupModel.role,
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
          await firestore.collection('users').doc(user.uid).set({
            ...userModel.toJson(),
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
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

  Future<AddDoctor?> getDoctorByUid(
    String doctorUid, {
    String langCode = 'en',
  }) async {
    final doc = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(doctorUid)
        .get();

    if (doc.exists) {
      AddDoctor doctor = AddDoctor.fromJson(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );

      if (langCode != 'en') {
        final translations = await Future.wait([
          TranslationService.translate(
            doctor.getLocalized(doctor.doctorName, langCode, null),
            langCode,
          ),
          TranslationService.translate(
            doctor.getLocalized(doctor.specialization, langCode, null),
            langCode,
          ),
          TranslationService.translate(
            doctor.getLocalized(doctor.qualification, langCode, null),
            langCode,
          ),
          TranslationService.translate(
            doctor.getLocalized(doctor.description, langCode, null),
            langCode,
          ),
        ]);

        return doctor.copyWith(
          doctorName: translations[0],
          specialization: translations[1],
          qualification: translations[2],
          description: translations[3],
        );
      }
      return doctor;
    }
    return null;
  }

  Future<List<AddDoctor>> getDoctors({
    String? sortBy,
    bool? liked,
    String? gender,
    String langCode = 'en',
  }) async {
    try {
      Query query = firestore.collection("doctors");

      if (gender != null) {
        query = query.where("gender", isEqualTo: gender);
      }
      if (liked != null) {
        query = query.where("isLiked", isEqualTo: liked);
      }

      if (sortBy != null) {
        if (sortBy == "A->Z") {
          query = query.orderBy("doctorName");
        } else if (sortBy == "Z->A") {
          query = query.orderBy("doctorName", descending: true);
        } else if (sortBy == "Rating") {
          query = query.orderBy("rating", descending: true);
        }
      }

      final snapshot = await query.get();
      List<AddDoctor> doctors = snapshot.docs.map((doc) {
        return AddDoctor.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      if (langCode != 'en') {
        doctors = await Future.wait(
          doctors.map((d) async {
            final translations = await Future.wait([
              TranslationService.translate(
                d.getLocalized(d.doctorName, langCode, null),
                langCode,
              ),
              TranslationService.translate(
                d.getLocalized(d.specialization, langCode, null),
                langCode,
              ),
              TranslationService.translate(
                d.getLocalized(d.qualification, langCode, null),
                langCode,
              ),
            ]);
            return d.copyWith(
              doctorName: translations[0],
              specialization: translations[1],
              qualification: translations[2],
            );
          }),
        );
      }

      return doctors;
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
      return [];
    }
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

      await firestore.collection('users').doc(user.uid).update({
        "password": newPassword,
        "passwordUpdatedAt": DateTime.now().toIso8601String(),
      });
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

    await firestore.collection('users').doc(user.uid).update({
      "name": signupModel.name,
      "phone": signupModel.phone,
      "dob": signupModel.dob,
      "email": signupModel.email,
      "updatedAt": DateTime.now().toIso8601String(),
    });
  }

  Future<void> likedDoctor(String doctorUid, bool isLiked) async {
    try {
      await firestore.collection("doctors").doc(doctorUid).update({
        "isLiked": isLiked,
      });
    } catch (e) {
      debugPrint("Error liking doctor: $e");
    }
  }

  Future<void> addDoctor({required AddDoctor addDoctorModel}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    final docRef = firestore.collection('doctors').doc();

    await docRef.set({
      ...addDoctorModel.toJson(),
      "id": docRef.id,
      "userId": user.uid,
      "createdAt": DateTime.now().toIso8601String(),
    });
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

  Future<List<SignupModel>> getAllDoctors() async {
    try {
      final snapshot = await firestore
          .collection("users")
          .where("role", isEqualTo: "doctor")
          .get();

      return snapshot.docs.map((doc) {
        return SignupModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
      return [];
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

  // Appointment methods
  Future<void> bookAppointment(AppointmentModel appointment) async {
    final docRef = firestore.collection('appointments').doc();
    await docRef.set({
      ...appointment.toJson(),
      'id': docRef.id,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<AppointmentModel>> getAppointments() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return [];
    }

    final userData = await firestore.collection('users').doc(user.uid).get();
    final role = userData.data()?['role'];

    Query query = firestore.collection('appointments');

    if (role == 'doctor') {
      // If doctor, fetch appointments booked FOR them
      query = query.where('doctorId', isEqualTo: user.uid);
    } else {
      // If user, fetch appointments booked BY them
      query = query.where('userId', isEqualTo: user.uid);
    }

    final snapshot = await query.orderBy('createdAt', descending: true).get();

    return snapshot.docs.map((doc) {
      return AppointmentModel.fromJson(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<void> updateAppointmentStatus(
    String appointmentId,
    String status,
  ) async {
    await firestore.collection('appointments').doc(appointmentId).update({
      'status': status,
    });
  }
}
