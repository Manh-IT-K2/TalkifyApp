import 'package:flutter/material.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/constants/text.dart';
import 'package:talkify_app/utils/theme_text.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          txtTitleF,
          style: PrimaryFont.titleBold(),),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 10,
                  left: -5,
                  right: -5,
                  child: Container(
                    width: screenWidth + 10,
                    height: 210,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: kBoderChatColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
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
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: const NetworkImage(
                                  'https://i.pinimg.com/736x/a8/e7/34/a8e7349443e12d34d2fc6b3a03e2967e.jpg'),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(width: 5),
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
                        const Divider(
                            thickness: 0.5, color: Colors.black, height: 5),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                          child: Text(
                            "I sell 2 tickets to the show tonight friends there are asking...?",
                            style: PrimaryFont.subTitleLight(),
                            maxLines: 2, // max 
                            overflow: TextOverflow.ellipsis, // ...
                          ),
                        ),
                        // Ẩn/Hiện ảnh linh hoạt
                        Visibility(
                          visible: true, // Nếu không cần ảnh, đặt `false`
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                            height: 80,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
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
                                child: const Icon(
                                  Icons.favorite_border_outlined,
                                  size: 15,
                                  color: Colors.red,
                                ),
                              ),
                                const SizedBox(width: 6),
                              const Text(
                                "10",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                                const SizedBox(width: 10),
                              GestureDetector(
                                
                                onTap: () {},
                                child: const Icon(
                                  Icons.message_outlined,
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "10 Comment",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 10,
                  left: -5,
                  right: -5,
                  child: Container(
                    width: screenWidth + 10,
                    height: 210,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: kBoderChatColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
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
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: const NetworkImage(
                                  'https://i.pinimg.com/736x/a8/e7/34/a8e7349443e12d34d2fc6b3a03e2967e.jpg'),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(width: 5),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mansahu",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "4 hours ago",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
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
                        const Divider(
                            thickness: 0.5, color: Colors.black, height: 5),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                          child: Text(
                            "I sell 2 tickets to the show tonight friends there are asking...?",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2, // max 
                            overflow: TextOverflow.ellipsis, // ...
                          ),
                        ),
                        // Ẩn/Hiện ảnh linh hoạt
                        Visibility(
                          visible: true, // Nếu không cần ảnh, đặt `false`
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                            height: 80,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
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
                                child: const Icon(
                                  Icons.favorite_border_outlined,
                                  size: 15,
                                  color: Colors.red,
                                ),
                              ),
                                const SizedBox(width: 6),
                              const Text(
                                "10",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                                const SizedBox(width: 10),
                              GestureDetector(
                                
                                onTap: () {},
                                child: const Icon(
                                  Icons.message_outlined,
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "10 Comment",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
