import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme_flutter/chat_screen.dart';
import 'package:fixme_flutter/firebase_message.dart';
import 'package:fixme_flutter/screens/customer/chat_custome_screen.dart';
import 'package:fixme_flutter/screens/customer/chats_screen.dart';
import 'package:fixme_flutter/screens/customer/home_screen.dart';
import 'package:fixme_flutter/screens/eng/eng_home_screen.dart';
import 'package:fixme_flutter/screens/login_screen.dart';
import 'package:fixme_flutter/screens/register_screen.dart';
import 'package:fixme_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

bool? isLogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessageService();
  FirebaseMessageService.initialFirebaseBackGround();
  var user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('==========================================');
        print(message.notification!.title);
        print(message.notification!.body);
        print('==========================================');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin! == false ? LoginScreen() : WelcomeScreen(),
      routes: {
        'welcome': (context) => WelcomeScreen(),
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        'home': (context) => HomeScreen(),
        'engHome': (context) => EngHomeScreen(),
        'chat': (context) => ChatScreen(),
        'chats': (context) => ChatsScreen(),
        'chatc': (context) => ChatCScreen(),
      },
    );
  }
}
