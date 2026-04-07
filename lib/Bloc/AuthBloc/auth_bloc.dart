import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:skin_firts/Data/auth_model.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import 'package:skin_firts/Bloc/LocaleBloc/locale_bloc.dart';

import '../../Helper/sharedpref_helper.dart';
import '../../Utilities/bio_metric.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final BiometricAuthService biometricAuthService;
  final SharedPrefsHelper prefsHelper;
  final LocaleBloc localeBloc;
  StreamSubscription? _localeSubscription;

  AuthBloc(this.repository, this.biometricAuthService, this.prefsHelper, this.localeBloc)
    : super( const AuthState()) {
    _localeSubscription = localeBloc.stream.listen((localeState) {
      print("🌐 AuthBloc: Language changed to ${localeState.locale.languageCode}. Re-fetching user...");
      add(LoadCurrentUser());
    });

    on<SignUpEvent>(_onSignUpEvent);
    on<LoginEvent>(_onLoginEvent);
    on<GoogleLoginEvent>(_onGoogleLoginEvent);
    on<BiometricLoginEvent>(_onBiometricLoginEvent);
    on<AskBiometricEvent>(_onAskbiometric);
    on<LogoutEvent>(_onLogoutEvent);
    on<LoadCurrentUser>(_onLoadCurrentUser);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
    on<UpdatePasswordEvent>(_onUpdatePasswordEvent);
    on<SelectRoleEvent>(selectedRoleMethod);

  }

  String get _currentLang => localeBloc.state.locale.languageCode;

  @override
  Future<void> close() {
    _localeSubscription?.cancel();
    return super.close();
  }

  void _onUpdatePasswordEvent(
      UpdatePasswordEvent event,
      Emitter<AuthState> emit,
      ) async {
    if (event.currentPassword.isEmpty ||
        event.newPassword.isEmpty ||
        event.confirmPassword.isEmpty) {
      emit(state.copyWith(
        passwordStatus: PasswordStatus.failure,
      ));
      return;
    }

    if (event.newPassword != event.confirmPassword) {
      emit(state.copyWith(
        passwordStatus: PasswordStatus.failure,
      ));
      return;
    }

    if (event.newPassword.length < 6) {
      emit(state.copyWith(
        passwordStatus: PasswordStatus.failure,
      ));
      return;
    }

    emit(state.copyWith(passwordStatus: PasswordStatus.loading));

    try {
      await repository.updateUserPassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );

      emit(state.copyWith(
        passwordStatus: PasswordStatus.success,
      ));

    } catch (e) {
      print(e);
      emit(state.copyWith(
        passwordStatus: PasswordStatus.failure,
      ));
    }
  }
  void _onUpdateProfileEvent(
      UpdateProfileEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading));

    try {
      await repository.updateUserProfile(
        signupModel: event.signupModel,
      );

      if (event.signupModel.email != FirebaseAuth.instance.currentUser?.email) {
        emit(state.copyWith(
          signupStatus: SignupStatus.emailVerificationSent,
        ));
      } else {
        emit(state.copyWith(signupStatus: SignupStatus.success));
      }

    } catch (e) {
      print("----------------------------------------------------${e}-----------------------------------------");
      emit(state.copyWith(
        signupStatus: SignupStatus.failure,
      ));
    }
  }

  void _onLoadCurrentUser(LoadCurrentUser event, Emitter<AuthState> emit) async{
    print("AuthBloc: Loading user for lang: $_currentLang");
    final user = await repository.getCurrentUserDetails(langCode: _currentLang);
    emit(state.copyWith(currentUser: user));
    print("AuthBloc: User loaded - Name: ${user?.name}");
  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    String? userId = await SharedPrefsHelper.getUserId();

    await repository.logout();

    if (userId != null) {
      await SharedPrefsHelper.logout(userId);
    }

    // Reset the state entirely on logout
    emit(const AuthState(loginStatus: LoginStatus.logout));
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

      // We start with initial biometric status even if enabled in prefs,
      // so the user actually has to interact with the Fingerprint screen.
      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
          biometricStatus: BiometricStatus.initial,
          loginModel: event.loginModel,
        ),
      );
      add(LoadCurrentUser());
    } catch (e) {
      emit(state.copyWith(loginStatus: LoginStatus.failure));
    }
  }

  void _onGoogleLoginEvent(GoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      final result = await repository.signInWithGoogle();
      if (result != null) {
        emit(state.copyWith(
          loginStatus: LoginStatus.success,
          biometricStatus: BiometricStatus.initial,
        ));
        add(LoadCurrentUser());
      } else {
        emit(state.copyWith(loginStatus: LoginStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(loginStatus: LoginStatus.failure));
    }
  }

  void _onSignUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading));

    try {
      final user = await repository.signUp(signupModel: event.signupModel);

      emit(
        state.copyWith(
          signupStatus: SignupStatus.success,
          biometricStatus: BiometricStatus.initial, // Reset for new user
          signupModel: event.signupModel.copyWith(uid: user?.uid ?? ""),
        ),
      );
      add(LoadCurrentUser());
    } catch (e) {
      emit(state.copyWith(signupStatus: SignupStatus.failure));
    }
  }


 void selectedRoleMethod(SelectRoleEvent event,emit){
   emit(state.copyWith(selectedRole: event.role));
 }
}
