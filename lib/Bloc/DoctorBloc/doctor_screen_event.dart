import '../../Global/dummy_data.dart';

class DoctorScreenEvent {}

class FilterChangedEvent extends DoctorScreenEvent{
  final int index;

  FilterChangedEvent(this.index);
}

class ApplyFilters extends DoctorScreenEvent {
  final DoctorFilter filter;

  ApplyFilters(this.filter);
}
