import 'package:flutter/material.dart';
import 'package:talkify_app/constant/chat_message.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/model/message_model.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageController = TextEditingController();

  List messages = [
    MessageModel(
        message: "Hello!",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2024, 1, 1),
        isSeenByRecevier: true),
    MessageModel(
        message: "Hi!",
        sender: "202",
        receiver: "101",
        timestamp: DateTime(2024, 1, 1),
        isSeenByRecevier: false),
    MessageModel(
        message: "How Are You?",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2024, 1, 1),
        isSeenByRecevier: false),
    MessageModel(
        message: "How Are You?",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2024, 1, 1),
        isSeenByRecevier: false,
        isImage: true),
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => ChatMessage(
                    msg: messages[index], currentUser: "101", isImage: true),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message ..."),
                  ),
                ),
                IconButton(onPressed: (){}, icon: const Icon(Icons.image)),
                IconButton(onPressed: (){}, icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
