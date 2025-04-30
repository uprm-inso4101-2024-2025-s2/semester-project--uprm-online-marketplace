import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesterprojectuprmonlinemarketplace/models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String notificationsCollection = "notifications";

  // Fetch all notifications for a user — no filters = no index needed
  Stream<List<NotificationModel>> getUserNotifications(String userID) {
    return _firestore
        .collection(notificationsCollection)
        .where("userID", isEqualTo: userID)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add a new notification
  Future<void> addNotification(String userID, String message) async {
    await _firestore.collection(notificationsCollection).add({
      "userID": userID,
      "message": message,
      "timestamp": Timestamp.now(),
      "isRead": false,
    });
  }

  // Mark one as read
  Future<void> markNotificationAsRead(String notificationID) async {
    await _firestore
        .collection(notificationsCollection)
        .doc(notificationID)
        .update({"isRead": true});
  }
}