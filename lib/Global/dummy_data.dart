

import 'package:flutter/cupertino.dart';


enum DoctorFilter {
  none,
  rating,
  liked,
  female,
  male
}

class DummyData {
  final int id;
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
    required this.id,
  });

  DummyData copyWith({
    int? id,
    String? doctorName,
    String? qualification,
    String? title,
    String? gender,
    double? rating,
    ImageProvider? image,
    bool? isLiked,
  }) {
    return DummyData(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      qualification: qualification ?? this.qualification,
      title: title ?? this.title,
      gender: gender ?? this.gender,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}


List<DummyData> doctors = [
    DummyData(doctorName: "Dr. Alexander Bennett",id: 0,qualification: "Ph.D", title: "Dermato-Genetics", image: AssetImage("assets/images/doctor_1.png"),gender: "Male",rating: 5),
    DummyData(doctorName: "Dr. Michael Davidson",id: 1,qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_2.png"),gender: "Male",rating: 4.5),
    DummyData(doctorName: "Dr. Olivia Turner",id: 2,qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_3.png"),gender: "Female",rating: 3.5),
    DummyData(doctorName: "Dr. Guru Martinez",id: 3,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 4.8),
    DummyData(doctorName: "Dr. Shakira Martinez",id: 4,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 4.1),
    DummyData(doctorName: "Dr. Bruno Martinez",id: 5,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 2.8),
    DummyData(doctorName: "Dr. Binod Martinez",id: 6,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 1.9),
    DummyData(doctorName: "Dr.  Martinez",id: 7,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 3.7),
];



