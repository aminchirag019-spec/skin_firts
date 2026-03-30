import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import 'package:skin_firts/Bloc/LocaleBloc/locale_bloc.dart';
import 'package:skin_firts/Bloc/LocaleBloc/locale_state.dart';

import '../../Data/doctor_model.dart';
import '../../Global/dummy_data.dart';
import '../../Helper/firebase_message.dart';
import 'doctor_screen_event.dart';
import 'doctor_screen_state.dart';

class DoctorScreenBloc extends Bloc<DoctorScreenEvent, DoctorScreenState> {
  final NotificationService notificationService;
  final AuthRepository authRepository;
  final LocaleBloc localeBloc;
  StreamSubscription? _localeSubscription;

  DoctorScreenBloc(this.authRepository, this.notificationService, this.localeBloc)
    : super(DoctorScreenState()) {
    
    // 🌐 Automatically re-fetch data when language changes
    _localeSubscription = localeBloc.stream.listen((localeState) {
      add(GetDoctorEvent());
      add(GetServiceEvent());
    });

    on<FilterChangedEvent>(_onFilterChange);
    on<ApplyFilters>(_onApplyFilters);
    on<LikedEvent>(_onLiked);
    on<TabEvent>(_onTab);
    on<AddDoctorEvent>(_onAddDoctor);
    on<GetDoctorEvent>(_onGetDoctor);
    on<GetDoctorDetailsEvent>(_onGetDoctorDetails);
    on<GetServiceEvent>(_onGetServiceEvent);
    on<SwitchEvent>(_onSwitch);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<SelectDateEvent>(_onSelectDate);
  }

  String get _currentLang => localeBloc.state.locale.languageCode;

  @override
  Future<void> close() {
    _localeSubscription?.cancel();
    return super.close();
  }

  void _onSelectDate(SelectDateEvent event, Emitter<DoctorScreenState> emit) {
    emit(state.copyWith(selectedDateIndex: event.index));
  }

  void _onTogglePasswordVisibility(TogglePasswordVisibility event, Emitter<DoctorScreenState> emit) {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void _onSwitch(SwitchEvent event, Emitter<DoctorScreenState> emit) async {
    final updatedSwitches = List<bool>.from(state.switches);
    updatedSwitches[event.index] = event.isSwitched;
    emit(state.copyWith(switches: updatedSwitches));
  }

  void _onGetServiceEvent(GetServiceEvent event, Emitter<DoctorScreenState> emit) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));
    try {
      final serviceDetails = await authRepository.getServices(langCode: _currentLang);
      emit(state.copyWith(doctorStatus: DoctorStatus.success, service: serviceDetails));
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }

  void _onGetDoctorDetails(GetDoctorDetailsEvent event, Emitter<DoctorScreenState> emit) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));
    try {
      final doctorDetails = await authRepository.getDoctorByUid(event.doctorUid, langCode: _currentLang);
      emit(state.copyWith(doctorStatus: DoctorStatus.success, doctorDetails: doctorDetails));
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }

  void _onGetDoctor(GetDoctorEvent event, Emitter<DoctorScreenState> emit) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));
    try {
      final doctors = await authRepository.getDoctors(langCode: _currentLang);
      emit(state.copyWith(doctorStatus: DoctorStatus.success, getDoctor: doctors));
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }

  void _onAddDoctor(AddDoctorEvent event, Emitter<DoctorScreenState> emit) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));
    try {
      await authRepository.addDoctor(addDoctorModel: event.addDoctor);
      add(GetDoctorEvent());
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }

  void _onTab(TabEvent event, Emitter<DoctorScreenState> emit) {
    emit(state.copyWith(isTab: event.isTab));
  }

  void _onLiked(LikedEvent event, Emitter<DoctorScreenState> emit) async {
    await authRepository.likedDoctor(event.doctorId, event.isLiked);
    add(ApplyFilters(
      sortBy: state.selectedFilter == DoctorFilter.sortBy ? "A->Z" : null,
      liked: state.selectedFilter == DoctorFilter.liked ? true : null,
    ));
  }

  void _onFilterChange(FilterChangedEvent event, Emitter<DoctorScreenState> emit) {
    emit(state.copyWith(selectedIndex: event.index, selectedFilter: event.filter));
  }

  void _onApplyFilters(ApplyFilters event, Emitter<DoctorScreenState> emit) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));
    try {
      final doctors = await authRepository.getDoctors(
        sortBy: event.sortBy,
        liked: event.liked,
        gender: event.gender,
        langCode: _currentLang,
      );
      emit(state.copyWith(doctorStatus: DoctorStatus.success, getDoctor: doctors));
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }
}
