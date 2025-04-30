import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/chat_bubble.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_textfield.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/chat/chat_services.dart';
import 'package:semesterprojectuprmonlinemarketplace/utils/chat_utils.dart'; // ✅ Utility import

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  String? _editingMessageID;
  String? _editingMessageText;

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      if (_editingMessageID == null) {
        await _chatServices.sendMessage(
          widget.receiverID,
          _messageController.text,
        );
      } else {
        await _chatServices.editMessage(widget.receiverID, _editingMessageID!, _messageController.text);
        setState(() {
          _editingMessageID = null;
          _editingMessageText = null;
        });
      }

      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo/white-logo.png',
              height: 115,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.receiverEmail,
                style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  height: 150,
                  child: const Center(
                    child: Text(
                      "No new messages",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo/white-logo.png',
              width: 400,
            ),
          ),
          Column(
            children: [
              Expanded(child: _buildMessageList()),
              _buildUserInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();

    bool editable = canEditMessage(dateTime); // ✅ Utility use

    if (!isCurrentUser && !(data['read'] ?? false)) {
      _chatServices.markMessageAsRead(widget.receiverID, doc.id);
    }

    final formattedTime = formatTimestamp(dateTime); // ✅ Utility use

    return GestureDetector(
      onLongPress: isCurrentUser && editable
          ? () {
              setState(() {
                _editingMessageID = doc.id;
                _editingMessageText = data['message'];
                _messageController.text = _editingMessageText!;
              });
            }
          : null,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 2),
            child: Text(formattedTime, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),
          if (data['edited'] ?? false)
            const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 2),
              child: Text("Edited", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          if (isCurrentUser && (data['read'] ?? false))
            const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 2),
              child: Text("Read", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              hintText: _editingMessageID == null ? "Type a message" : "Edit message...",
              obscureText: false,
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 48, 130, 51),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}