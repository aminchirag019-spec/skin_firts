import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:skin_firts/Data/auth_model.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import 'package:skin_firts/Utilities/sharedpref_helper.dart';

import '../../Utilities/bio_metric.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final BiometricAuthService biometricAuthService;
  final SharedPrefsHelper prefsHelper;
  AuthBloc(this.repository, this.biometricAuthService, this.prefsHelper)
    : super(const AuthState()) {
    on<SignUpEvent>(_onSignUpEvent);
    on<LoginEvent>(_onLoginEvent);
    on<BiometricLoginEvent>(_onBiometricLoginEvent);
    on<AskBiometricEvent>(_onAskbiometric);
    on<LogoutEvent>(_onLogoutEvent);
    on<LoadCurrentUser>(_onLoadCurrentUser);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }


  void _onUpdateProfileEvent(UpdateProfileEvent event, Emitter<AuthState> emit) async{
    emit(state.copyWith(signupStatus: SignupStatus.loading));
    try {
      await repository.updateUserProfile(signupModel: event.signupModel);
      emit(state.copyWith(signupStatus: SignupStatus.success));

    }catch (e) {
      emit(state.copyWith(signupStatus: SignupStatus.failure));
    }
  }

  void _onLoadCurrentUser(LoadCurrentUser event, Emitter<AuthState> emit) async{
    final user =await repository.getCurrentUserDetails();

    emit(state.copyWith(currentUser: user));

  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    String? userId = await SharedPrefsHelper.getUserId();

    await AuthRepository().logout();

    if (userId != null) {
      await SharedPrefsHelper.logout(userId);
    }

    emit(state.copyWith(loginStatus: LoginStatus.logout));
  }
  void _onAskbiometric(AskBiometricEvent event, Emitter<AuthState> emit) async {

    String? userId = await SharedPrefsHelper.getUserId();

    if (userId == null) {
      emit(state.copyWith(biometricStatus: BiometricStatus.skip));
      return;
    }

    bool? enabled = await SharedPrefsHelper.getBiometricEnabled(userId);

    if (enabled == null) {
      emit(state.copyWith(biometricStatus: BiometricStatus.enabled));
    }
    else if (enabled == true) {
      emit(state.copyWith(biometricStatus: BiometricStatus.enabled));
    }
    else {
      emit(state.copyWith(biometricStatus: BiometricStatus.skip));
    }
  }


  void _onBiometricLoginEvent(
      BiometricLoginEvent event,
      Emitter<AuthState> emit,
      ) async {

    try {
      bool isAuthenticated = await biometricAuthService.authenticate();

      if (isAuthenticated) {
        emit(
          state.copyWith(
            biometricStatus: BiometricStatus.enabled,
          ),
        );
      } else {
        emit(
          state.copyWith(
            biometricStatus: BiometricStatus.skip,
          ),
        );
      }

    } catch (e) {
      emit(state.copyWith(biometricStatus: BiometricStatus.skip));
    }
  }
  void _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      await repository.login(loginModel: event.loginModel);

      String? userId = await SharedPrefsHelper.getUserId();

      bool? biometricEnabled;

      if (userId != null) {
        biometricEnabled =
        await SharedPrefsHelper.getBiometricEnabled(userId);
      }

      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
          biometricStatus: biometricEnabled == null
              ? BiometricStatus.initial
              : biometricEnabled
              ? BiometricStatus.enabled
              : BiometricStatus.skip,
          loginModel: event.loginModel,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loginStatus: LoginStatus.failure));
    }
  }
  void _onSignUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading));

    try {
      await repository.signUp(signupModel: event.signupModel);

      emit(
        state.copyWith(
          signupStatus: SignupStatus.success,
          signupModel: event.signupModel,
        ),
      );
    } catch (e) {
      emit(state.copyWith(signupStatus: SignupStatus.failure));
    }
  }
}
