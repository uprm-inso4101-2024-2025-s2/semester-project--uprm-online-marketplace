import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id; // This is only used locally, not stored in Firestore
  final String userID;
  final String message;
  final Timestamp timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userID,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  // Only save relevant fields to Firestore (not the document ID)
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  // Factory constructor to build from Firestore + document ID
  factory NotificationModel.fromMap(Map<String, dynamic> map, String docID) {
    return NotificationModel(
      id: docID,
      userID: map['userID'],
      message: map['message'],
      timestamp: map['timestamp'],
      isRead: map['isRead'],
    );
  }
}