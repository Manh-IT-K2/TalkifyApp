import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/model/user_data_model.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: value.getUserProfilePic != null ||
                          value.getUserProfilePic != ""
                      ? const CachedNetworkImageProvider("")
                      : const Image(
                          image: AssetImage("assets/image/user.png"),
                        ).image,
                );
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pushNamed(context, "/chat");
          },
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: const Image(
                  image: AssetImage("assets/image/user.png"),
                ).image,
              ),
              const Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.green,
                ),
              )
            ],
          ),
          title: const Text("Other User"),
          subtitle: const Text("Hi! How are you?"),
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 10,
                child: Text(
                  "10",
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text("20:50"),
            ],
          ),
        ),
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
