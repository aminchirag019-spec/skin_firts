part of 'auth_bloc.dart';

 class AuthEvent  {}


class SignUpEvent extends AuthEvent {
   final SignupModel signupModel;
   SignUpEvent({required this.signupModel});
}

class LoginEvent extends AuthEvent {
   final LoginModel loginModel;
   LoginEvent({required this.loginModel});
}

class BiometricLoginEvent extends AuthEvent {}
class AskBiometricEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}