

import 'package:flutter/cupertino.dart';
import 'package:skin_firts/Global/app_string.dart';


enum DoctorFilter {
  none,
  sortBy,
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
  final String? profileDetails;
  final String? careerPath;
  final String? highlights;

  DummyData({
    required this.doctorName,
    required this.title,
    required this.image,
    required this.qualification,
    required this.gender,
    required this.rating,
    this.isLiked = false,
    required this.id,
    this.profileDetails,
    this.careerPath,
    this.highlights,
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
    String? profileDetails,
    String? careerPath,
    String? highlights,
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
      profileDetails: profileDetails ?? this.profileDetails,
      careerPath: careerPath ?? this.careerPath,
      highlights: highlights ?? this.highlights,
    );
  }
}


List<DummyData> doctors = [
    DummyData(doctorName: AppString.alexander,id: 0,qualification: "Ph.D", title: "Dermato-Genetics", image: AssetImage("assets/images/doctor_1.png"),gender: "Male",rating: 5,
    profileDetails: "Dr. Aisha Mehta is a highly skilled dermatologist specializing in the diagnosis and treatment of various skin conditions. She is known for her patient-centered"
        " approach and focuses on providing personalized treatments for acne, pigmentation, and skin allergies.",careerPath: "She completed her MBBS followed by an MD in Dermatology from a reputed medical university. Over the years,"
            " she has gained extensive clinical experience working in both private hospitals and specialized skin clinics.",highlights: "He is recognized for his research contributions and has published multiple articles in medical journals."
            " His integrative treatment approach combines medical therapy with lifestyle guidance."
    ),
    DummyData(doctorName: AppString.michael,id: 1,qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_2.png"),gender: "Male",rating: 4.5,
    profileDetails: "Dr. Neha Kapoor is a cosmetic dermatologist known for delivering natural-looking aesthetic results. She focuses on enhancing skin health through minimally invasive cosmetic procedures.",
      careerPath: "Dr. Kapoor completed her dermatology specialization and later trained in advanced cosmetic dermatology techniques, including chemical peels, laser therapy, and skin rejuvenation treatments.",
      highlights: "She has worked with leading aesthetic clinics and has gained recognition for her expertise in anti-aging treatments and skin rejuvenation procedures."
    ),
    DummyData(doctorName: AppString.olivia,id: 2,qualification: "M.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_3.png"),gender: "Female",rating: 3.5,
    profileDetails: "Dr. Rahul Sharma is an experienced endocrinologist who focuses on hormonal disorders affecting the skin and overall health. His expertise includes treating acne caused by hormonal imbalance and conditions such as PCOS.",
      careerPath: "After completing his MBBS, Dr. Sharma pursued a specialization in Internal Medicine and later completed a fellowship in Endocrinology. He has spent several years researching hormone-related skin conditions.",
      highlights: "He is recognized for his research contributions and has published multiple articles in medical journals. His integrative treatment approach combines medical therapy with lifestyle guidance."
    ),
    DummyData(doctorName: AppString.martinez,id: 3,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 4.8,
    profileDetails: "Dr. Arjun Patel is a pediatric dermatologist dedicated to treating skin conditions in infants and children. He is known for his compassionate care and ability to make young patients feel comfortable during treatment.",
      careerPath: "He completed his medical degree followed by dermatology training and a fellowship in pediatric dermatology, focusing specifically on childhood skin disorders.",
      highlights: "Dr. Patel has extensive experience in treating eczema, birthmarks, and childhood allergies. He actively participates in awareness programs about children’s skin health."
    ),
    DummyData(doctorName: "Dr. Shakira Martinez",id: 4,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 4.1,
    profileDetails: "Dr. Kavita Shah is a trichologist specializing in hair and scalp disorders. She focuses on diagnosing the root causes of hair loss and providing effective treatment plans.",
      careerPath: "After earning her dermatology degree, she pursued additional training in trichology and hair restoration techniques.",
      highlights: "Dr. Shah is known for her expertise in hair loss treatments, scalp therapies, and PRP treatments, helping many patients regain confidence through improved hair health."
    ),
    DummyData(doctorName: "Dr. Bruno Martinez",id: 5,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 2.8,
    profileDetails: "Dr. Vikram Desai is a clinical dermatologist with a strong focus on medical dermatology. He specializes in treating chronic skin conditions such as psoriasis, eczema, and severe acne.",
      careerPath: "He completed his postgraduate studies in dermatology and gained extensive hospital experience working in dermatology departments and research institutions.",
      highlights: "Dr. Desai is recognized for his research contributions and has published multiple articles in medical journals. His comprehensive treatment approach combines medical therapy with lifestyle guidance."
    ),
    DummyData(doctorName: "Dr. Binod Martinez",id: 6,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 1.9,
    profileDetails: "Dr. Pooja Nair is an aesthetic skin specialist dedicated to improving skin appearance and overall skin health through modern dermatological treatments",
      careerPath: "She completed her medical education and later specialized in aesthetic dermatology, focusing on advanced skin care procedures.",
      highlights: "Dr. Nair is known for her expertise in laser treatments, skin brightening therapies, and anti-aging procedures, helping patients achieve healthier and glowing skin"
    ),
    DummyData(doctorName: "Dr.  Martinez",id: 7,qualification: "Ph.D", title: "Solar Dermatology", image: AssetImage("assets/images/doctor_4.png"),gender: "Female",rating: 3.7,
    profileDetails: "Dr. Vikram Desai is a clinical dermatologist with a strong focus on medical dermatology. He specializes in treating chronic skin conditions such as psoriasis, eczema, and severe acn",
      careerPath: "He completed his postgraduate studies in dermatology and gained extensive hospital experience working in dermatology departments and research institutions.",
      highlights: "Dr. Desai is recognized for his research contributions and has published multiple articles in medical journals. His comprehensive treatment approach combines medical therapy with lifestyle guidance"
    ),
];



