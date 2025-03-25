import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/constants/fomate_date.dart';
import 'package:talkify_app/constants/text.dart';
import 'package:talkify_app/controllers/appwrite_controller.dart';
import 'package:talkify_app/controllers/fcm_controller.dart';
import 'package:talkify_app/models/chat_data_model.dart';
import 'package:talkify_app/models/user_data_model.dart';
import 'package:talkify_app/providers/chat_provider.dart';
import 'package:talkify_app/providers/user_data_provider.dart';
import 'package:talkify_app/utils/theme_text.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  //
  late String currentUserId = "";
  @override
  void initState() {
    currentUserId =
        Provider.of<UserDataProvider>(context, listen: false).getUserId;
    Provider.of<ChatProvider>(context, listen: false).loadChats(currentUserId);
    PushNotifications.getDeviceToken();
    subcscribeToRealtime(userId: currentUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateOnlineStatus(status: true, userId: currentUserId);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(
          txtTitleM,
          style: PrimaryFont.titleBold(),
        ),
        actions: [
          Stack(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedNotification03,
                color: const Color.fromRGBO(0, 0, 0, 1),
                size: 8.w,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 8,
                    child: Text(
                      "5",
                      style:
                          PrimaryFont.medium(11).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 5.w,
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, value, child) {
          if (value.getAllChats.isEmpty) {
            return Center(
              child: Text(
                txtBodyM,
                style: PrimaryFont.subTitleMedium(),
              ),
            );
          } else {
            List otherUsers = value.getAllChats.keys.toList();
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 10,
                    left: -5,
                    right: -5,
                    child: Container(
                      width: 100.w + 10,
                      height: 20.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: kBoderChatColor,
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(3.w),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]),
                    child: ListView.builder(
                        itemCount: otherUsers.length,
                        itemBuilder: (context, index) {
                          //
                          List<ChatDataModel> chatData =
                              value.getAllChats[otherUsers[index]]!;
                          int totalChat = chatData.length;
                          UserDataModel otherUser =
                              chatData[0].users[0].userId == currentUserId
                                  ? chatData[0].users[1]
                                  : chatData[0].users[0];

                          int unreadMsg = 0;
                          chatData.fold(unreadMsg, (previousValue, element) {
                            if (element.message.isSeenByRecevier == false) {
                              unreadMsg++;
                            }
                            return unreadMsg;
                          });
                          return ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/chat",
                                  arguments: otherUser);
                            },
                            leading: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: otherUser.profilePic ==
                                                "" ||
                                            otherUser.profilePic == null
                                        ? const Image(
                                            image: AssetImage(
                                                "assets/image/user.png"),
                                          ).image
                                        : CachedNetworkImageProvider(
                                            "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${otherUser.profilePic}/view?project=6680f2b1003440efdcfe&mode=admin"),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: otherUser.isOnline == true
                                        ? Colors.green
                                        : Colors.grey.shade600,
                                  ),
                                )
                              ],
                            ),
                            title: Text(
                              otherUser.name!,
                              style: PrimaryFont.subTitleMedium(),
                            ),
                            subtitle: Text(
                              "${chatData[totalChat - 1].message.sender == currentUserId ? "You: " : ""}${chatData[totalChat - 1].message.isImage == true ? "Sent an image" : chatData[totalChat - 1].message.message}",
                              overflow: TextOverflow.ellipsis,
                              style: PrimaryFont.subTitleMedium(),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                chatData[totalChat - 1].message.sender !=
                                        currentUserId
                                    ? unreadMsg != 0
                                        ? CircleAvatar(
                                            backgroundColor: kPrimaryColor,
                                            radius: 10,
                                            child: Text(
                                              unreadMsg.toString(),
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white),
                                            ))
                                        : const SizedBox()
                                    : const SizedBox(),
                                SizedBox(
                                  height: 2.w,
                                ),
                                Text(
                                  fomateDate(chatData[totalChat - 1]
                                      .message
                                      .timestamp),
                                  style: PrimaryFont.subTitleLight(),
                                ),
                              ],
                            ),
                          );
                        },
                        ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, "/search");
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
