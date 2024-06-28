import 'package:flutter/material.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/model/message_model.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List messages = [
    MessageModel(
        message: "Hello!",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2000),
        isSeenByRecevier: false),
    MessageModel(
        message: "Hi!",
        sender: "202",
        receiver: "101",
        timestamp: DateTime(2000),
        isSeenByRecevier: false),
    MessageModel(
        message: "How Are You?",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2000),
        isSeenByRecevier: false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leadingWidth: 40,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Other User",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
