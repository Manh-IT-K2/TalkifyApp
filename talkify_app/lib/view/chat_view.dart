import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/constant/chat_message.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/model/message_model.dart';
import 'package:talkify_app/model/user_data_model.dart';
import 'package:talkify_app/provider/chat_provider.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageController = TextEditingController();
  TextEditingController editMessageController = TextEditingController();
  late String currentUserId;
  late String currentUserName;

  FilePickerResult? _filePickerResult;
  // List messages = [
  //   MessageModel(
  //       message: "Hello!",
  //       sender: "101",
  //       receiver: "202",
  //       timestamp: DateTime(2024, 1, 1),
  //       isSeenByRecevier: true),
  //   MessageModel(
  //       message: "Hi!",
  //       sender: "202",
  //       receiver: "101",
  //       timestamp: DateTime(2024, 1, 1),
  //       isSeenByRecevier: false),
  //   MessageModel(
  //       message: "How Are You?",
  //       sender: "101",
  //       receiver: "202",
  //       timestamp: DateTime(2024, 1, 1),
  //       isSeenByRecevier: false),
  //   MessageModel(
  //       message: "How Are You?",
  //       sender: "101",
  //       receiver: "202",
  //       timestamp: DateTime(2024, 1, 1),
  //       isSeenByRecevier: false,
  //       isImage: true),
  // ];

  @override
  void initState() {
    currentUserId =
        Provider.of<UserDataProvider>(context, listen: false).getUserId;
    currentUserName =
        Provider.of<UserDataProvider>(context, listen: false).getUserName;
    Provider.of<ChatProvider>(context, listen: false).loadChats(currentUserId);
    super.initState();
  }

  // to open file picker
  void _openFilePicker(UserDataModel receiver) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    setState(() {
      _filePickerResult = result;
      uploadAllImage(receiver);
    });
  }

  // to upload files to our storage bucket and our database
  void uploadAllImage(UserDataModel receiver) async {
    if (_filePickerResult != null) {
      _filePickerResult!.paths.forEach((path) {
        if (path != null) {
          var file = File(path);
          final fileBytes = file.readAsBytesSync();
          final inputFile = InputFile.fromBytes(
              bytes: fileBytes, filename: file.path.split("/").last);

          // saving image to our storage bucket
          saveImageToBucket(image: inputFile).then((imageId) {
            if (imageId != null) {
              createNewChat(
                      message: imageId,
                      senderId: currentUserId,
                      receiverId: receiver.userId,
                      isImage: true)
                  .then((value) {
                if (value) {
                  Provider.of<ChatProvider>(context, listen: false).addMessage(
                      MessageModel(
                          message: imageId,
                          sender: currentUserId,
                          receiver: receiver.userId,
                          timestamp: DateTime.now(),
                          isSeenByRecevier: false,
                          isImage: true),
                      currentUserId,
                      [
                        UserDataModel(email: "", userId: currentUserId),
                        receiver
                      ]);
                  sendNotificationToOtherUser(
                      notificationTitle: "$currentUserName sent you an image",
                      notificationBody: "check it our.",
                      deviceToken: receiver.deviceToken!);
                }
              });
            }
          });
        }
      });
    } else {
      if (kDebugMode) {
        print("File piclk  cancelled by user");
      }
    }
  }

  // to send simple text message
  void _sendMessage({required UserDataModel receiver}) {
    if (messageController.text.isNotEmpty) {
      setState(() {
        createNewChat(
                message: messageController.text,
                senderId: currentUserId,
                receiverId: receiver.userId,
                isImage: false)
            .then((value) {
          if (value) {
            Provider.of<ChatProvider>(context, listen: false).addMessage(
                MessageModel(
                    message: messageController.text,
                    sender: currentUserId,
                    receiver: receiver.userId,
                    timestamp: DateTime.now(),
                    isSeenByRecevier: false),
                currentUserId,
                [UserDataModel(email: "", userId: currentUserId), receiver]);
            sendNotificationToOtherUser(
                notificationTitle: "$currentUserName sent you a message",
                notificationBody: messageController.text,
                deviceToken: receiver.deviceToken!);
            messageController.clear();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserDataModel receiver =
        ModalRoute.of(context)!.settings.arguments as UserDataModel;
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        //
        final userAndOtherChats = value.getAllChats[receiver.userId] ?? [];

        //
        bool? otherUserOnline = userAndOtherChats.isNotEmpty
            ? userAndOtherChats[0].users[0].userId == receiver.userId
                ? userAndOtherChats[0].users[0].isOnline
                : userAndOtherChats[0].users[1].isOnline
            : false;
        //
        List<String> receiverMsgList = [];
        for (var chat in userAndOtherChats) {
          if (chat.message.receiver == currentUserId) {
            if (chat.message.isSeenByRecevier == false) {
              receiverMsgList.add(chat.message.messageId!);
            }
          }
        }
        updateIsSeen(chatsIds: receiverMsgList);
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kBackgroundColor,
            leadingWidth: 40,
            scrolledUnderElevation: 0,
            elevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: receiver.profilePic == "" ||
                          receiver.profilePic == null
                      ? const Image(image: AssetImage("assets/image/user.png"))
                          .image
                      : CachedNetworkImageProvider(
                          "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${receiver.profilePic}/view?project=6680f2b1003440efdcfe&mode=admin"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receiver.name!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      otherUserOnline == true ? "Online" : "Offline",
                      style: const TextStyle(
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
                      reverse: true,
                      itemCount: userAndOtherChats.length,
                      itemBuilder: (context, index) {
                        final msg = userAndOtherChats[
                                userAndOtherChats.length - 1 - index]
                            .message;
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: msg.isImage == true
                                    ? Text(msg.sender == currentUserId
                                        ? "Chose what you want to do with this image."
                                        : "This image cant be modified.")
                                    : Text(
                                        "${msg.message.length > 19 ? msg.message.substring(0, 19) + "..." : msg.message}"),
                                content: msg.isImage == true
                                    ? Text(msg.sender == currentUserId
                                        ? "Delete this image."
                                        : "This image cant be deleted.")
                                    : Text(msg.sender == currentUserId
                                        ? "Chose what you want to do with this message."
                                        : "This message cant be modified."),
                                actions: [
                                  msg.sender == currentUserId
                                      ? TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            editMessageController.text =
                                                msg.message;
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          "Edit this message"),
                                                      content: TextFormField(
                                                        controller:
                                                            editMessageController,
                                                        maxLines: 10,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Canel"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            editChat(
                                                                chatId: msg
                                                                    .messageId!,
                                                                message:
                                                                    editMessageController
                                                                        .text);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("Ok"),
                                                        ),
                                                      ],
                                                    ));
                                          },
                                          child: const Text("Edit"),
                                        )
                                      : const SizedBox(),
                                  msg.sender == currentUserId
                                      ? TextButton(
                                          onPressed: () {
                                            Provider.of<ChatProvider>(context,
                                                    listen: false)
                                                .deleteMessage(
                                                    msg, currentUserId);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Delete"),
                                        )
                                      : const SizedBox(),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  )
                                ],
                              ),
                            );
                          },
                          child: ChatMessage(
                            isImage: msg.isImage ?? false,
                            msg: msg,
                            currentUser: currentUserId,
                          ),
                        );
                      }),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 6, 12, 22),
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
                    IconButton(
                        onPressed: () {
                          _openFilePicker(receiver);
                        },
                        icon: const Icon(Icons.image, color: Color.fromARGB(255, 168, 99, 175),)),
                    IconButton(
                      onPressed: () {
                        _sendMessage(receiver: receiver);
                      },
                      icon: const Icon(Icons.send, color: Colors.blue,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
