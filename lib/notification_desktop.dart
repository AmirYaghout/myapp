import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_bloc.dart';
import 'notification_state.dart';
import 'notification_item.dart';
import 'notification_detail_page.dart';
import 'notification_event.dart';

class NotificationDesktop extends StatefulWidget {
  @override
  _NotificationDesktopState createState() => _NotificationDesktopState();
}

class _NotificationDesktopState extends State<NotificationDesktop> {
  bool _showNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Desktop'),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              int notificationCount = 0;

              if (state is NotificationsLoaded) {
                notificationCount = state.notifications
                    .where((notification) => !notification.seen)
                    .length; // Only count unseen notifications
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(_showNotifications ? Icons.close : Icons.notifications),
                    onPressed: () {
                      setState(() {
                        _showNotifications = !_showNotifications;
                      });
                    },
                  ),
                  // Show the badge only if there are notifications
                  if (notificationCount > 0)
                    Positioned(
                      right: 5, // Adjust position to top-right corner
                      top: 5,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle, // Circular badge
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            notificationCount > 99 ? '99+' : '$notificationCount', // Display '99+' if count > 99
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10, // Small font to fit inside the badge
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(child: Text('Desktop Notification Manager')),
          if (_showNotifications)
            Positioned(
              right: 20,
              top: 18, // Adjusted to reduce space
              child: NotificationDropdown(), // Dropdown to show notifications
            ),
        ],
      ),
    );
  }
}

class NotificationDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          return Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true, // Make the list fit the size of the items
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationCard(notification: notification);
              },
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class NotificationCard extends StatefulWidget {
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isHovered = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true; // Show buttons on hover
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false; // Hide buttons when hover ends
        });
      },
      child: Stack(
        children: [
          ListTile(
            leading: Icon(notificationIcon(widget.notification.type)),
            title: Text(
              widget.notification.title,
              style: TextStyle(
                color: widget.notification.seen ? Colors.grey : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.notification.description,
              style: TextStyle(
                color: widget.notification.seen ? Colors.grey : Colors.black87,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NotificationDetailPage(widget.notification),
              ));
            },
          ),
          if (_isHovered)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility, color: Colors.green),
                        onPressed: () {
                          context.read<NotificationBloc>().add(MarkAsSeen(widget.notification.id));
                        },
                        tooltip: 'Mark as Seen',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<NotificationBloc>().add(DeleteNotification(widget.notification.id));
                        },
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ),
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
