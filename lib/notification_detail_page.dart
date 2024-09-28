import 'package:flutter/material.dart';
import 'notification_item.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationItem notification;

  NotificationDetailPage(this.notification);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notification.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.title, style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text(notification.description),
          ],
        ),
      ),
    );
  }
}
