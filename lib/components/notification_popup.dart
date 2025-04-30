// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:semesterprojectuprmonlinemarketplace/components/notification_list.dart';
// import 'package:semesterprojectuprmonlinemarketplace/services/notification_service.dart';
// import 'package:semesterprojectuprmonlinemarketplace/models/notification.dart';

// class NotificationPopup extends StatelessWidget {
//   final NotificationService _notificationService = NotificationService();

//   NotificationPopup({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String userID = FirebaseAuth.instance.currentUser!.uid;

//     return StreamBuilder<List<NotificationModel>>(
//       stream: _notificationService.getUserNotifications(userID),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text('Something went wrong'));
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final notifications = snapshot.data ?? [];

//         return NotificationList(notifications: notifications);
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationPopup extends StatelessWidget {
  const NotificationPopup({super.key});

  Stream<QuerySnapshot> getUserNotifications() {
    final String userID = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userID', isEqualTo: userID)
        .where('isRead', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: getUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return const Center(
              child: Text('No new notifications'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data = notifications[index].data() as Map<String, dynamic>;
              final email = data['message'] ?? 'New Message';

              return ListTile(
                title: Text(email, style: const TextStyle(fontSize: 16)),
              );
            },
          );
        },
      ),
    );
  }
}