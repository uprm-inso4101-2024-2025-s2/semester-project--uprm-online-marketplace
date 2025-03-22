import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesterprojectuprmonlinemarketplace/models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String notificationsCollection = "notifications";

  // Fetch notifications for a user
  Stream<List<NotificationModel>> getUserNotifications(String userID) {
    return _firestore
        .collection(notificationsCollection)
        .where("userID", isEqualTo: userID)
        .where("isRead", isEqualTo: false) // Only show unread notifications
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add a notification
  Future<void> addNotification(String userID, String message) async {
    await _firestore.collection(notificationsCollection).add({
      "userID": userID,
      "message": message,
      "timestamp": Timestamp.now(),
      "isRead": false,
    });
  }

  // Mark a notification as read
  Future<void> markNotificationAsRead(String notificationID) async {
    await _firestore
        .collection(notificationsCollection)
        .doc(notificationID)
        .update({"isRead": true});
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userID) async {
    final query = await _firestore
        .collection(notificationsCollection)
        .where("userID", isEqualTo: userID)
        .where("isRead", isEqualTo: false)
        .get();

    for (var doc in query.docs) {
      await doc.reference.update({"isRead": true});
    }
  }
}
