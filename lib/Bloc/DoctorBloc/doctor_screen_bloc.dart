
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Global/dummy_data.dart';

import 'doctor_screen_event.dart';
import 'doctor_screen_state.dart';

class DoctorScreenBloc extends Bloc<DoctorScreenEvent, DoctorScreenState>{
  final List<DummyData> allDoctors = doctors;
  DoctorScreenBloc() : super(DoctorScreenState()) {
    on<FilterChangedEvent>(_onFilterChange);
    on<ApplyFilters>(_onApplyFilters);
  }

  void _onFilterChange(FilterChangedEvent event, Emitter<DoctorScreenState> emit) {
    emit(state.copyWith(
      selectedIndex: event.index
    ));
  }

  void _onApplyFilters(ApplyFilters event, Emitter<DoctorScreenState> emit) {

    List<DummyData> filteredDoctors = [];

    switch (event.filter) {

      case DoctorFilter.rating:
        filteredDoctors =
            allDoctors.where((d) => d.rating >= 4).toList();
        break;

      case DoctorFilter.liked:
        filteredDoctors =
            allDoctors.where((d) => d.isLiked).toList();
        break;

      case DoctorFilter.female:
        filteredDoctors =
            allDoctors.where((d) => d.gender == "Female").toList();
        break;

      case DoctorFilter.male:
        filteredDoctors =
            allDoctors.where((d) => d.gender == "Male").toList();
        break;

      case DoctorFilter.none:
        filteredDoctors = allDoctors;
        break;
    }
    emit(state.copyWith(
      doctors: filteredDoctors,
      selectedFilter: event.filter
    ));
  }


}