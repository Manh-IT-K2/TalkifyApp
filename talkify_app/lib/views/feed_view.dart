import 'package:flutter/material.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/constants/text.dart';
import 'package:talkify_app/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          txtTitleF,
          style: PrimaryFont.titleBold(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5.w),
                    child: const _ItemFeed(),
                    );
                },
              ),
            ),
            SizedBox(height: 5.w,),
          ],
        ),
      ),
    );
  }
}

class _ItemFeed extends StatelessWidget {
  const _ItemFeed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 10,
          left: -5,
          right: -5,
          child: Container(
            width: 100.w + 10,
            height: 78.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: kBoderChatColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(3.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 3.w),
                    CircleAvatar(
                      radius: 8.w,
                      backgroundImage: const NetworkImage(
                          'https://i.pinimg.com/736x/a8/e7/34/a8e7349443e12d34d2fc6b3a03e2967e.jpg'),
                      backgroundColor: Colors.grey[200],
                    ),
                   SizedBox(width: 1.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mansahu",
                          style: PrimaryFont.subTitleBold(),
                        ),
                        Text(
                          "4 hours ago",
                          style: PrimaryFont.subTitleLight(),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                Divider(thickness: 0.5, color: Colors.black, height: 3.w),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Text(
                    "I sell 2 tickets to the show tonight friends there are asking...?",
                    style: PrimaryFont.subTitleLight(),
                    maxLines: 2, // max
                    overflow: TextOverflow.ellipsis, // ...
                  ),
                ),
                // hide/show image flexible
                Visibility(
                  visible: true,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    height: 30.w,
                    width: 100.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      'https://i.pinimg.com/736x/81/3b/21/813b21bd21d70a4b3a2b9648162ab90c.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.favorite_border_outlined,
                          size: 5.w,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "10",
                        style: PrimaryFont.subTitleLight(),
                      ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.message_outlined,
                          size: 5.w,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "10 Comment",
                        style: PrimaryFont.subTitleLight(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
