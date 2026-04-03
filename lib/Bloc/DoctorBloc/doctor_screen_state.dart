import 'package:equatable/equatable.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Data/appointment_model.dart';
import 'package:skin_firts/Global/enums.dart';
import '../../Global/dummy_data.dart';

class DoctorScreenState extends Equatable {
  final int selectedIndex;
  final DoctorStatus doctorStatus;
  final DoctorFilter selectedFilter;
  final bool isTab;
  final List<bool> switches;
  final List<AddDoctor> getDoctor;
  final AddDoctor? doctorDetails;
  final List<ServiceModel> service;
  final bool isPasswordHidden;
  final int selectedDateIndex;
  final String selectedTime;
  final String selectedPatient;
  final String selectedGender;
  final String? selectedCancelReason;
  final String addDoctorGender;
  final bool addDoctorIsLiked;
  final Set<String> expandedServiceTitles;
  final String selectedPaymentMethod;
  final int selectedAppointmentTabIndex;
  final List<AppointmentModel> appointments;
  final DoctorStatus appointmentStatus;
  final AppointmentModel? lastBookedAppointment;

  const DoctorScreenState({
    this.service = const [],
    this.selectedIndex = -1,
    this.getDoctor = const [],
    this.doctorStatus = DoctorStatus.initial,
    this.doctorDetails,
    this.selectedFilter = DoctorFilter.none,
    this.isTab = true,
    this.isPasswordHidden = true,
    this.selectedDateIndex = 0,
    this.selectedTime = "10:00 AM",
    this.selectedPatient = "Yourself",
    this.selectedGender = "Female",
    this.selectedCancelReason,
    this.addDoctorGender = 'Male',
    this.addDoctorIsLiked = false,
    this.switches = const [false, false, true, false, false, true, true, true],
    this.expandedServiceTitles = const {},
    this.selectedPaymentMethod = "Add New Card",
    this.selectedAppointmentTabIndex = 1,
    this.appointments = const [],
    this.appointmentStatus = DoctorStatus.initial,
    this.lastBookedAppointment,
  });

  DoctorScreenState copyWith({
    int? selectedIndex,
    DoctorStatus? doctorStatus,
    DoctorFilter? selectedFilter,
    bool? isTab,
    List<AddDoctor>? getDoctor,
    AddDoctor? doctorDetails,
    List<ServiceModel>? service,
    List<bool>? switches,
    bool? isPasswordHidden,
    int? selectedDateIndex,
    String? selectedTime,
    String? selectedPatient,
    String? selectedGender,
    String? selectedCancelReason,
    String? addDoctorGender,
    bool? addDoctorIsLiked,
    Set<String>? expandedServiceTitles,
    String? selectedPaymentMethod,
    int? selectedAppointmentTabIndex,
    List<AppointmentModel>? appointments,
    DoctorStatus? appointmentStatus,
    AppointmentModel? lastBookedAppointment,
  }) {
    return DoctorScreenState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isTab: isTab ?? this.isTab,
      doctorStatus: doctorStatus ?? this.doctorStatus,
      getDoctor: getDoctor ?? this.getDoctor,
      doctorDetails: doctorDetails ?? this.doctorDetails,
      service: service ?? this.service,
      switches: switches ?? this.switches,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedCancelReason: selectedCancelReason ?? this.selectedCancelReason,
      addDoctorGender: addDoctorGender ?? this.addDoctorGender,
      addDoctorIsLiked: addDoctorIsLiked ?? this.addDoctorIsLiked,
      expandedServiceTitles: expandedServiceTitles ?? this.expandedServiceTitles,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedAppointmentTabIndex: selectedAppointmentTabIndex ?? this.selectedAppointmentTabIndex,
      appointments: appointments ?? this.appointments,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      lastBookedAppointment: lastBookedAppointment ?? this.lastBookedAppointment,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    selectedFilter,
    isTab,
    doctorStatus,
    getDoctor,
    doctorDetails,
    service,
    switches,
    isPasswordHidden,
    selectedDateIndex,
    selectedTime,
    selectedPatient,
    selectedGender,
    selectedCancelReason,
    addDoctorGender,
    addDoctorIsLiked,
    expandedServiceTitles,
    selectedPaymentMethod,
    selectedAppointmentTabIndex,
    appointments,
    appointmentStatus,
    lastBookedAppointment,
  ];
}
