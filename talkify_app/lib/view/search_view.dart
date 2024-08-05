import 'package:appwrite/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _searchController = TextEditingController();
  late DocumentList searchedUsers = DocumentList(total: -1, documents: []);

  // handle the search
  void _handleSearch() {
    searchUsers(
            searchItem: _searchController.text,
            userId:
                Provider.of<UserDataProvider>(context, listen: false).getUserId)
        .then((value) {
      if (value != null) {
        setState(() {
          searchedUsers = value;
        });
      } else {
        setState(() {
          searchedUsers = DocumentList(total: 0, documents: []);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Users",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) => _handleSearch,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Enter email"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _handleSearch();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: searchedUsers.total == -1
          ? const Center(
              child: Text("Use the search box to search users."),
            )
          : searchedUsers.total == 0
              ? const Center(
                  child: Text("No users found"),
                )
              : ListView.builder(
                  itemCount: searchedUsers.documents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: searchedUsers
                                        .documents[index].data["profile_pic"] !=
                                    null &&
                                searchedUsers
                                        .documents[index].data["profile_pic"] !=
                                    ""
                            ? CachedNetworkImageProvider(
                                "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${searchedUsers.documents[index].data["profile_pic"]}/view?project=6680f2b1003440efdcfe&mode=admin")
                            : const Image(
                                image: AssetImage("assets/image/user.png"),
                              ).image,
                      ),
                      title: Text(searchedUsers.documents[index].data["name"]),
                      subtitle:
                          Text(searchedUsers.documents[index].data["email"]),
                    );
                  },
                ),
    );
  }
}
