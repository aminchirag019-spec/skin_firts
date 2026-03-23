import 'package:skin_firts/Data/dotor_model.dart';

class NotificationEvent {}

class SendNotificationEvent extends NotificationEvent {
  final AddDoctor doctor;
  final NotificationModel notificationModel;

  SendNotificationEvent(this.doctor, this.notificationModel);
}

class GetNotificationEvent extends NotificationEvent {}
