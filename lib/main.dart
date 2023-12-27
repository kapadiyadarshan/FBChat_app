import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app/helpers/auth_helper.dart';
import 'package:new_chat_app/utils/colors.util.dart';
import 'package:new_chat_app/utils/routes_utils.dart';
import 'package:new_chat_app/views/screens/chat_page.dart';
import 'package:new_chat_app/views/screens/home_page.dart';
import 'package:new_chat_app/views/screens/login_page.dart';
import 'package:new_chat_app/views/screens/profile_page.dart';
import 'package:new_chat_app/views/screens/signup_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColor.color1,
          // ···
          brightness: Brightness.light,
        ),
      ),
      initialRoute: (AuthHelper.authHelper.firebaseAuth.currentUser == null)
          ? MyRoute.LoginPage
          : MyRoute.HomePage,
      routes: {
        MyRoute.LoginPage: (context) => LoginPage(),
        MyRoute.SignUpPage: (context) => SignUpPage(),
        MyRoute.HomePage: (context) => const HomePage(),
        MyRoute.profilePage: (context) => const ProfilePage(),
        MyRoute.chatPage: (context) => const ChatPage(),
      },
    );
  }
}
