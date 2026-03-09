import 'package:equatable/equatable.dart';

import '../../Global/dummy_data.dart';

class DoctorScreenState extends Equatable {
  final int? selectedIndex;
  final List<DummyData>? doctors;
  final DoctorFilter? selectedFilter;



  const DoctorScreenState({this.selectedIndex,this.doctors,this.selectedFilter});

DoctorScreenState copyWith ({
    int? selectedIndex,
    List<DummyData>? doctors,
    DoctorFilter? selectedFilter,
}) {
  return DoctorScreenState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    doctors: doctors ?? this.doctors,
    selectedFilter: selectedFilter ?? this.selectedFilter,
  );
}





  @override
  List<Object?> get props => [
    selectedIndex,
    doctors,
    selectedFilter
  ];
}
