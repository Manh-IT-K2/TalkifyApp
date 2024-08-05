import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/controller/local_saved_data.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () => Navigator.pushNamed(context, "/updateProfile", arguments: {"title":"edit"}),
              leading: CircleAvatar(
                backgroundImage: value.getUserProfilePic != null ||
                        value.getUserProfilePic != ""
                    ? CachedNetworkImageProvider("https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${value.getUserProfilePic}/view?project=6680f2b1003440efdcfe&mode=admin")
                    : const Image(
                        image: AssetImage("assets/image/user.png"),
                      ).image,
              ),
              title: Text(value.getUserName),
              subtitle: Text(value.getUserEmail),
              trailing: const Icon(Icons.edit_outlined),
            ),
            const Divider(),
            ListTile(
              onTap: () async {
                await LocalSavedData.clearAllData();
                await logoutUser();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About"),
            ),
          ],
        ),
      );
    });
  }
}
