import 'package:cloud_firestore/cloud_firestore.dart';
import '../Helper/app_localizations.dart';
import '../Network/translation_repository.dart';

class AddDoctor {
  final String id;
  final dynamic doctorName;
  final dynamic qualification;
  final String experience;
  final dynamic specialization;
  final String availability;
  final dynamic description;
  final dynamic profile;
  final dynamic careerPath;
  final dynamic highlights;
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

  String getLocalized(dynamic field, String langCode, AppLocalizations? localization) {
    if (field == null) return "";
    
    if (field is Map) {
      return (field[langCode] ?? field['en'] ?? field.values.first).toString();
    }
    
    final fieldStr = field.toString();
    if (localization != null) {
      final translated = localization.translate(fieldStr);
      return translated;
    }
    return fieldStr;
  }

  Future<String> getLocalizedAsync(dynamic field, String langCode, AppLocalizations? localization) async {
    final basicResult = getLocalized(field, langCode, localization);
    if (langCode != 'en' && basicResult.isNotEmpty) {
      return await TranslationService.translate(basicResult, langCode);
    }
    
    return basicResult;
  }

  AddDoctor copyWith({
    String? id,
    dynamic doctorName,
    String? experience,
    dynamic specialization,
    String? availability,
    dynamic description,
    dynamic profile,
    dynamic careerPath,
    dynamic highlights,
    dynamic qualification,
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
      rating: (json["rating"] ?? 0.0).toDouble(),
      email: json["email"] ?? "",
      gender: json["gender"] ?? "",
    );
  }
}

class ServiceModel {
  final dynamic title;
  final dynamic discription;

  ServiceModel({required this.title, required this.discription});

  String getLocalizedTitle(String langCode) {
    if (title is Map) return (title[langCode] ?? title['en'] ?? "").toString();
    return title.toString();
  }

  Future<String> getLocalizedTitleAsync(String langCode) async {
    final text = getLocalizedTitle(langCode);
    if (langCode != 'en' && text.isNotEmpty) {
      return await TranslationService.translate(text, langCode);
    }
    return text;
  }

  String getLocalizedDesc(String langCode) {
    if (discription is Map) return (discription[langCode] ?? discription['en'] ?? "").toString();
    return discription.toString();
  }

  Future<String> getLocalizedDescAsync(String langCode) async {
    final text = getLocalizedDesc(langCode);
    if (langCode != 'en' && text.isNotEmpty) {
      return await TranslationService.translate(text, langCode);
    }
    return text;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      title: json['title'] ?? '',
      discription: json['discription'] ?? '',
    );
  }
}

  class NotificationModel {
  final dynamic title;
  final dynamic body;
  final Timestamp? createdAt;

  NotificationModel({required this.title, required this.body, this.createdAt});

  String getLocalizedTitle(String langCode, AppLocalizations? localization) {
    if (title is Map) return (title[langCode] ?? title['en'] ?? "").toString();
    final titleStr = title.toString();
    return localization?.translate(titleStr) ?? titleStr;
  }

  String getLocalizedBody(String langCode, AppLocalizations? localization) {
    if (body is Map) {
      return (body[langCode] ?? body['en'] ?? "").toString();
    }
    
    final bodyStr = body.toString();

    // Fix for Chat Notifications stored as hardcoded strings
    if (bodyStr.startsWith("You have a new message from ")) {
      final name = bodyStr.replaceFirst("You have a new message from ", "");
      final prefix = localization?.translate("new_message_prefix") ?? "You have a new message from ";
      return "$prefix$name";
    }

    // Fix for Add Doctor Notifications stored as hardcoded strings
    if (bodyStr.startsWith("You successfully added a ")) {
      final name = bodyStr.replaceFirst("You successfully added a ", "");
      final prefix = localization?.translate("add_doctor_prefix") ?? "You successfully added a ";
      return "$prefix$name";
    }

    return localization?.translate(bodyStr) ?? bodyStr;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['createdAt'] != null
          ? Timestamp.fromDate(DateTime.parse(json['createdAt']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'createdAt': createdAt?.toDate().toIso8601String(),
    };
  }
}
