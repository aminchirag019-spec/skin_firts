import '../../Data/dotor_model.dart';
import '../../Global/dummy_data.dart';

class DoctorScreenEvent {}

class FilterChangedEvent extends DoctorScreenEvent{
  final int index;

  FilterChangedEvent(this.index);
}

class ApplyFilters extends DoctorScreenEvent {
  final int? index;
  final DoctorFilter? filter;

  ApplyFilters({this.filter,this.index});
}

class LikedEvent extends DoctorScreenEvent {
  final int doctorId;

  LikedEvent(this.doctorId);
}
class TabEvent extends DoctorScreenEvent {
  final bool isTab;

  TabEvent({this.isTab = true});
}

class AddDoctorEvent extends DoctorScreenEvent {
  final AddDoctor addDoctor;

  AddDoctorEvent(this.addDoctor);
}

class GetDoctorEvent extends DoctorScreenEvent{}

class GetDoctorDetailsEvent extends DoctorScreenEvent{
  final String  doctorUid;

  GetDoctorDetailsEvent(this.doctorUid);
}
class GetServiceEvent extends DoctorScreenEvent{}

