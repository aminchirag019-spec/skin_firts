import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Global/dummy_data.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Network/auth_repository.dart';

import '../../Data/dotor_model.dart';
import 'doctor_screen_event.dart';
import 'doctor_screen_state.dart';

class DoctorScreenBloc extends Bloc<DoctorScreenEvent, DoctorScreenState> {
  List<DummyData> allDoctors = doctors;
  final AuthRepository authRepository;

  DoctorScreenBloc(this.authRepository)
      : super(DoctorScreenState()) {
    on<FilterChangedEvent>(_onFilterChange);
    on<ApplyFilters>(_onApplyFilters);
    on<LikedEvent>(_onLiked);
    on<TabEvent>(_onTab);
    on<AddDoctorEvent>(_onAddDoctor);
    on<GetDoctorEvent>(_onGetDoctor);
    on<GetDoctorDetailsEvent>(_onGetDoctorDetails);
    on<GetServiceEvent>(_onGetServiceEvent);
  }

  void _onGetServiceEvent(GetServiceEvent event,
      Emitter<DoctorScreenState> emit,) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));
    try {
      final serviceDetails = await authRepository.getServices();
      if (serviceDetails != null) {
        emit(state.copyWith(
            doctorStatus: DoctorStatus.success, service: serviceDetails));
      } else {
        emit(state.copyWith(doctorStatus: DoctorStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }

  void _onGetDoctorDetails(GetDoctorDetailsEvent event,
      Emitter<DoctorScreenState> emit,) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));
    try {
      final doctorDetails = await authRepository.getDoctorByUid(
          event.doctorUid);
      if (doctorDetails != null) {
        emit(state.copyWith(
            doctorStatus: DoctorStatus.success, doctorDetails: doctorDetails));
      } else {
        emit(state.copyWith(doctorStatus: DoctorStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }


  void _onGetDoctor(GetDoctorEvent event,
      Emitter<DoctorScreenState> emit,) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));

    try {
      final doctors = await authRepository.getDoctors();

      emit(
        state.copyWith(doctorStatus: DoctorStatus.success, getDoctor: doctors),
      );
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }

  void _onAddDoctor(AddDoctorEvent event,
      Emitter<DoctorScreenState> emit,) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));

    try {
      await authRepository.addDoctor(addDoctorModel: event.addDoctor);

      final doctors = await authRepository.getDoctors(sortBy: "A->Z");

      emit(
        state.copyWith(doctorStatus: DoctorStatus.success, getDoctor: doctors),
      );
    } catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }
  }

  void _onTab(TabEvent event, Emitter<DoctorScreenState> emit) {
    emit(state.copyWith(isTab: event.isTab));
  }

  void _onLiked(LikedEvent event, Emitter<DoctorScreenState> emit)  async{

    await authRepository.likedDoctor(event.doctorId,event.isLiked);

    add(ApplyFilters(
      sortBy: state.selectedFilter == DoctorFilter.sortBy
          ? "A->Z" : null,
      liked: state.selectedFilter == DoctorFilter.liked ? true : null,
      gender: null,
    ));

 }

  void _onFilterChange(FilterChangedEvent event,
      Emitter<DoctorScreenState> emit,) {
    emit(state.copyWith(selectedIndex: event.index,
    selectedFilter: event.filter,
    ));
  }

  void _onApplyFilters(ApplyFilters event, Emitter<DoctorScreenState> emit) async {
    emit(state.copyWith(doctorStatus: DoctorStatus.loading));

    try {
      final doctors = await authRepository.getDoctors(
        sortBy: event.sortBy,
        liked: event.liked,
        gender: event.gender,
      );
      emit(state.copyWith(doctorStatus: DoctorStatus.success,
      getDoctor: doctors,
      ));
    }  catch (e) {
      emit(state.copyWith(doctorStatus: DoctorStatus.failure));
    }



  }
}