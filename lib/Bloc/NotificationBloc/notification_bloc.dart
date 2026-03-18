import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_event.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_state.dart';
import 'package:skin_firts/Global/dummy_data.dart';
import 'package:skin_firts/Network/auth_repository.dart';
import 'package:skin_firts/Utilities/firebase_message.dart';

import '../../Global/enums.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AuthRepository repository;
  NotificationBloc(this.repository) : super(NotificationState()) {
    on<SendNotificationEvent>(_onSendNotificationEvent);
    on<GetNotificationEvent>(_onGetNotificationEvent);
  }

  void _onGetNotificationEvent(
    GetNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(notificationStatus: NotificationStatus.loading));

      final notifications = await repository.getNotifications();

      emit(
        state.copyWith(
          notifications: notifications,
          notificationStatus: NotificationStatus.success,
        ),
      );

      print("Notifications fetched successfully");
    } catch (e) {
      print("${e}");
      emit(state.copyWith(notificationStatus: NotificationStatus.failure));

      print("Error fetching notifications: $e");
    }
  }

  void _onSendNotificationEvent(
    SendNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.storeNotification(
        notificationModel: event.notificationModel,
      );
      NotificationService.showNotification(
        "Add Doctor",
        "You successfully added a ${event.doctor.doctorName}",
      );
    } catch (e) {
      NotificationService.showNotification("Error", "Something went wrong");
    }
  }
}
