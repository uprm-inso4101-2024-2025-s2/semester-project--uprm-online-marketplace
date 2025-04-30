import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semesterprojectuprmonlinemarketplace/models/message.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/notification_service.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Get users from Firestore (used to build user list)
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // ✅ Send a new message AND create a Firestore notification
  Future<void> sendMessage(String receiverID, String message) async {
    final String senderID = _auth.currentUser!.uid;
    final String senderEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    final newMessage = Message(
      senderID: senderID,
      senderEmail: senderEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

    if (senderID != receiverID) {
      await NotificationService()
          .addNotification(receiverID, "New message from $senderEmail");
    }
  }

  // ✅ Edit an existing message within a 5-minute window
  Future<void> editMessage(
      String receiverID, String messageID, String newMessage) async {
    List<String> ids = [_auth.currentUser!.uid, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    final messageRef = _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageID);

    final doc = await messageRef.get();
    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['timestamp'] as Timestamp;

    if (DateTime.now().difference(timestamp.toDate()).inMinutes < 5) {
      await messageRef.update({
        'message': newMessage,
        'edited': true,
      });
    }
  }

  // ✅ Mark a message as read
  Future<void> markMessageAsRead(String receiverID, String messageID) async {
    List<String> ids = [_auth.currentUser!.uid, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    final messageRef = _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageID);

    await messageRef.update({'read': true});
  }

  // ✅ Get all messages between two users
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}