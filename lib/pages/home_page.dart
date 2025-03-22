import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_drawer.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/user_tile.dart';
import 'package:semesterprojectuprmonlinemarketplace/pages/chat_page.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/chat/chat_services.dart';
import 'package:semesterprojectuprmonlinemarketplace/providers/notification_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          _buildNotificationIcon(context), // ✅ Notification icon in AppBar
        ],
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // ✅ Notification Icon (bell + unread count)
  Widget _buildNotificationIcon(BuildContext context) {
    String currentUserID = _authService.getCurrentUser()!.uid;

    return Consumer<NotificationProvider>(
      builder: (context, notifier, child) {
        int unreadCount = notifier.getUnreadCountForUser(currentUserID);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                _showNotificationPreview(context, notifier);
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 30, // ✅ Moves badge to the left
                top: 10,
                child: CircleAvatar(
                  radius: 9, // ✅ Adjusted size
                  backgroundColor: Colors.red,
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ✅ Shows Notification Preview When Bell is Clicked
  void _showNotificationPreview(BuildContext context, NotificationProvider notifier) {
    String currentUserID = _authService.getCurrentUser()!.uid;
    List<Map<String, dynamic>> userNotifications =
        notifier.getNotificationsForUser(currentUserID);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // ✅ If no notifications, show "No new notifications"
            if (userNotifications.isEmpty)
              const Center(child: Text("No new notifications", style: TextStyle(fontSize: 16))),

            // ✅ Show notifications for logged-in user only
            Expanded(
              child: ListView.builder(
                itemCount: userNotifications.length,
                itemBuilder: (context, index) {
                  final notification = userNotifications[index];
                  return ListTile(
                    title: Text(
                      "${notification['count']} new messages from ${notification['senderEmail']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    leading: const Icon(Icons.mark_chat_unread),
                  );
                },
              ),
            ),

            // ✅ Mark all as read button (Clears only **this user's notifications**)
            ElevatedButton(
              onPressed: () {
                notifier.markAllAsRead(currentUserID); // ✅ Pass current user ID
                Navigator.pop(context);
              },
              child: const Text("Mark all as read"),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ List of Users
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatServices.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) return const Text("Loading...");

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // ✅ Chat User List Item
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
