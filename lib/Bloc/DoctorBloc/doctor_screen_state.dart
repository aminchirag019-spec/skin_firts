import 'package:equatable/equatable.dart';
import 'package:skin_firts/Data/dotor_model.dart';
import 'package:skin_firts/Global/enums.dart';
import '../../Global/dummy_data.dart';

class DoctorScreenState extends Equatable {
  final int selectedIndex;
  final DoctorStatus doctorStatus;
  final List<DummyData> likedDoctors;
  final List<DummyData> doctors;
  final DoctorFilter selectedFilter;
  final bool isTab;
  final List<AddDoctor> getDoctor;
  final AddDoctor? doctorDetails;
  final List<ServiceModel> service;



  const DoctorScreenState({
    this.service = const [],
    this.selectedIndex = -1,
    this.getDoctor = const [],
    this.doctorStatus = DoctorStatus.initial,
    this.doctors = const [],
    this.doctorDetails,
    this.selectedFilter = DoctorFilter.none,
    this.likedDoctors = const [],
    this.isTab = true,
  });

  DoctorScreenState copyWith({
    int? selectedIndex,
    DoctorStatus? doctorStatus,
    List<DummyData>? doctors,
    DoctorFilter? selectedFilter,
    List<DummyData>? likedDoctors,
    bool? isTab,
    List<AddDoctor>? getDoctor,
    AddDoctor? doctorDetails,
    List<ServiceModel>? service,
  }) {
    return DoctorScreenState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      doctors: doctors ?? this.doctors,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      likedDoctors: likedDoctors ?? this.likedDoctors,
      isTab: isTab ?? this.isTab,
      doctorStatus: doctorStatus ?? this.doctorStatus,
      getDoctor: getDoctor ?? this.getDoctor,
      doctorDetails: doctorDetails ?? this.doctorDetails,
      service: service ?? this.service,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, doctors, selectedFilter,likedDoctors,isTab,doctorStatus,getDoctor,doctorDetails,service];
}