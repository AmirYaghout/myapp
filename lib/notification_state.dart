import "package:myapp/notification_item.dart";

abstract class NotificationState {}

class NotificationsInitial extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationItem> notifications;
  NotificationsLoaded(this.notifications);
}

class NotificationSeen extends NotificationState {
  final List<NotificationItem> notifications;
  NotificationSeen(this.notifications);
}

class NotificationDeleted extends NotificationState {
  final List<NotificationItem> notifications;
  NotificationDeleted(this.notifications);
}
