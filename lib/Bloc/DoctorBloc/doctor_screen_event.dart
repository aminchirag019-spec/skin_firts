import '../../Data/doctor_model.dart';
import '../../Global/dummy_data.dart';

class DoctorScreenEvent {}

class FilterChangedEvent extends DoctorScreenEvent {
  final int index;
  final DoctorFilter filter;

  FilterChangedEvent(this.index, this.filter);
}

class ApplyFilters extends DoctorScreenEvent {
  final String? sortBy;
  final bool? liked;
  final String? gender;

  ApplyFilters({this.sortBy, this.liked, this.gender});
}

class LikedEvent extends DoctorScreenEvent {
  final String doctorId;
  final bool isLiked;

  LikedEvent(this.doctorId, this.isLiked);
}

class TabEvent extends DoctorScreenEvent {
  final bool isTab;

  TabEvent({this.isTab = true});
}

class AddDoctorEvent extends DoctorScreenEvent {
  final AddDoctor addDoctor;

  AddDoctorEvent(this.addDoctor);
}

class GetDoctorEvent extends DoctorScreenEvent {}

class GetDoctorDetailsEvent extends DoctorScreenEvent {
  final String doctorUid;

  GetDoctorDetailsEvent(this.doctorUid);
}

class GetServiceEvent extends DoctorScreenEvent {}

class SwitchEvent extends DoctorScreenEvent {
  final int index;
  final bool isSwitched;

  SwitchEvent({required this.index, required this.isSwitched});
}

class TogglePasswordVisibility extends DoctorScreenEvent {}
