import 'package:flutter/material.dart';
import 'package:talkify_app/view/chat_view.dart';
import 'package:talkify_app/view/home_view.dart';
import 'package:talkify_app/view/login_view.dart';
import 'package:talkify_app/view/profile_view.dart';
import 'package:talkify_app/view/update_profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talkify App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => const LoginView(),
        "/home": (context) => const HomeView(),
        "/chat": (context) => const ChatView(),
        "/profile":(context) => const ProfileView(),
        "/updateProfile": (context) => const UpdateProfileView(),
      },
    );
  }
}
