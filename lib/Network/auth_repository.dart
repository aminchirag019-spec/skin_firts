import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';

import '../Data/auth_model.dart';
import '../Data/dotor_model.dart';
import '../main.dart';

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
      print("Error creating user: $e");
    }
  }

  Future<List<ServiceModel>> getServices() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .get();

    return snapshot.docs
        .map((doc) => ServiceModel.fromJson(doc.data()))
        .toList();
  }

  Future<AddDoctor?> getDoctorByUid(String doctorUid) async {
    final doc = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(doctorUid)
        .get();

    if (doc.exists) {
      return AddDoctor.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }

    return null;
  }

  Future<void> storeNotification({
    required NotificationModel notificationModel,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("notification")
          .add({
            "title": notificationModel.title,
            "body": notificationModel.body,
            "createdAt": DateTime.now().toIso8601String(),
          });
      print("Notification stored successfully");
    } catch (e) {
      print("Error storing notification: $e");
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    try {
      if (user == null) {
        print("User is null");
        return [];
      }
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("notification")
          .orderBy("createdAt", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return []; // ✅ IMPORTANT
    }
  }

  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (user == null) return;
    try {
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user!.reauthenticateWithCredential(credential);
      await user!.updatePassword(newPassword);

      await firestore.collection('users').doc(user!.uid).update({
        "password": newPassword,
        "passwordUpdatedAt": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Error updating password: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile({required SignupModel signupModel}) async {
    if (user == null) return;

    await firestore.collection('users').doc(user!.uid).update({
      "name": signupModel.name,
      "phone": signupModel.phone,
      "dob": signupModel.dob,
      "email": signupModel.email,
      "updatedAt": DateTime.now().toIso8601String(),
    });
  }

  Future<void> likedDoctor(String doctorUid, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final favRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .doc(doctorUid);

    if (isLiked) {
      await favRef.set({
        "doctorId": doctorUid,
        "likedAt": FieldValue.serverTimestamp(),
      });
    } else {
    }
  }

  Future<List<AddDoctor>> getDoctors({
    String? sortBy,
    bool? liked,
    String? gender,
  }) async {
    Query query = firestore
        .collection("doctors")
        .where("userId", isEqualTo: user!.uid);

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

    return snapshot.docs.map((doc) {
      return AddDoctor.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> addDoctor({required AddDoctor addDoctorModel}) async {
    final docRef = firestore.collection('doctors').doc();

    await docRef.set({
      ...addDoctorModel.toJson(),
      "id": docRef.id,
      "userId": user!.uid,
      "createdAt": DateTime.now().toIso8601String(),
    });
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

  // Future<User?> login({required LoginModel loginModel}) async {
  //   try {
  //     final credential = await firebaseAuth.signInWithEmailAndPassword(
  //       email: loginModel.email,
  //       password: loginModel.password,
  //     );
  //
  //     final user = credential.user;
  //     final token = await user?.getIdToken();
  //     if (user != null) {
  //       await SharedPrefsHelper.setLogin(
  //         userId: user.uid,
  //         accessToken: token ?? "",
  //         checkToken: token ?? "",
  //       );
  //       print("Login successful: ${user.uid}");
  //       return user;
  //     }
  //   } catch (e) {
  //     print("Error logging in: $e");
  //   }
  //   return null;
  // }
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
      print(e);
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
      print("Error fetching doctors: $e");
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
      print("Error fetching users: $e");
      return [];
    }
  }


}
