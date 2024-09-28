import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_bloc.dart';
import 'notification_state.dart';
import 'notification_item.dart';
import 'notification_detail_page.dart';
import 'notification_event.dart';

class NotificationMobile extends StatefulWidget {
  @override
  _NotificationMobileState createState() => _NotificationMobileState();
}

class _NotificationMobileState extends State<NotificationMobile> {
  bool _showNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Mobile'),
        actions: [
          IconButton(
            icon: Icon(_showNotifications ? Icons.close : Icons.notifications),
            onPressed: () {
              if (!_showNotifications) {
                // Show bottom sheet and update state once closed
                showModalBottomSheet(
                  context: context,
                  builder: (context) => NotificationPopup(),
                ).whenComplete(() {
                  setState(() {
                    _showNotifications = false;
                  });
                });

                setState(() {
                  _showNotifications = true;
                });
              } else {
                setState(() {
                  _showNotifications = false;
                });
              }
            },
          ),
        ],
      ),
      body: Center(child: Text('Mobile Notification Manager')),
    );
  }
}

class NotificationPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return NotificationCard(notification: notification);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id.toString()), // Each notification needs a unique key
      direction: DismissDirection.endToStart, // Allow swipe only to the left
      background: Container(), // Empty background, no red or delete icon
      confirmDismiss: (direction) async {
        // Open a modal bottom sheet with buttons when swiped
        return showModalBottomSheet<bool>(
          context: context,
          builder: (_) => _SwipeActions(notification: notification),
        );
      },
      child: ListTile(
        leading: Icon(notificationIcon(notification.type)),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: notification.seen ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          notification.description,
          style: TextStyle(
            color: notification.seen ? Colors.grey : Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => NotificationDetailPage(notification)));
        },
      ),
    );
  }
}

class _SwipeActions extends StatelessWidget {
  final NotificationItem notification;

  const _SwipeActions({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              // Mark as seen
              context.read<NotificationBloc>().add(MarkAsSeen(notification.id));
              Navigator.of(context).pop(false); // Close the modal and do not delete
            },
            child: Text('Seen'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Delete the notification
              context.read<NotificationBloc>().add(DeleteNotification(notification.id));
              Navigator.of(context).pop(true); // Close the modal and confirm delete
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

IconData notificationIcon(NotificationType type) {
  switch (type) {
    case NotificationType.message:
      return Icons.message;
    case NotificationType.friendRequest:
      return Icons.person_add;
    case NotificationType.reminder:
      return Icons.alarm;
    default:
      return Icons.notification_important;
  }
}
