import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import 'notification_item.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationsInitial()) {
    // Registering the event handlers in the constructor
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsSeen>(_onMarkAsSeen);
    on<DeleteNotification>(_onDeleteNotification);
  }

  // Event handler for loading notifications
  void _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) {
    emit(NotificationsLoaded(_mockNotifications()));
  }

  // Event handler for marking notifications as seen
  void _onMarkAsSeen(MarkAsSeen event, Emitter<NotificationState> emit) {
    if (state is NotificationsLoaded) {
      final updatedNotifications = (state as NotificationsLoaded)
          .notifications
          .map((notification) => notification.id == event.notificationId
              ? notification.copyWith(seen: true)
              : notification)
          .toList();
      emit(NotificationsLoaded(updatedNotifications));
    }
  }

  // Event handler for deleting notifications
  void _onDeleteNotification(
      DeleteNotification event, Emitter<NotificationState> emit) {
    if (state is NotificationsLoaded) {
      final updatedNotifications = (state as NotificationsLoaded)
          .notifications
          .where((notification) => notification.id != event.notificationId)
          .toList();
      emit(NotificationsLoaded(updatedNotifications));
    }
  }

  // Mock data for notifications
  List<NotificationItem> _mockNotifications() {
    return [
      NotificationItem(
          id: 1,
          title: 'New Message',
          description: 'You have a new message.',
          type: NotificationType.message),
      NotificationItem(
          id: 2,
          title: 'Friend Request',
          description: 'You have a new friend request.',
          type: NotificationType.friendRequest),
      NotificationItem(
          id: 3,
          title: 'Reminder',
          description: 'Meeting at 3 PM.',
          type: NotificationType.reminder),
    ];
  }
}
