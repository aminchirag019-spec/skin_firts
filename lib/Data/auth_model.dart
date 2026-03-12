class SignupModel {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String dob;

  SignupModel({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.dob,
  });

  SignupModel copyWith({
    String? email,
    String? password,
    String? name,
    String? phone,
    String? dob,
  }) {
    return SignupModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
    );
  }

  /// Model → JSON (save to Firestore)
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "phone": phone,
      "dob": dob,
    };
  }

  /// JSON → Model (read from Firestore)
  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      email: json["email"] ?? "",
      password: "", // password should not come from Firestore
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      dob: json["dob"] ?? "",
    );
  }
}

class LoginModel {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  LoginModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}