abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class MarkAsSeen extends NotificationEvent {
  final int notificationId;
  MarkAsSeen(this.notificationId);
}

class DeleteNotification extends NotificationEvent {
  final int notificationId;
  DeleteNotification(this.notificationId);
}
