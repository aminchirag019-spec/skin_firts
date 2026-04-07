part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  final LoginStatus loginStatus;
  final SignupStatus signupStatus;
  final SignupModel? signupModel;
  final LoginModel? loginModel;
  final BiometricStatus? biometricStatus;
  final SignupModel? currentUser;
  final PasswordStatus? passwordStatus;



  const AuthState({
    this.loginStatus = LoginStatus.initial,
    this.signupStatus = SignupStatus.initial,
    this.biometricStatus = BiometricStatus.initial,
    this.passwordStatus = PasswordStatus.initial,

    this.signupModel,
    this.loginModel,
    this.currentUser,



  });

  AuthState copyWith({
    LoginStatus? loginStatus,
    SignupStatus? signupStatus,
    PasswordStatus? passwordStatus,
    SignupModel? signupModel,
    LoginModel? loginModel,
    BiometricStatus? biometricStatus,
    SignupModel? currentUser,

    String? role,
    String? selectedRole


  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      signupStatus: signupStatus ?? this.signupStatus,

      signupModel: signupModel ?? this.signupModel,
      loginModel: loginModel ?? this.loginModel,
      biometricStatus: biometricStatus ?? this.biometricStatus,
      currentUser: currentUser ?? this.currentUser,
      passwordStatus: passwordStatus ?? this.passwordStatus,


    );
  }

  @override
  List<Object?> get props => [
    loginStatus,
    signupStatus,
    signupModel,
    loginModel,
    biometricStatus,
    currentUser,
    passwordStatus,

  ];
}