

import 'package:flutter/cupertino.dart';


enum DoctorFilter {
  none,
  rating,
  liked,
  female,
  male
}

class DummyData {
  final String doctorName;
  final String qualification;
  final String title;
  final String gender;
  final double rating;
  final ImageProvider image;
  final bool isLiked;

  DummyData({
    required this.doctorName,
    required this.title,
    required this.image,
    required this.qualification,
    required this.gender,
    required this.rating,
    this.isLiked = false,
  });
}

List<DummyData> doctors = [
    DummyData(doctorName: "Dr. Alexander Bennett",qualification: "Ph.D", title: "Dermato-Genetics", image: AssetImage("assets/images/doctor_1.png"),gender: "Male",rating: 5),
    DummyData(doctorName: "Dr. Michael Davidson",qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_2.png"),gender: "Male",rating: 4.5),
    DummyData(doctorName: "Dr. Olivia Turner",qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_3.png"),gender: "Female",rating: 3.5),
    DummyData(doctorName: "Dr. Guru Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 4.8),
    DummyData(doctorName: "Dr. Shakira Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Male",rating: 4.1),
    DummyData(doctorName: "Dr. Bruno Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Male",rating: 2.8),
    DummyData(doctorName: "Dr. Binod Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Male",rating: 1.9),
    DummyData(doctorName: "Dr.  Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Male",rating: 3.7),
];