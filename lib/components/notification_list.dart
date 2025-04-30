import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/models/notification.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/notification_service.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final NotificationService _notificationService = NotificationService();

  NotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    final userID = notifications.isNotEmpty ? notifications.first.userID : null;

    return Container(
      height: 400,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notifications",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          if (notifications.isEmpty)
            const Center(child: Text("No new notifications")),

          if (notifications.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    title: Text(notification.message),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        _notificationService.markNotificationAsRead(notification.id);
                      },
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 10),
          if (userID != null)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // _notificationService.markAllAsRead(userID);
                },
                child: const Text("Mark All as Read"),
              ),
            ),
        ],
      ),
    );
  }
}