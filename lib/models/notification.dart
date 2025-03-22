import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

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
