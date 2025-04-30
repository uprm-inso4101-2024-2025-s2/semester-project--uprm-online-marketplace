import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// ✅ Formats a DateTime into a friendly string like '5m ago', 'Yesterday', etc.
String formatTimestamp(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays}d ago';
  return DateFormat.yMMMd().format(date);
}

/// ✅ Returns true if the message hasn't been read (used in unread indicators)
bool isMessageUnread(Map<String, dynamic> messageData, String currentUserID) {
  return messageData['receiverID'] == currentUserID && !(messageData['read'] ?? false);
}

/// ✅ Returns true if the message can still be edited (within 5-minute window)
bool canEditMessage(DateTime timestamp) {
  return DateTime.now().difference(timestamp).inMinutes < 5;
}

/// ✅ Groups messages by formatted date (e.g., April 30, 2025)
Map<String, List<QueryDocumentSnapshot>> groupMessagesByDate(List<QueryDocumentSnapshot> messages) {
  final Map<String, List<QueryDocumentSnapshot>> grouped = {};

  for (var doc in messages) {
    final date = (doc['timestamp'] as Timestamp).toDate();
    final key = DateFormat.yMMMMd().format(date);
    grouped.putIfAbsent(key, () => []).add(doc);
  }

  return grouped;
}