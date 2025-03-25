import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/constants/text.dart';
import 'package:talkify_app/views/feed_view.dart';
import 'package:talkify_app/views/message_view.dart';
import 'package:talkify_app/views/profile_view.dart';
import 'package:talkify_app/views/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  //
  int _currentIndex = 0;

  // List page
  final List<Widget> _pages = const [
    MessageView(),
    FeedView(),
    SearchView(),
    ProfileView(),
  ];

  //
  late NotchBottomBarController _notchBottomBarController;

  //
  @override
  void initState() {
    // Initialize the NotchBottomBarController
    _notchBottomBarController = NotchBottomBarController(index: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedNotchBottomBar(
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: HugeIcon(
              icon: HugeIcons.strokeRoundedMessenger,
              color: Colors.black,
              size: 5.w,
            ),
            activeItem: HugeIcon(
              icon: HugeIcons.strokeRoundedMessenger,
              color: kPrimaryColor,
              size: 5.w,
            ),
            itemLabel: txtMessageH,
          ),
          BottomBarItem(
            inActiveItem: HugeIcon(
              icon: HugeIcons.strokeRoundedDashboardSquare03,
              color: Colors.black,
              size: 5.w,
            ),
            activeItem: HugeIcon(
              icon: HugeIcons.strokeRoundedDashboardSquare03,
              color: kPrimaryColor,
              size: 5.w,
            ),
            itemLabel: txtFeedH,
          ),
          BottomBarItem(
            inActiveItem: HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              color: Colors.black,
              size: 5.w,
            ),
            activeItem: HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              color: kPrimaryColor,
              size: 5.w,
            ),
            itemLabel: txtAddH,
          ),
          BottomBarItem(
            inActiveItem: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: Colors.black,
              size: 5.w,
            ),
            activeItem: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: kPrimaryColor,
              size: 5.w,
            ),
            itemLabel: txtAccountH,
          ),
        ],
        notchBottomBarController: _notchBottomBarController,
        onTap: (int value) {
          // update current page
          setState(() {
            _currentIndex = value;
          });
        },
        kIconSize: 5.w,
        kBottomRadius: 15.w,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
