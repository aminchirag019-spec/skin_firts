part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  final LoginStatus loginStatus;
  final SignupStatus signupStatus;
  final SignupModel? signupModel;
  final LoginModel? loginModel;
  final BiometricStatus? biometricStatus;


  const AuthState({
    this.loginStatus = LoginStatus.initial,
    this.signupStatus = SignupStatus.initial,
    this.biometricStatus = BiometricStatus.initial,
    this.signupModel,
    this.loginModel,
  });

  AuthState copyWith({
    LoginStatus? loginStatus,
    SignupStatus? signupStatus,
    SignupModel? signupModel,
    LoginModel? loginModel,
    BiometricStatus? biometricStatus,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      signupStatus: signupStatus ?? this.signupStatus,
      signupModel: signupModel ?? this.signupModel,
      loginModel: loginModel ?? this.loginModel,
      biometricStatus: biometricStatus ?? this.biometricStatus,
    );
  }

  @override
  List<Object?> get props => [
    loginStatus,
    signupStatus,
    signupModel,
    loginModel,
    biometricStatus
  ];
}