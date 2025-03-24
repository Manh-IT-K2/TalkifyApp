import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/constants/fomate_date.dart';
import 'package:talkify_app/models/message_model.dart';
import 'package:talkify_app/utils/theme_text.dart';

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
    return widget.isImage
        ? Row(
          mainAxisAlignment: widget.msg.sender == widget.currentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: widget.msg.sender == widget.currentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                DottedBorder(
                  dashPattern: const [4, 4],
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${widget.msg.message}/view?project=6680f2b1003440efdcfe&mode=admin",
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        fomateDate(widget.msg.timestamp),
                        style: PrimaryFont.subTitleLight(),
                      ),
                    ),
                    widget.msg.sender == widget.currentUser
                        ? widget.msg.isSeenByRecevier
                            ? const Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: kPrimaryColor,
                              )
                            : const Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: kPrimaryColor,
                              )
                        : const SizedBox(),
                  ],
                ),
              ],
            )
          ],
        )
        : Container(
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
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            color: widget.msg.sender == widget.currentUser
                                ? kPrimaryColor
                                : kSecondaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(20),
                              bottomRight:
                                  widget.msg.sender == widget.currentUser
                                      ? const Radius.circular(2)
                                      : const Radius.circular(20),
                              topLeft: widget.msg.sender == widget.currentUser
                                  ? const Radius.circular(20)
                                  : const Radius.circular(2),
                              topRight: const Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            widget.msg.message,
                            style: PrimaryFont.subTitleMedium().copyWith(color: widget.msg.sender == widget.currentUser
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
                            style: PrimaryFont.subTitleLight(),
                          ),
                        ),
                        widget.msg.sender == widget.currentUser
                            ? widget.msg.isSeenByRecevier
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    size: 16,
                                    color: kPrimaryColor,
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    size: 16,
                                    color: kPrimaryColor,
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
