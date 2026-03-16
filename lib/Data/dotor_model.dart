class AddDoctor {
  final String id;
  final String doctorName;
  final String qualification;
  final String experience;
  final String specialization;
  final String availability;
  final String description;
  final String profile;
  final String careerPath;
  final String highlights;
  final bool isLiked;
  final double rating;
  final String email;
  final String gender;


  AddDoctor({
    required this.id,
    required this.doctorName,
    required this.experience,
    required this.specialization,
    required this.availability,
    required this.description,
    required this.profile,
    required this.careerPath,
    required this.highlights,
    required this.qualification,
    required this.isLiked,
    required this.rating,
    required this.email,
    required this.gender,
  });

  AddDoctor copyWith({
    String? id,
    String? doctorName,
    String? experience,
    String? specialization,
    String? availability,
    String? description,
    String? profile,
    String? careerPath,
    String? highlights,
    String? qualification,
    bool? isLiked,
    double? rating,
    String? email,
    String? gender,
  }) {
    return AddDoctor(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      experience: experience ?? this.experience,
      specialization: specialization ?? this.specialization,
      availability: availability ?? this.availability,
      description: description ?? this.description,
      profile: profile ?? this.profile,
      careerPath: careerPath ?? this.careerPath,
      highlights: highlights ?? this.highlights,
      qualification: qualification ?? this.qualification,
      isLiked: isLiked ?? this.isLiked,
      rating: rating ?? this.rating,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }

  /// Convert Model → JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctorName": doctorName,
      "experience": experience,
      "specialization": specialization,
      "availability": availability,
      "description": description,
      "profile": profile,
      "careerPath": careerPath,
      "highlights": highlights,
      "qualification": qualification,
      "isLiked": isLiked,
      "rating": rating,
      "email": email,
      "gender": gender,
    };
  }

  /// Convert JSON → Model (from Firebase)
  factory AddDoctor.fromJson(Map<String, dynamic> json, String id) {
    return AddDoctor(
      id: id,
      doctorName: json["doctorName"] ?? "",
      experience: json["experience"] ?? "",
      specialization: json["specialization"] ?? "",
      availability: json["availability"] ?? "",
      description: json["description"] ?? "",
      profile: json["profile"] ?? "",
      careerPath: json["careerPath"] ?? "",
      highlights: json["highlights"] ?? "",
      qualification: json["qualification"] ?? "",
      isLiked: json["isLiked"] ?? false,
      rating: json["rating"] ?? 0.0,
      email: json["email"] ?? "",
      gender: json["gender"] ?? "",
    );
  }
}


class ServiceModel {
  final String title;
  final String discription;

  ServiceModel({ required this.title,required this.discription});


  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      title: json['title'] ?? '',
      discription: json['discription'] ?? '',);
  }
}