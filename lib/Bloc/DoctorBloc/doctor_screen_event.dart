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