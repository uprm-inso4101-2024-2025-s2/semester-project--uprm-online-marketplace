import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isCurrentUser
                ? Colors.green
                : const Color.fromARGB(
                  255,
                  25,
                  110,
                  29,
                ), //Gonna depend if is the current user or not
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),

      child: Text(message, style: TextStyle(color: Colors.white)),
    );
  }
}
