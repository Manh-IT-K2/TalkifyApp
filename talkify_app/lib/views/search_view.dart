import 'package:appwrite/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/constants/text.dart';
import 'package:talkify_app/controllers/appwrite_controller.dart';
import 'package:talkify_app/models/user_data_model.dart';
import 'package:talkify_app/providers/user_data_provider.dart';
import 'package:talkify_app/utils/theme_text.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  //
  final TextEditingController _searchController = TextEditingController();
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
        title: Text(
          txtTitleS,
          style: PrimaryFont.titleBold(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(2.w),
            ),
            margin: const EdgeInsets.all(12.0),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) => _handleSearch,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: txtHintTextFormS,
                      hintStyle: PrimaryFont.subTitleMedium(),
                    ),
                  ),
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMailSearch01,
                    color: Colors.black,
                    size: 6.w,
                  ),
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
          ? Center(
              child: Text(
                txtbodyText1S,
                style: PrimaryFont.subTitleMedium(),
              ),
            )
          : searchedUsers.total == 0
              ? Center(
                  child: Text(
                    txtbodyText2S,
                    style: PrimaryFont.subTitleMedium(),
                  ),
                )
              : ListView.builder(
                  itemCount: searchedUsers.documents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/chat",
                          arguments: UserDataModel.toMap(
                              searchedUsers.documents[index].data),
                        );
                      },
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
                      title: Text(
                        searchedUsers.documents[index].data["name"],
                      ),
                      subtitle: Text(
                        searchedUsers.documents[index].data["email"],
                      ),
                    );
                  },
                ),
    );
  }
}
