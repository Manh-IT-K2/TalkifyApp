import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talkify_app/constants/text.dart';
import 'package:talkify_app/controllers/appwrite_controller.dart';
import 'package:talkify_app/controllers/local_saved_data.dart';
import 'package:talkify_app/providers/chat_provider.dart';
import 'package:talkify_app/providers/user_data_provider.dart';
import 'package:talkify_app/utils/theme_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              txtTitleP,
              style: PrimaryFont.titleBold(),
            ),
          ),
          body: Column(
            children: [
              ListTile(
                onTap: () => Navigator.pushNamed(context, "/update",
                    arguments: {"title": "edit"}),
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: CircleAvatar(
                    backgroundImage: value.getUserProfilePic != ""
                        ? CachedNetworkImageProvider(
                            "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${value.getUserProfilePic}/view?project=6680f2b1003440efdcfe&mode=admin")
                        : const Image(
                            image: AssetImage("assets/image/user.png"),
                          ).image,
                  ),
                ),
                title: Text(value.getUserName),
                titleTextStyle:
                    PrimaryFont.subTitleMedium().copyWith(color: Colors.black),
                subtitle: Text(
                  value.getUserEmail,
                  style: PrimaryFont.subTitleMedium(),
                ),
                trailing: HugeIcon(
                  icon: HugeIcons.strokeRoundedPencilEdit02,
                  color: Colors.black,
                  size: 5.w,
                ),
              ),
              const Divider(),
              ListTile(
                onTap: () async {
                  updateOnlineStatus(
                      status: false,
                      userId:
                          Provider.of<UserDataProvider>(context, listen: false)
                              .getUserId);
                  await LocalSavedData.clearAllData();
                  Provider.of<UserDataProvider>(context, listen: false)
                      .clearAllProfile();
                  Provider.of<ChatProvider>(context, listen: false)
                      .clearChats();
                  await logoutUser();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                },
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedLogout03,
                  color: Colors.black,
                  size: 5.w,
                ),
                title: Text(
                  txtLogoutP,
                  style: PrimaryFont.subTitleMedium(),
                ),
              ),
              const Divider(),
              ListTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedAlertCircle,
                  color: Colors.black,
                  size: 5.w,
                ),
                title: Text(
                  txtAboutP,
                  style: PrimaryFont.subTitleMedium(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
