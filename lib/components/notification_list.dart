import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/models/notification.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/notification_service.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final NotificationService _notificationService = NotificationService();

  NotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text("Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.message),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      _notificationService.markNotificationAsRead(notification.id);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _notificationService.markAllAsRead(notifications.first.userID);
            },
            child: Text("Mark All as Read"),
          ),
        ],
      ),
    );
  }
}
