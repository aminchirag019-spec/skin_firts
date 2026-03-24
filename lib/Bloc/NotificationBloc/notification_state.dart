import 'package:equatable/equatable.dart';

import '../../Data/doctor_model.dart';
import '../../Global/enums.dart';

class NotificationState extends Equatable {
  List<AddDoctor>? doctorDetails;
  final List<NotificationModel> notifications;
  final NotificationStatus notificationStatus;
  final MessageStatus? messageStatus;

  NotificationState({
    this.doctorDetails,
    this.notifications = const [],
    this.notificationStatus = NotificationStatus.initial,
    this.messageStatus = MessageStatus.initial,
  });

  NotificationState copyWith({
    List<AddDoctor>? doctorDetails,
    List<NotificationModel>? notifications,
    NotificationStatus? notificationStatus,
    MessageStatus? messageStatus,
  }) {
    return NotificationState(
      doctorDetails: doctorDetails ?? this.doctorDetails,
      notifications: notifications ?? this.notifications,
      notificationStatus: notificationStatus ?? this.notificationStatus,
      messageStatus: messageStatus ?? this.messageStatus,
    );
  }

  @override
  List<Object> get props => [?doctorDetails, notifications, notificationStatus, ?messageStatus];
}
