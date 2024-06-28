import 'package:flutter/material.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/constant/fomate_date.dart';
import 'package:talkify_app/model/message_model.dart';

class ChatMessage extends StatefulWidget {
  final MessageModel msg;
  final String currentUser;
  final bool isImage;
  const ChatMessage(
      {super.key,
      required this.msg,
      required this.currentUser,
      required this.isImage});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: widget.msg.sender == widget.currentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: widget.msg.sender == widget.currentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: widget.msg.sender == widget.currentUser
                          ? kPrimaryColor
                          : kSecondaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: widget.msg.sender == widget.currentUser
                            ? const Radius.circular(20)
                            : const Radius.circular(2),
                        bottomRight: widget.msg.sender == widget.currentUser
                            ? const Radius.circular(2)
                            : const Radius.circular(20),
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      widget.msg.message,
                      style: TextStyle(
                          color: widget.msg.sender == widget.currentUser
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      fomateDate(widget.msg.timestamp),
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  widget.msg.sender == widget.currentUser
                      ? widget.msg.isSeenByRecevier
                          ? const Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: kPrimaryColor,
                            )
                          : const Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: Colors.grey,
                            )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
