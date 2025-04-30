import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semesterprojectuprmonlinemarketplace/models/notification.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/notification_service.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final String userID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _notificationService.getUserNotifications(userID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text("No new notifications"));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return ListTile(
                leading: const Icon(Icons.mark_email_unread),
                title: Text(notification.message),
                subtitle: Text(
                  notification.timestamp.toDate().toString().split(".")[0],
                ),
                trailing: notification.isRead
                    ? null
                    : const Icon(Icons.fiber_new, color: Colors.redAccent),
                onTap: () {
                  _notificationService.markNotificationAsRead(notification.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}