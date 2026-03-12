class AddDoctor {
  final String doctorName;
  final String qualification;
  final String experience;
  final String specialization;
  final String availability;
  final String description;
  final String profile;
  final String careerPath;
  final String highlights;

  AddDoctor({
    required this.doctorName,
    required this.experience,
    required this.specialization,
    required this.availability,
    required this.description,
    required this.profile,
    required this.careerPath,
    required this.highlights,
    required this.qualification
  });

  AddDoctor copyWith({
    String? doctorName,
    String? experience,
    String? specialization,
    String? availability,
    String? description,
    String? profile,
    String? careerPath,
    String? highlights,
    String? qualification,
  }) {
    return AddDoctor(
      doctorName: doctorName ?? this.doctorName,
      experience: experience ?? this.experience,
      specialization: specialization ?? this.specialization,
      availability: availability ?? this.availability,
      description: description ?? this.description,
      profile: profile ?? this.profile,
      careerPath: careerPath ?? this.careerPath,
      highlights: highlights ?? this.highlights,
      qualification: qualification ?? this.qualification,
    );
  }

  /// Convert Model → JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      "doctorName": doctorName,
      "experience": experience,
      "specialization": specialization,
      "availability": availability,
      "description": description,
      "profile": profile,
      "careerPath": careerPath,
      "highlights": highlights,
      "qualification": qualification,
    };
  }

  /// Convert JSON → Model (from Firebase)
  factory AddDoctor.fromJson(Map<String, dynamic> json) {
    return AddDoctor(
      doctorName: json["doctorName"] ?? "",
      experience: json["experience"] ?? "",
      specialization: json["specialization"] ?? "",
      availability: json["availability"] ?? "",
      description: json["description"] ?? "",
      profile: json["profile"] ?? "",
      careerPath: json["careerPath"] ?? "",
      highlights: json["highlights"] ?? "",
      qualification: json["qualification"] ?? "",
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