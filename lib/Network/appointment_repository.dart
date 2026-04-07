import 'package:cloud_firestore/cloud_firestore.dart';

import '../Data/appointment_model.dart';
import '../main.dart';

class AppointmentRepository {
  // Appointment methods
  Future<void> bookAppointment(AppointmentModel appointment) async {
    final docRef = firestore.collection('appointments').doc();
    final appointmentData = {
      ...appointment.toJson(),
      'id': docRef.id,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await docRef.set(appointmentData);
    await realtimeDatabase.ref('appointments').child(docRef.id).set(appointmentData);
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
    await realtimeDatabase.ref('appointments').child(appointmentId).update({
      'status': status,
    });
  }
}