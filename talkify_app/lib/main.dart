import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/controller/local_saved_data.dart';
import 'package:talkify_app/firebase_options.dart';
import 'package:talkify_app/provider/chat_provider.dart';
import 'package:talkify_app/provider/user_data_provider.dart';
import 'package:talkify_app/view/chat_view.dart';
import 'package:talkify_app/view/home_view.dart';
import 'package:talkify_app/view/login_view.dart';
import 'package:talkify_app/view/profile_view.dart';
import 'package:talkify_app/view/search_view.dart';
import 'package:talkify_app/view/update_profile_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LifecycleEventHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId = Provider.of<UserDataProvider>(
            navigatorKey.currentState!.context,
            listen: false)
        .getUserId;
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        updateOnlineStatus(status: true, userId: currentUserId);
        if (kDebugMode) {
          print("App resumed");
        }
        break;
      case AppLifecycleState.inactive:
        updateOnlineStatus(status: false, userId: currentUserId);
        if (kDebugMode) {
          print("App inactive");
        }
        break;
      case AppLifecycleState.paused:
        updateOnlineStatus(status: false, userId: currentUserId);
        if (kDebugMode) {
          print("App paused");
        }
        break;
      case AppLifecycleState.detached:
        updateOnlineStatus(status: false, userId: currentUserId);
        if (kDebugMode) {
          print("App detached");
        }
        break;
      case AppLifecycleState.hidden:
        updateOnlineStatus(status: false, userId: currentUserId);
        if (kDebugMode) {
          print("App hidden");
        }
        break;
      default:
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalSavedData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider())
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Talkify App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => const CheckUserSession(),
          "/login": (context) => const LoginView(),
          "/home": (context) => const HomeView(),
          "/chat": (context) => const ChatView(),
          "/profile": (context) => const ProfileView(),
          "/updateProfile": (context) => const UpdateProfileView(),
          "/search": (context) => const SearchView()
        },
      ),
    );
  }
}

//
class CheckUserSession extends StatefulWidget {
  const CheckUserSession({super.key});

  @override
  State<CheckUserSession> createState() => _CheckUserSessionState();
}

class _CheckUserSessionState extends State<CheckUserSession> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<UserDataProvider>(context, listen: false).loadDataFromLocal();
    });

    checkSessions().then((value) {
      final userName =
          Provider.of<UserDataProvider>(context, listen: false).getUserName;
      if (value) {
        if (userName != null && userName != "") {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false,
              arguments: {"title": "add"});
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
