import 'package:flutter/material.dart';

class NotificationItem {
  final int id;
  final String title;
  final String description;
  final NotificationType type;
  bool seen;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.seen = false,
  });

  NotificationItem copyWith({bool? seen}) {
    return NotificationItem(
      id: this.id,
      title: this.title,
      description: this.description,
      type: this.type,
      seen: seen ?? this.seen,
    );
  }
}

enum NotificationType { message, friendRequest, reminder }

IconData notificationIcon(NotificationType type) {
  switch (type) {
    case NotificationType.message:
      return Icons.message;
    case NotificationType.friendRequest:
      return Icons.person_add;
    case NotificationType.reminder:
      return Icons.alarm;
    default:
      return Icons.notifications;
  }
}
