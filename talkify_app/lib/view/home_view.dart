import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/constant/fomate_date.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/controller/fcm_controller.dart';
import 'package:talkify_app/model/chat_data_model.dart';
import 'package:talkify_app/model/user_data_model.dart';
import 'package:talkify_app/provider/chat_provider.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
        title: const Text(
          "Chats",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/profile"),
            child: Consumer<UserDataProvider>(
              builder: (context, value, child) {
                return CircleAvatar(
                  backgroundImage:
                          value.getUserProfilePic == ""
                      ? const Image(
                          image: AssetImage("assets/image/user.png"),
                        ).image
                      : CachedNetworkImageProvider(
                          "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${value.getUserProfilePic}/view?project=6680f2b1003440efdcfe&mode=admin"),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, value, child) {
          if (value.getAllChats.isEmpty) {
            return const Center(
              child: Text("No chats"),
            );
          } else {
            List otherUsers = value.getAllChats.keys.toList();
            return ListView.builder(
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
                        CircleAvatar(
                          backgroundImage: otherUser.profilePic == "" ||
                                  otherUser.profilePic == null
                              ? const Image(
                                  image: AssetImage("assets/image/user.png"),
                                ).image
                              : CachedNetworkImageProvider(
                                  "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${otherUser.profilePic}/view?project=6680f2b1003440efdcfe&mode=admin"),
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
                    title: Text(otherUser.name!),
                    subtitle: Text(
                      "${chatData[totalChat - 1].message.sender == currentUserId ? "You: " : ""}${chatData[totalChat - 1].message.isImage == true ? "Sent an image" : chatData[totalChat - 1].message.message}",
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        chatData[totalChat - 1].message.sender != currentUserId
                            ? unreadMsg != 0
                                ? CircleAvatar(
                                    backgroundColor: kPrimaryColor,
                                    radius: 10,
                                    child: Text(
                                      unreadMsg.toString(),
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ))
                                : const SizedBox()
                            : const SizedBox(),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(fomateDate(
                            chatData[totalChat - 1].message.timestamp)),
                      ],
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/search");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
