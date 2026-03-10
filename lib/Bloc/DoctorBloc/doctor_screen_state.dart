import 'package:equatable/equatable.dart';
import '../../Global/dummy_data.dart';

class DoctorScreenState extends Equatable {
  final int selectedIndex;
  final List<DummyData> likedDoctors;
  final List<DummyData> doctors;
  final DoctorFilter selectedFilter;
  final bool isTab;


  const DoctorScreenState({
    this.selectedIndex = -1,
    this.doctors = const [],
    this.selectedFilter = DoctorFilter.none,
    this.likedDoctors = const [],
    this.isTab = true,
  });

  DoctorScreenState copyWith({
    int? selectedIndex,
    List<DummyData>? doctors,
    DoctorFilter? selectedFilter,
    List<DummyData>? likedDoctors,
    bool? isTab,
  }) {
    return DoctorScreenState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      doctors: doctors ?? this.doctors,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      likedDoctors: likedDoctors ?? this.likedDoctors,
      isTab: isTab ?? this.isTab,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, doctors, selectedFilter,likedDoctors,isTab];
}