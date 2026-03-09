

import 'package:flutter/cupertino.dart';

class DummyData {
  final String doctorName;
  final String qualification;
  final String title;
  // final String discription;
  final ImageProvider<Object> image;


  DummyData({
    required this.doctorName,
    required this.title,
    required this.image,
    required this.qualification,
    // required this.discription,
  });
}


List<DummyData> doctors = [
    DummyData(doctorName: "Dr. Alexander Bennett",qualification: "Ph.D", title: "Dermato-Genetics", image: AssetImage("assets/images/doctor_1.png")),
    DummyData(doctorName: "Dr. Michael Davidson",qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_2.png")),
    DummyData(doctorName: "Dr. Olivia Turner",qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_3.png")),
    DummyData(doctorName: "Dr. Guru Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png")),
    DummyData(doctorName: "Dr. Shakira Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png")),
    DummyData(doctorName: "Dr. Bruno Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png")),
    DummyData(doctorName: "Dr. Binod Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png")),
    DummyData(doctorName: "Dr.  Martinez",qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png")),
];