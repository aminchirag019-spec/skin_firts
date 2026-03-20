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
class LoadCurrentUser extends AuthEvent{}
class UpdateProfileEvent extends AuthEvent{
   final SignupModel signupModel;
   UpdateProfileEvent({required this.signupModel});
}
class UpdatePasswordEvent extends AuthEvent{
    final String currentPassword;
    final String newPassword;
    final String confirmPassword;
    UpdatePasswordEvent({required this.currentPassword,required this.newPassword,required this.confirmPassword});
}
class LoadChatListEvent extends AuthEvent{}

class SelectRoleEvent extends AuthEvent {
  final String role;
  SelectRoleEvent(this.role);
}
