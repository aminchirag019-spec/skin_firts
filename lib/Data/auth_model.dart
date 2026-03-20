class SignupModel {
  final String uid;
  final String email;
  final String password;
  final String name;
  final String phone;
  final String dob;
  final String role;

  SignupModel({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.dob,
    required this.role,
    required this.uid
  });

  SignupModel copyWith({
    String? email,
    String? password,
    String? name,
    String? phone,
    String? dob,
    String? role,
    String? uid,
  }) {
    return SignupModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      role: role??this.role,
      uid: uid??this.uid,
    );
  }

  /// Model → JSON (save to Firestore)
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "phone": phone,
      "dob": dob,
      "role":role,
      "uid":uid
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
      role: json["role"]??'',
      uid: json["uid"]??'',
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