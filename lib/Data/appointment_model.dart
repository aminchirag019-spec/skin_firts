import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorQualification;
  final String doctorSpecialization;
  final String doctorImage;
  final String userId;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String problem;
  final String date; // E.g., "Sunday, 12 June"
  final String time; // E.g., "9:30 AM"
  final String status; // "upcoming", "complete", "cancelled"
  final Timestamp createdAt;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorQualification,
    required this.doctorSpecialization,
    required this.doctorImage,
    required this.userId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.problem,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json, String id) {
    return AppointmentModel(
      id: id,
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorQualification: json['doctorQualification'] ?? '',
      doctorSpecialization: json['doctorSpecialization'] ?? '',
      doctorImage: json['doctorImage'] ?? '',
      userId: json['userId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAge: json['patientAge'] ?? '',
      patientGender: json['patientGender'] ?? '',
      problem: json['problem'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'upcoming',
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorQualification': doctorQualification,
      'doctorSpecialization': doctorSpecialization,
      'doctorImage': doctorImage,
      'userId': userId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'problem': problem,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
