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
  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    await AuthRepository().logout();

    emit(state.copyWith(loginStatus: LoginStatus.initial));
  }

  void _onAskbiometric(AskBiometricEvent event, Emitter<AuthState> emit) async {
    try {
      String? userId = await SharedPrefsHelper.getUserId();

      if (userId == null) {
        emit(state.copyWith(biometricStatus: BiometricStatus.skip));
        return;
      }

      bool? enabled = await SharedPrefsHelper.getBiometricEnabled(userId);

      if (enabled == null) {
        bool authenticated = await biometricAuthService.authenticate();

        if (authenticated) {
          await SharedPrefsHelper.setBiometricEnabled(true, userId);

          emit(state.copyWith(biometricStatus: BiometricStatus.enabled));
        } else {
          await SharedPrefsHelper.setBiometricEnabled(false, userId);

          emit(state.copyWith(biometricStatus: BiometricStatus.skip));
        }
      }
      /// Biometric already enabled
      else if (enabled == true) {
        bool authenticated = await biometricAuthService.authenticate();

        if (authenticated) {
          emit(state.copyWith(biometricStatus: BiometricStatus.enabled));
        } else {
          emit(state.copyWith(biometricStatus: BiometricStatus.skip));
        }
      }
      /// User skipped biometric
      else {
        emit(state.copyWith(biometricStatus: BiometricStatus.skip));
      }
    } catch (e) {
      print("Biometric Error: $e");

      emit(state.copyWith(biometricStatus: BiometricStatus.skip));
    }
  }

  void _onBiometricLoginEvent(
    BiometricLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    print("Event Received");
    try {
      bool isAuthenticated = await biometricAuthService.authenticate();

      if (isAuthenticated) {
        emit(
          state.copyWith(
            biometricStatus: BiometricStatus.enabled,
            loginStatus: LoginStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            biometricStatus: BiometricStatus.skip,
            loginStatus: LoginStatus.success,
          ),
        );
      }
    } catch (e) {
      print("-------------------------${e}");
      emit(state.copyWith(biometricStatus: BiometricStatus.skip));
    }
  }

  void _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      await repository.login(loginModel: event.loginModel);
      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
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
