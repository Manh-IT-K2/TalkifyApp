import 'package:flutter/material.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => Navigator.pushNamed(context, "/updateProfile"),
            leading: const CircleAvatar(
              backgroundImage: AssetImage("assets/image/user.png"),
            ),
            title: const Text("Current User"),
            subtitle: const Text("+84899391826"),
            trailing: const Icon(Icons.edit_outlined),
          ),
          const Divider(),
          ListTile(
            onTap: (){
              logoutUser();
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
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
  }
}