part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  final LoginStatus loginStatus;
  final SignupStatus signupStatus;
  final ChatListStatus chatListStatus;
  final SignupModel? signupModel;
  final LoginModel? loginModel;
  final BiometricStatus? biometricStatus;
  final SignupModel? currentUser;
  final PasswordStatus? passwordStatus;
  final List<SignupModel> doctors;
  final List<SignupModel> users;
  final String? role;
  final String? selectedRole;

  const AuthState({
    this.loginStatus = LoginStatus.initial,
    this.signupStatus = SignupStatus.initial,
    this.biometricStatus = BiometricStatus.initial,
    this.passwordStatus = PasswordStatus.initial,
    this.chatListStatus = ChatListStatus.initial,
    this.signupModel,
    this.loginModel,
    this.currentUser,
    this.selectedRole="user",
    this.role,
    this.doctors=const[],
    this.users=const[]


  });

  AuthState copyWith({
    LoginStatus? loginStatus,
    SignupStatus? signupStatus,
    PasswordStatus? passwordStatus,
    ChatListStatus? chatListStatus,
    SignupModel? signupModel,
    LoginModel? loginModel,
    BiometricStatus? biometricStatus,
    SignupModel? currentUser,
     List<SignupModel>? doctors,
     List<SignupModel>? users,
    String? role,
    String? selectedRole


  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      signupStatus: signupStatus ?? this.signupStatus,
      chatListStatus: chatListStatus??this.chatListStatus,
      signupModel: signupModel ?? this.signupModel,
      loginModel: loginModel ?? this.loginModel,
      biometricStatus: biometricStatus ?? this.biometricStatus,
      currentUser: currentUser ?? this.currentUser,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      doctors: doctors??this.doctors,
      role: role??this.role,
      users: users??this.users,
      selectedRole: selectedRole??this.selectedRole
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
    doctors,
    users,role,chatListStatus,selectedRole
  ];
}