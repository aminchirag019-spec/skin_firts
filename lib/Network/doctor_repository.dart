import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' hide Query;
import 'package:flutter/cupertino.dart';
import 'package:skin_firts/Network/translation_repository.dart';

import '../Data/auth_model.dart';
import '../Data/doctor_model.dart';
import '../main.dart';

class DoctorRepository {
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
  Future<void> likedDoctor(String doctorUid, bool isLiked) async {
    try {
      await firestore.collection("doctors").doc(doctorUid).update({
        "isLiked": isLiked,
      });
      await realtimeDatabase.ref('doctors').child(doctorUid).update({
        "isLiked": isLiked,
      });
    } catch (e) {
      debugPrint("Error liking doctor: $e");
    }
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

  Future<void> addDoctor({required AddDoctor addDoctorModel}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    final docRef = firestore.collection('doctors').doc();
    final doctorData = {
      ...addDoctorModel.toJson(),
      "id": docRef.id,
      "userId": user.uid,
      "createdAt": DateTime.now().toIso8601String(),
    };

    await docRef.set(doctorData);
    await realtimeDatabase.ref('doctors').child(docRef.id).set(doctorData);
  }
}