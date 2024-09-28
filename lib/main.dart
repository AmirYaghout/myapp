import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_bloc.dart';
import 'notification_event.dart';
import 'notification_mobile.dart';
import 'notification_desktop.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => NotificationBloc()..add(LoadNotifications()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResponsiveLayout(),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return NotificationDesktop(); // Desktop view
        } else {
          return NotificationMobile(); // Mobile view
        }
      },
    );
  }
}

