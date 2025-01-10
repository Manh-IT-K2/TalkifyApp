import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/view/feed_view.dart';
import 'package:talkify_app/view/message_view.dart';
import 'package:talkify_app/view/profile_view.dart';
import 'package:talkify_app/view/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  // Danh sách các trang
  final List<Widget> _pages = [
    const MessageView(),
    const FeedView(),
    const SearchView(),
    const ProfileView(),
  ];
  late NotchBottomBarController _notchBottomBarController;
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
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.message_outlined,
              color: Colors.black,
            ),
            activeItem: Icon(
              Icons.message_outlined,
              color: kPrimaryColor,
            ),
            itemLabel: 'Message',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.auto_awesome_mosaic_outlined,
              color: Colors.black,
            ),
            activeItem: Icon(
              Icons.auto_awesome_mosaic_outlined,
              color: kPrimaryColor,
            ),
            itemLabel: 'Feed',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.add,
              color: Colors.black,
            ),
            activeItem: Icon(
              Icons.add,
              color: kPrimaryColor,
            ),
            itemLabel: "Add",
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.account_circle_outlined,
              color: Colors.black,
            ),
            activeItem: Icon(
              Icons.account_circle_outlined,
              color: kPrimaryColor,
            ),
            itemLabel: "Account",
          ),
        ],
        notchBottomBarController: _notchBottomBarController,
        onTap: (int value) {
          setState(() {
            _currentIndex = value; // Cập nhật trang hiện tại
          });
        },
        kIconSize: 20.0,
        kBottomRadius: 5.0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
