import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Global/dummy_data.dart';

import 'doctor_screen_event.dart';
import 'doctor_screen_state.dart';

class DoctorScreenBloc extends Bloc<DoctorScreenEvent, DoctorScreenState> {
   List<DummyData> allDoctors = doctors;
  DoctorScreenBloc() : super(DoctorScreenState(doctors: doctors)) {
    on<FilterChangedEvent>(_onFilterChange);
    on<ApplyFilters>(_onApplyFilters);
    on<LikedEvent>(_onLiked);
    on<TabEvent>(_onTab);
  }

  void _onTab(TabEvent event, Emitter<DoctorScreenState> emit) {

    emit(state.copyWith(isTab: event.isTab));
  }

   void _onLiked(
       LikedEvent event,
       Emitter<DoctorScreenState> emit,
       ) {
     int index = allDoctors.indexWhere((doctor) => doctor.id == event.doctorId);
     if (index != -1) {
       final doctor = allDoctors[index];

       allDoctors[index] = doctor.copyWith(
         isLiked: !doctor.isLiked,
       );
     }
     final likedDoctors = allDoctors.where((d) => d.isLiked).toList();
     List<DummyData> filteredDoctors =
     state.selectedFilter == DoctorFilter.liked
         ? likedDoctors
         : List.from(allDoctors);
     emit(
       state.copyWith(
         doctors: filteredDoctors,
         likedDoctors: likedDoctors,
       ),
     );
   }
   void _onFilterChange(
    FilterChangedEvent event,
    Emitter<DoctorScreenState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onApplyFilters(ApplyFilters event, Emitter<DoctorScreenState> emit) {
    List<DummyData> filteredDoctors = List.from(allDoctors);

    switch (event.filter) {case DoctorFilter.rating:
      filteredDoctors.sort((a, b) => b.rating.compareTo(a.rating));
      break;

      case DoctorFilter.liked:
        filteredDoctors = allDoctors.where((d) => d.isLiked).toList();
        break;

      case DoctorFilter.female:
        filteredDoctors = allDoctors.where((d) => d.gender == "Female").toList();
        break;

      case DoctorFilter.male:
        filteredDoctors = allDoctors.where((d) => d.gender == "Male").toList();
        break;

      case DoctorFilter.none:
        filteredDoctors = List.from(allDoctors);
        break;
      case null:
        throw UnimplementedError();
    }

    emit(
      state.copyWith(
          doctors: filteredDoctors,
          selectedFilter: event.filter
      ),
    );
  }
}
