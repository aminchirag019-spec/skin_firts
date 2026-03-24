import 'package:skin_firts/Data/doctor_model.dart';

class NotificationEvent {}

class SendNotificationEvent extends NotificationEvent {
  final AddDoctor doctor;
  final NotificationModel notificationModel;

  SendNotificationEvent(this.doctor, this.notificationModel);
}

class GetNotificationEvent extends NotificationEvent {}
class ChatNotificationEvent extends NotificationEvent{
  final String message;
  ChatNotificationEvent(this.message);
}
