import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/chat_bubble.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_textfield.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/chat/chat_services.dart';
import 'package:semesterprojectuprmonlinemarketplace/providers/notification_provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<DocumentSnapshot> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  bool search = false;
  int i = 0;

  String? _editingMessageID;
  String? _editingMessageText;

  @override
  void initState() {
    super.initState();

    // ✅ Mark messages as read when opening chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).markMessagesFromSenderAsRead(
        _authService.getCurrentUser()!.uid,
        widget.receiverEmail,
      );
    });

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
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      if (_editingMessageID == null) {
        // ✅ Send new message
        await _chatServices.sendMessage(
          widget.receiverID,
          _messageController.text,
          Provider.of<NotificationProvider>(context, listen: false),
        );
      } else {
        // ✅ Edit existing message
        await _chatServices.editMessage(
          widget.receiverID,
          _editingMessageID!,
          _messageController.text,
        );
        setState(() {
          _editingMessageID = null;
          _editingMessageText = null;
        });
      }

      _messageController.clear();
      scrollDown();
      setState(() => i = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading:
                search
                    ? GestureDetector(
                      onTap: () => setState(() => search = false),
                      child: Icon(CupertinoIcons.xmark),
                    )
                    : null,
            toolbarHeight: 100,
            title:
                search
                    ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 500),
                      child: SearchBar(
                        leading: Icon(Icons.search),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() => i = 0);
                          } else {
                            List<DocumentSnapshot> copy = [];
                            for (var x in messages) {
                              String text = x['message'];
                              if (text.contains(value)) {
                                copy.add(x);
                              }
                            }
                            setState(() => messages = copy);
                          }
                        },
                      ),
                    )
                    : Text(
                      widget.receiverEmail,
                      style: TextStyle(color: Colors.white),
                    ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: Column(
            children: [Expanded(child: _buildMessageList()), _buildUserInput()],
          ),
        ),

        if (!search)
          Padding(
            padding: EdgeInsets.only(top: 35, right: 50),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => setState(() => search = true),
                child: Icon(Icons.search),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    List<String> ids = [widget.receiverID, senderID];
    ids.sort();
    String chatRoomID = ids.join("_");
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection("chat_rooms/$chatRoomID/messages/")
              .orderBy("timestamp", descending: false)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        if (messages.length != snapshot.data!.docs && i == 0) {
          messages = snapshot.data!.docs;
          i++;
        }

        print(messages);
        return ListView(
          controller: _scrollController,
          children: [for (var i in messages) _buildMessageItem(i)],
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    Timestamp timestamp = data['timestamp'];

    // ✅ Check if message is within 5-minute edit window
    bool withinEditWindow =
        DateTime.now().difference(timestamp.toDate()).inMinutes < 5;

    // ✅ Mark message as read when receiver opens the chat
    if (!isCurrentUser && !(data['read'] ?? false)) {
      _chatServices.markMessageAsRead(widget.receiverID, doc.id);
    }

    return GestureDetector(
      onLongPress:
          isCurrentUser && withinEditWindow
              ? () {
                setState(() {
                  _editingMessageID = doc.id;
                  _editingMessageText = data['message'];
                  _messageController.text = _editingMessageText!;
                });
              }
              : null,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),

          // ✅ Show "Edited" label for BOTH sender & receiver
          if (data['edited'] ?? false)
            const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 2),
              child: Text(
                "Edited",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

          // ✅ Show "Read" indicator for sender if the message is read
          if (isCurrentUser && (data['read'] ?? false))
            const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 2),
              child: Text(
                "Read",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
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
              hintText:
                  _editingMessageID == null
                      ? "Type a message"
                      : "Edit message...",
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
